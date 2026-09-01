import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/historical_api_service.dart';

class HistoricalGoldScreen extends StatefulWidget {
  const HistoricalGoldScreen({super.key});

  @override
  State<HistoricalGoldScreen> createState() => _HistoricalGoldScreenState();
}

class _HistoricalGoldScreenState extends State<HistoricalGoldScreen> {
  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);

  static const Color orangeColor = Color(0xFFF28C28);

  static const Color darkBrown = Color(0xFF3D2B1F);

  static const Color lightOrange = Color(0xFFFFE5CC);

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
  // STATE
  // ============================================================

  bool _isLoading = false;

  String? _errorMessage;

  // ============================================================
  // PAGINATION
  // ============================================================

  int _currentPage = 1;

  int _totalPages = 1;

  // ============================================================
  // AUTO REFRESH
  // ============================================================

  Timer? _refreshTimer;

  // ============================================================
  // INIT STATE
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Ambil data pertama kali halaman dibuka.
    _loadHistoricalData();

    // Auto refresh setiap 5 menit.
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      _loadHistoricalData(showLoading: false);
    });
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _refreshTimer?.cancel();

    super.dispose();
  }

  // ============================================================
  // LOAD HISTORICAL DATA
  // ============================================================

  Future<void> _loadHistoricalData({bool showLoading = true}) async {
    // ----------------------------------------------------------
    // LOADING
    // ----------------------------------------------------------

    if (showLoading && mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      // --------------------------------------------------------
      // REQUEST KE BACKEND
      // --------------------------------------------------------

      final Map<String, dynamic> result =
          await HistoricalApiService.getHistoricalData(
            startDate: _startDate,
            endDate: _endDate,
            page: _currentPage,
            limit: 10,
          );

      // --------------------------------------------------------
      // AMBIL DATA
      // --------------------------------------------------------

      final List<dynamic> rawData = result['data'] ?? [];

      // --------------------------------------------------------
      // KONVERSI JSON → DART MAP
      // --------------------------------------------------------

      final List<Map<String, String>> convertedData = rawData
          .map<Map<String, String>>((dynamic item) {
            final Map<String, dynamic> data = Map<String, dynamic>.from(item);

            return {
              'date': data['date']?.toString() ?? '-',

              'open': data['open']?.toString() ?? '-',

              'high': data['high']?.toString() ?? '-',

              'low': data['low']?.toString() ?? '-',

              'close': data['close']?.toString() ?? '-',
            };
          })
          .toList();

      // --------------------------------------------------------
      // PAGINATION
      // --------------------------------------------------------

      final Map<String, dynamic> pagination = result['pagination'] != null
          ? Map<String, dynamic>.from(result['pagination'])
          : {};

      final int currentPage = pagination['current_page'] is int
          ? pagination['current_page']
          : _currentPage;

      final int totalPages = pagination['total_pages'] is int
          ? pagination['total_pages']
          : 1;

      // --------------------------------------------------------
      // UPDATE UI
      // --------------------------------------------------------

      if (!mounted) {
        return;
      }

      setState(() {
        _historicalData = convertedData;

        _currentPage = currentPage;

        _totalPages = totalPages;

        _isLoading = false;

        _errorMessage = null;
      });
    } catch (e) {
      // --------------------------------------------------------
      // ERROR
      // --------------------------------------------------------

      debugPrint('Historical API Error: $e');

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;

        _errorMessage = 'Gagal mengambil data historical.';
      });
    }
  }

  // ============================================================
  // MANUAL REFRESH
  // ============================================================

  Future<void> _refreshData() async {
    await _loadHistoricalData();

    if (!mounted) {
      return;
    }

    if (_errorMessage == null) {
      _showMessage('Data historical berhasil diperbarui.');
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

    _loadHistoricalData();
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

    _loadHistoricalData();
  }

  // ============================================================
  // SELECT DATE
  // ============================================================

  Future<void> _selectDate({required bool isStart}) async {
    final DateTime now = DateTime.now();

    final DateTime initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);

    final DateTime? selectedDate = await showDatePicker(
      context: context,

      initialDate: initialDate,

      firstDate: DateTime(2020),

      lastDate: DateTime(now.year + 5),

      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: orangeColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: darkBrown,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    // ----------------------------------------------------------
    // START DATE
    // ----------------------------------------------------------

    if (isStart) {
      setState(() {
        _startDate = selectedDate;

        if (_endDate != null && _endDate!.isBefore(selectedDate)) {
          _endDate = null;
        }

        _currentPage = 1;
      });

      return;
    }

    // ----------------------------------------------------------
    // END DATE
    // ----------------------------------------------------------

    if (_startDate != null && selectedDate.isBefore(_startDate!)) {
      _showMessage('Tanggal akhir tidak boleh sebelum tanggal mulai.');

      return;
    }

    setState(() {
      _endDate = selectedDate;

      _currentPage = 1;
    });
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),

        backgroundColor: darkBrown,

        behavior: SnackBarBehavior.floating,

        margin: const EdgeInsets.all(16),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'dd/mm/yyyy';
    }

    final String day = date.day.toString().padLeft(2, '0');

    final String month = date.month.toString().padLeft(2, '0');

    final String year = date.year.toString();

    return '$day/$month/$year';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================
      appBar: AppBar(
        backgroundColor: backgroundColor,

        elevation: 0,

        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: darkBrown,
            size: 21,
          ),
        ),

        title: const Text(
          'Historical Data Emas',
          style: TextStyle(
            color: darkBrown,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: false,
      ),

      // ========================================================
      // BODY
      // ========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // HEADER
              // ==================================================
              Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png',

                    width: 42,

                    height: 42,

                    fit: BoxFit.contain,
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    'AURUM',

                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: orangeColor,
                      letterSpacing: 1,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 28,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                'Historical Data Emas',

                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: orangeColor,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Data Historis Emas',

                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Menampilkan data harga emas '
                'berdasarkan periode yang kamu pilih.',

                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // FILTER
              // ==================================================
              _buildFilterCard(),

              const SizedBox(height: 28),

              // ==================================================
              // TITLE DATA
              // ==================================================
              const Text(
                'Data Historis',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // DATA
              // ==================================================
              if (_isLoading)
                _buildLoadingCard()
              else if (_errorMessage != null)
                _buildErrorCard()
              else if (_historicalData.isEmpty)
                _buildEmptyDataCard()
              else
                _buildHistoricalTable(),

              const SizedBox(height: 20),

              // ==================================================
              // PAGINATION
              // ==================================================
              if (!_isLoading && _historicalData.isNotEmpty) _buildPagination(),

              const SizedBox(height: 10),
            ],
          ),
        ),
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

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),

            blurRadius: 12,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // KATEGORI
          // ======================================================
          const Text(
            'KATEGORI',

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,

            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

            decoration: BoxDecoration(
              color: backgroundColor,

              borderRadius: BorderRadius.circular(12),

              border: Border.all(color: const Color(0xFFFFE0C2)),
            ),

            child: const Row(
              children: [
                Icon(Icons.trending_up_rounded, color: orangeColor, size: 21),

                SizedBox(width: 10),

                Expanded(
                  child: Text(
                    'LGD Daily',

                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: darkBrown,
                    ),
                  ),
                ),

                Icon(Icons.keyboard_arrow_down_rounded, color: orangeColor),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // ======================================================
          // MULAI
          // ======================================================
          const Text(
            'MULAI',

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 8),

          _buildDateButton(
            date: _startDate,

            onTap: () {
              _selectDate(isStart: true);
            },
          ),

          const SizedBox(height: 15),

          // ======================================================
          // AKHIR
          // ======================================================
          const Text(
            'AKHIR',

            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 8),

          _buildDateButton(
            date: _endDate,

            onTap: () {
              _selectDate(isStart: false);
            },
          ),

          const SizedBox(height: 18),

          // ======================================================
          // REFRESH
          // ======================================================
          SizedBox(
            width: double.infinity,

            height: 48,

            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _refreshData,

              icon: const Icon(Icons.refresh_rounded, size: 20),

              label: const Text(
                'Refresh',

                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,

                foregroundColor: Colors.white,

                disabledBackgroundColor: Colors.grey.shade300,

                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
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
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: double.infinity,

        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

        decoration: BoxDecoration(
          color: backgroundColor,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(color: const Color(0xFFFFE0C2)),
        ),

        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              color: orangeColor,
              size: 20,
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                _formatDate(date),

                style: TextStyle(
                  fontSize: 14,

                  color: date == null ? const Color(0xFFAAAAAA) : darkBrown,

                  fontWeight: date == null
                      ? FontWeight.normal
                      : FontWeight.w600,
                ),
              ),
            ),

            const Icon(Icons.arrow_drop_down_rounded, color: orangeColor),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOADING CARD
  // ============================================================

  Widget _buildLoadingCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: const Column(
        children: [
          CircularProgressIndicator(color: orangeColor),

          SizedBox(height: 16),

          Text(
            'Mengambil data historical...',

            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkBrown,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR CARD
  // ============================================================

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2)),
      ),

      child: Column(
        children: [
          const Icon(Icons.error_outline_rounded, color: orangeColor, size: 40),

          const SizedBox(height: 12),

          const Text(
            'Gagal mengambil data',

            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Periksa koneksi backend '
            'kemudian coba lagi.',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
          ),

          const SizedBox(height: 15),

          ElevatedButton(
            onPressed: _loadHistoricalData,

            style: ElevatedButton.styleFrom(
              backgroundColor: orangeColor,

              foregroundColor: Colors.white,
            ),

            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY DATA
  // ============================================================

  Widget _buildEmptyDataCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            width: 62,

            height: 62,

            decoration: BoxDecoration(
              color: lightOrange,

              borderRadius: BorderRadius.circular(18),
            ),

            child: const Icon(
              Icons.bar_chart_rounded,

              color: orangeColor,

              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'Data Belum Tersedia',

            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: darkBrown,
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Data historis emas akan '
            'ditampilkan setelah tersedia.',

            textAlign: TextAlign.center,

            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HISTORICAL TABLE
  // ============================================================

  Widget _buildHistoricalTable() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        border: Border.all(color: const Color(0xFFFFE0C2)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),

            blurRadius: 10,

            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        children: [
          // ======================================================
          // TABLE HEADER
          // ======================================================
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

            decoration: const BoxDecoration(
              color: Color(0xFFFFEAD6),

              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),

            child: const Row(
              children: [
                Expanded(
                  flex: 2,

                  child: Text(
                    'Tanggal',

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    'Open',

                    textAlign: TextAlign.right,

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    'High',

                    textAlign: TextAlign.right,

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    'Low',

                    textAlign: TextAlign.right,

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ),

                Expanded(
                  child: Text(
                    'Close',

                    textAlign: TextAlign.right,

                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: darkBrown,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ======================================================
          // DATA
          // ======================================================
          ..._historicalData.map((Map<String, String> data) {
            return _buildHistoricalRow(data);
          }),
        ],
      ),
    );
  }

  // ============================================================
  // HISTORICAL ROW
  // ============================================================

  Widget _buildHistoricalRow(Map<String, String> data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),

      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0E5DA))),
      ),

      child: Row(
        children: [
          Expanded(
            flex: 2,

            child: Text(
              data['date'] ?? '-',

              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: darkBrown,
              ),
            ),
          ),

          Expanded(
            child: Text(
              data['open'] ?? '-',

              textAlign: TextAlign.right,

              style: const TextStyle(fontSize: 11, color: darkBrown),
            ),
          ),

          Expanded(
            child: Text(
              data['high'] ?? '-',

              textAlign: TextAlign.right,

              style: const TextStyle(fontSize: 11, color: darkBrown),
            ),
          ),

          Expanded(
            child: Text(
              data['low'] ?? '-',

              textAlign: TextAlign.right,

              style: const TextStyle(fontSize: 11, color: darkBrown),
            ),
          ),

          Expanded(
            child: Text(
              data['close'] ?? '-',

              textAlign: TextAlign.right,

              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: darkBrown,
              ),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [
        // --------------------------------------------------------
        // PREVIOUS
        // --------------------------------------------------------
        _buildPageButton(
          icon: Icons.chevron_left_rounded,

          onTap: _previousPage,
        ),

        const SizedBox(width: 10),

        // --------------------------------------------------------
        // PAGE
        // --------------------------------------------------------
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),

          decoration: BoxDecoration(
            color: orangeColor,

            borderRadius: BorderRadius.circular(10),
          ),

          child: Text(
            '$_currentPage / $_totalPages',

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 10),

        // --------------------------------------------------------
        // NEXT
        // --------------------------------------------------------
        _buildPageButton(icon: Icons.chevron_right_rounded, onTap: _nextPage),
      ],
    );
  }

  // ============================================================
  // PAGE BUTTON
  // ============================================================

  Widget _buildPageButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final bool disabled =
        (icon == Icons.chevron_left_rounded && _currentPage <= 1) ||
        (icon == Icons.chevron_right_rounded && _currentPage >= _totalPages);

    return GestureDetector(
      onTap: disabled ? null : onTap,

      child: Container(
        width: 34,

        height: 34,

        decoration: BoxDecoration(
          color: disabled ? Colors.grey.shade200 : Colors.white,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: disabled ? Colors.grey.shade300 : const Color(0xFFFFE0C2),
          ),
        ),

        child: Icon(
          icon,

          size: 20,

          color: disabled ? Colors.grey : orangeColor,
        ),
      ),
    );
  }
}
