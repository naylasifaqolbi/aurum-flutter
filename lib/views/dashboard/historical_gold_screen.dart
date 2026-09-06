import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/historical_api_service.dart';

class HistoricalGoldScreen extends StatefulWidget {
  const HistoricalGoldScreen({super.key});

  @override
  State<HistoricalGoldScreen> createState() => _HistoricalGoldScreenState();
}

class _HistoricalGoldScreenState extends State<HistoricalGoldScreen>
    with WidgetsBindingObserver {
  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);

  static const Color orangeColor = Color(0xFFF28C28);

  static const Color darkBrown = Color(0xFF3D2B1F);

  static const Color lightOrange = Color(0xFFFFE5CC);

  // ============================================================
  // CATEGORY
  // ============================================================

  static const List<String> _categories = [
    'LGD Daily',
    'HSI Daily',
    'SNI Daily',
  ];

  String _selectedCategory = HistoricalApiService.defaultCategory;

  // ============================================================
  // DATE
  // ============================================================

  DateTime? _startDate;

  DateTime? _endDate;

  // ============================================================
  // DATA
  // ============================================================

  List<Map<String, String>> _historicalData = [];

  // ============================================================
  // LOADING / ERROR
  // ============================================================

  bool _isLoading = false;

  String? _errorMessage;

  // ============================================================
  // CACHE STATUS
  // ============================================================

  bool _isFromCache = false;

  String? _cacheTime;

  // ============================================================
  // REQUEST LOCK
  // ============================================================

  bool _requestRunning = false;

  // ============================================================
  // PAGINATION
  // ============================================================

  int _currentPage = 1;

  int _totalPages = 1;

  // ============================================================
  // AUTO REFRESH
  // ============================================================

  Timer? _autoRefreshTimer;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _loadHistoricalData(showLoading: true);

    // ==========================================================
    // AUTO REFRESH 5 MENIT
    // ==========================================================

    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (mounted) {
        _loadHistoricalData(showLoading: false);
      }
    });
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _loadHistoricalData(showLoading: false);
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _autoRefreshTimer?.cancel();

    super.dispose();
  }

  // ============================================================
  // LOAD HISTORICAL DATA
  // ============================================================

  Future<void> _loadHistoricalData({bool showLoading = true}) async {
    // ==========================================================
    // CEGAH REQUEST DOUBLE
    // ==========================================================

    if (_requestRunning) {
      return;
    }

    _requestRunning = true;

    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;

        _errorMessage = null;
      });
    }

    try {
      // ========================================================
      // TAMPILKAN CACHE TERLEBIH DAHULU
      // ========================================================

      if (showLoading) {
        final cached = await HistoricalApiService.getCachedHistoricalData(
          category: _selectedCategory,
          startDate: _startDate,
          endDate: _endDate,
          page: _currentPage,
          limit: 10,
        );

        if (cached != null && mounted) {
          _applyResult(cached);

          setState(() {
            _isLoading = false;
          });
        }
      }

      // ========================================================
      // REQUEST KE BACKEND
      // ========================================================

      final result = await HistoricalApiService.getHistoricalData(
        category: _selectedCategory,
        startDate: _startDate,
        endDate: _endDate,
        page: _currentPage,
        limit: 10,
      );

      // ========================================================
      // APPLY RESULT
      // ========================================================

      if (mounted) {
        _applyResult(result);

        setState(() {
          _isLoading = false;

          _errorMessage = null;
        });
      }
    } catch (error) {
      // ========================================================
      // BACKEND OFF
      // CACHE SUDAH DICOBA OLEH SERVICE
      // ========================================================

      if (mounted) {
        if (_historicalData.isEmpty) {
          setState(() {
            _errorMessage =
                'Tidak dapat mengambil data '
                '$_selectedCategory.\n'
                'Pastikan backend aktif atau '
                'tersedia cache offline.';
          });
        }

        setState(() {
          _isLoading = false;
        });
      }
    } finally {
      _requestRunning = false;
    }
  }

  // ============================================================
  // APPLY RESULT
  // ============================================================

  void _applyResult(Map<String, dynamic> result) {
    final dynamic rawData = result['data'];

    final List<Map<String, String>> convertedData = [];

    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map) {
          convertedData.add({
            'date': item['date']?.toString() ?? '-',

            'open': item['open']?.toString() ?? '-',

            'high': item['high']?.toString() ?? '-',

            'low': item['low']?.toString() ?? '-',

            'close': item['close']?.toString() ?? '-',
          });
        }
      }
    }

    // ==========================================================
    // PAGINATION
    // ==========================================================

    final dynamic pagination = result['pagination'];

    if (pagination is Map) {
      _currentPage =
          int.tryParse(pagination['current_page']?.toString() ?? '') ??
          _currentPage;

      _totalPages =
          int.tryParse(pagination['total_pages']?.toString() ?? '') ?? 1;
    }

    // ==========================================================
    // CACHE STATUS
    // ==========================================================

    _isFromCache = result['fromCache'] == true;

    _cacheTime = result['cacheTime']?.toString();

    // ==========================================================
    // DATA
    // ==========================================================

    _historicalData = convertedData;
  }

  // ============================================================
  // CATEGORY CHANGED
  // ============================================================

  void _onCategoryChanged(String? value) {
    if (value == null || value == _selectedCategory) {
      return;
    }

    setState(() {
      _selectedCategory = value;

      // Reset pagination
      _currentPage = 1;

      // Bersihkan data kategori sebelumnya
      // agar data LGD tidak tampil saat
      // sedang mengambil HSI / SNI.
      _historicalData = [];

      _errorMessage = null;

      _isFromCache = false;

      _cacheTime = null;
    });

    _loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshData() async {
    if (_requestRunning) {
      return;
    }

    setState(() {
      _isLoading = true;

      _errorMessage = null;
    });

    await _loadHistoricalData(showLoading: false);

    if (!mounted) {
      return;
    }

    if (_errorMessage == null) {
      _showMessage('Data $_selectedCategory berhasil diperbarui.');
    }
  }

  // ============================================================
  // NEXT PAGE
  // ============================================================

  void _nextPage() {
    if (_currentPage >= _totalPages) {
      return;
    }

    setState(() {
      _currentPage++;
    });

    _loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // PREVIOUS PAGE
  // ============================================================

  void _previousPage() {
    if (_currentPage <= 1) {
      return;
    }

    setState(() {
      _currentPage--;
    });

    _loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // SELECT DATE
  // ============================================================

  Future<void> _selectDate({required bool isStart}) async {
    final DateTime initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? _startDate ?? DateTime.now());

    final DateTime? picked = await showDatePicker(
      context: context,

      initialDate: initialDate,

      firstDate: DateTime(2000),

      lastDate: DateTime.now(),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: orangeColor,
              onPrimary: Colors.white,
              onSurface: darkBrown,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) {
      return;
    }

    setState(() {
      if (isStart) {
        _startDate = picked;

        // Jika end date lebih kecil
        // dari start date, reset end date.
        if (_endDate != null && _endDate!.isBefore(picked)) {
          _endDate = null;
        }
      } else {
        _endDate = picked;
      }

      _currentPage = 1;
    });

    _loadHistoricalData(showLoading: true);
  }

  // ============================================================
  // SHOW MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: orangeColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Pilih tanggal';
    }

    final String day = date.day.toString().padLeft(2, '0');

    final String month = date.month.toString().padLeft(2, '0');

    final String year = date.year.toString();

    return '$day/$month/$year';
  }

  // ============================================================
  // FORMAT CACHE TIME
  // ============================================================

  String _formatCacheTime() {
    if (_cacheTime == null) {
      return '-';
    }

    try {
      final DateTime date = DateTime.parse(_cacheTime!).toLocal();

      final String day = date.day.toString().padLeft(2, '0');

      final String month = date.month.toString().padLeft(2, '0');

      final String year = date.year.toString();

      final String hour = date.hour.toString().padLeft(2, '0');

      final String minute = date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year $hour:$minute';
    } catch (_) {
      return _cacheTime!;
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: orangeColor,

        elevation: 0,

        title: const Text(
          'Historical Data Emas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SafeArea(
        child: RefreshIndicator(
          color: orangeColor,

          onRefresh: _refreshData,

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==================================================
                // HEADER
                // ==================================================
                _buildHeader(),

                const SizedBox(height: 24),

                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  'Historical Data Emas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Data Historis Emas',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Lihat data historis berdasarkan '
                  'kategori dengan informasi Open, '
                  'High, Low, dan Close.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // STATUS
                // ==================================================
                if (_historicalData.isNotEmpty) _buildStatusCard(),

                const SizedBox(height: 16),

                // ==================================================
                // FILTER
                // ==================================================
                _buildFilterCard(),

                const SizedBox(height: 20),

                // ==================================================
                // ERROR
                // ==================================================
                if (_errorMessage != null) _buildErrorCard(),

                // ==================================================
                // LOADING
                // ==================================================
                if (_isLoading && _historicalData.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: orangeColor),
                    ),
                  ),

                // ==================================================
                // TABLE
                // ==================================================
                if (_historicalData.isNotEmpty) _buildDataTable(),

                // ==================================================
                // PAGINATION
                // ==================================================
                if (_historicalData.isNotEmpty && _totalPages > 1)
                  _buildPagination(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        // ========================================================
        // LOGO
        // ========================================================
        Image.asset(
          'assets/images/logo.png',
          width: 45,
          height: 45,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: orangeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.auto_graph_rounded, color: Colors.white),
            );
          },
        ),

        const SizedBox(width: 12),

        // ========================================================
        // AURUM
        // ========================================================
        const Expanded(
          child: Text(
            'AURUM',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: orangeColor,
              letterSpacing: 1.5,
            ),
          ),
        ),

        // ========================================================
        // NOTIFICATION
        // ========================================================
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: orangeColor,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // STATUS CARD
  // ============================================================

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: _isFromCache ? lightOrange : Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(color: _isFromCache ? orangeColor : Colors.green),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _isFromCache ? orangeColor : Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isFromCache ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isFromCache ? 'Offline' : 'Online',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _isFromCache ? orangeColor : Colors.green,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _isFromCache
                      ? 'Menampilkan cache $_selectedCategory'
                      : 'Data $_selectedCategory terbaru',
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),

                if (_isFromCache && _cacheTime != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 3),
                    child: Text(
                      'Cache: ${_formatCacheTime()}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.black45,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FILTER CARD
  // ============================================================

  Widget _buildFilterCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // CATEGORY TITLE
          // ======================================================
          const Text(
            'KATEGORI',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 8),

          // ======================================================
          // CATEGORY DROPDOWN
          // ======================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),

            decoration: BoxDecoration(
              color: backgroundColor,

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: lightOrange),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: orangeColor,
                  size: 22,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,

                      isExpanded: true,

                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: orangeColor,
                      ),

                      dropdownColor: Colors.white,

                      borderRadius: BorderRadius.circular(12),

                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: darkBrown,
                      ),

                      items: _categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,

                          child: Text(category),
                        );
                      }).toList(),

                      onChanged: _isLoading ? null : _onCategoryChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // DATE FILTER
          // ======================================================
          const Text(
            'FILTER TANGGAL',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 1,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildDateButton(
                  label: 'Dari',
                  date: _startDate,
                  onTap: () => _selectDate(isStart: true),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildDateButton(
                  label: 'Sampai',
                  date: _endDate,
                  onTap: () => _selectDate(isStart: false),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ======================================================
          // REFRESH BUTTON
          // ======================================================
          SizedBox(
            width: double.infinity,

            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _refreshData,

              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,

                foregroundColor: Colors.white,

                padding: const EdgeInsets.symmetric(vertical: 13),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              icon: const Icon(Icons.refresh_rounded),

              label: const Text(
                'Refresh Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATE BUTTON
  // ============================================================

  Widget _buildDateButton({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,

      borderRadius: BorderRadius.circular(12),

      child: Container(
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: backgroundColor,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: lightOrange),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.black54),
            ),

            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 16,
                  color: orangeColor,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    _formatDate(date),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR CARD
  // ============================================================

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.red.shade50,

        borderRadius: BorderRadius.circular(14),

        border: Border.all(color: Colors.red.shade200),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red.shade700),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DATA TABLE
  // ============================================================

  Widget _buildDataTable() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // TABLE HEADER
          // ======================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),

            child: Row(
              children: [
                const Icon(Icons.bar_chart_rounded, color: orangeColor),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    _selectedCategory,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ======================================================
          // HORIZONTAL SCROLL
          // ======================================================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: DataTable(
              headingRowColor: WidgetStateProperty.resolveWith(
                (states) => lightOrange,
              ),

              columnSpacing: 24,

              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: darkBrown,
                fontSize: 12,
              ),

              dataTextStyle: const TextStyle(color: darkBrown, fontSize: 12),

              columns: const [
                DataColumn(label: Text('Tanggal')),

                DataColumn(label: Text('Open')),

                DataColumn(label: Text('High')),

                DataColumn(label: Text('Low')),

                DataColumn(label: Text('Close')),
              ],

              rows: _historicalData.map((Map<String, String> item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item['date'] ?? '-')),

                    DataCell(Text(item['open'] ?? '-')),

                    DataCell(Text(item['high'] ?? '-')),

                    DataCell(Text(item['low'] ?? '-')),

                    DataCell(Text(item['close'] ?? '-')),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAGINATION
  // ============================================================

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.only(top: 18),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          // ======================================================
          // PREVIOUS
          // ======================================================
          IconButton(
            onPressed: _currentPage > 1 ? _previousPage : null,

            style: IconButton.styleFrom(
              backgroundColor: _currentPage > 1
                  ? orangeColor
                  : Colors.grey.shade300,

              foregroundColor: Colors.white,
            ),

            icon: const Icon(Icons.chevron_left_rounded),
          ),

          const SizedBox(width: 16),

          Text(
            'Halaman $_currentPage '
            'dari $_totalPages',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(width: 16),

          // ======================================================
          // NEXT
          // ======================================================
          IconButton(
            onPressed: _currentPage < _totalPages ? _nextPage : null,

            style: IconButton.styleFrom(
              backgroundColor: _currentPage < _totalPages
                  ? orangeColor
                  : Colors.grey.shade300,

              foregroundColor: Colors.white,
            ),

            icon: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}
