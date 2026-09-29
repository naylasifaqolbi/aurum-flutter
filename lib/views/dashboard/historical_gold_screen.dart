import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/historical_gold_model.dart';
import '../../viewmodels/historical_gold_viewmodel.dart';

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
  // VIEWMODEL
  // ============================================================

  final HistoricalGoldViewModel _viewModel = HistoricalGoldViewModel();

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

    _viewModel.addListener(_onViewModelChanged);

    _viewModel.loadHistoricalData(showLoading: true);

    // ==========================================================
    // AUTO REFRESH 5 MENIT
    // ==========================================================

    _autoRefreshTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (mounted) {
        _viewModel.loadHistoricalData(showLoading: false);
      }
    });
  }

  // ============================================================
  // VIEWMODEL LISTENER
  // ============================================================

  void _onViewModelChanged() {
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      _viewModel.loadHistoricalData(showLoading: false);
    }
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _autoRefreshTimer?.cancel();

    _viewModel.removeListener(_onViewModelChanged);

    _viewModel.dispose();

    super.dispose();
  }

  // ============================================================
  // REFRESH
  // ============================================================

  Future<void> _refreshData() async {
    if (_viewModel.requestRunning) {
      return;
    }

    final bool success = await _viewModel.refreshData();

    if (!mounted) {
      return;
    }

    if (success) {
      _showMessage('Data ${_viewModel.selectedCategory} berhasil diperbarui.');
    }
  }

  // ============================================================
  // SELECT DATE
  // ============================================================

  Future<void> _selectDate({required bool isStart}) async {
    final DateTime initialDate = isStart
        ? (_viewModel.startDate ?? DateTime.now())
        : (_viewModel.endDate ?? _viewModel.startDate ?? DateTime.now());

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

    if (isStart) {
      await _viewModel.setStartDate(picked);
    } else {
      await _viewModel.setEndDate(picked);
    }
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
    final String? cacheTime = _viewModel.cacheTime;

    if (cacheTime == null) {
      return '-';
    }

    try {
      final DateTime date = DateTime.parse(cacheTime).toLocal();

      final String day = date.day.toString().padLeft(2, '0');

      final String month = date.month.toString().padLeft(2, '0');

      final String year = date.year.toString();

      final String hour = date.hour.toString().padLeft(2, '0');

      final String minute = date.minute.toString().padLeft(2, '0');

      return '$day/$month/$year $hour:$minute';
    } catch (_) {
      return cacheTime;
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
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkBrown,
            size: 25,
          ),
        ),

        title: const Text(
          'Historical Data Emas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: orangeColor,
          ),
        ),
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

                const SizedBox(height: 1),

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
                if (_viewModel.historicalData.isNotEmpty) _buildStatusCard(),

                const SizedBox(height: 16),

                // ==================================================
                // FILTER
                // ==================================================
                _buildFilterCard(),

                const SizedBox(height: 20),

                // ==================================================
                // ERROR
                // ==================================================
                if (_viewModel.errorMessage != null) _buildErrorCard(),

                // ==================================================
                // LOADING
                // ==================================================
                if (_viewModel.isLoading && _viewModel.historicalData.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(color: orangeColor),
                    ),
                  ),

                // ==================================================
                // TABLE
                // ==================================================
                if (_viewModel.historicalData.isNotEmpty) _buildDataTable(),

                // ==================================================
                // PAGINATION
                // ==================================================
                if (_viewModel.historicalData.isNotEmpty &&
                    _viewModel.totalPages > 1)
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
    return Row(children: [const SizedBox(width: 12)]);
  }

  // ============================================================
  // STATUS CARD
  // ============================================================

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: _viewModel.isFromCache ? lightOrange : Colors.white,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: _viewModel.isFromCache ? orangeColor : Colors.green,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: _viewModel.isFromCache ? orangeColor : Colors.green,

              shape: BoxShape.circle,
            ),

            child: Icon(
              _viewModel.isFromCache
                  ? Icons.cloud_off_rounded
                  : Icons.cloud_done_rounded,

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
                  _viewModel.isFromCache ? 'Offline' : 'Online',

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _viewModel.isFromCache ? orangeColor : Colors.green,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _viewModel.isFromCache
                      ? 'Menampilkan cache '
                            '${_viewModel.selectedCategory}'
                      : 'Data '
                            '${_viewModel.selectedCategory} terbaru',

                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),

                if (_viewModel.isFromCache && _viewModel.cacheTime != null)
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
                      value: _viewModel.selectedCategory,

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

                      items: HistoricalGoldViewModel.categories.map((
                        String category,
                      ) {
                        return DropdownMenuItem<String>(
                          value: category,

                          child: Text(category),
                        );
                      }).toList(),

                      onChanged: _viewModel.isLoading
                          ? null
                          : (value) async {
                              await _viewModel.changeCategory(value);
                            },
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
                  date: _viewModel.startDate,
                  onTap: () => _selectDate(isStart: true),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildDateButton(
                  label: 'Sampai',
                  date: _viewModel.endDate,
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
              onPressed: _viewModel.isLoading ? null : _refreshData,

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
              _viewModel.errorMessage!,

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
                    _viewModel.selectedCategory,

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

              rows: _viewModel.historicalData.map((HistoricalGoldModel item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.date)),

                    DataCell(Text(item.open)),

                    DataCell(Text(item.high)),

                    DataCell(Text(item.low)),

                    DataCell(Text(item.close)),
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
            onPressed: _viewModel.currentPage > 1
                ? () async {
                    await _viewModel.previousPage();
                  }
                : null,

            style: IconButton.styleFrom(
              backgroundColor: _viewModel.currentPage > 1
                  ? orangeColor
                  : Colors.grey.shade300,

              foregroundColor: Colors.white,
            ),

            icon: const Icon(Icons.chevron_left_rounded),
          ),

          const SizedBox(width: 16),

          Text(
            'Halaman ${_viewModel.currentPage} '
            'dari ${_viewModel.totalPages}',

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
            onPressed: _viewModel.currentPage < _viewModel.totalPages
                ? () async {
                    await _viewModel.nextPage();
                  }
                : null,

            style: IconButton.styleFrom(
              backgroundColor: _viewModel.currentPage < _viewModel.totalPages
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
