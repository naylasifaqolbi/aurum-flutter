import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/history_model.dart';
import '../../viewmodels/history_viewmodel.dart';

import 'physical_gold_history_detail.dart';
import 'pivot_history_detail.dart';
import 'hangseng_history_detail.dart';
import 'nest_history_detail.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFF8E8);
  static const Color greenColor = Color(0xFF00B87A);
  static const Color lightGreen = Color(0xFFEAFBF5);

  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryViewModel>().loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      // ==================================================
      // HEADER
      // ==================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 20,

        title: Row(
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
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(24, 14, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // TITLE
              // ==================================================
              const Text(
                'Riwayat Perhitungan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Tinjau analisis Emas dan Pivot terbaru anda',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF555555),
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // FILTER
              // ==================================================
              _buildFilterList(),

              const SizedBox(height: 16),

              // ==================================================
              // HISTORY LIST
              // ==================================================
              _buildHistoryList(),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // FILTER LIST
  // ==================================================
  Widget _buildFilterList() {
    final filters = ['Semua', 'Emas Fisik', 'PP Emas', 'PP Hang Seng', 'Nest'];

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final filter = filters[index];

          return _buildFilter(
            label: filter,
            selected: _selectedFilter == filter,
          );
        },
      ),
    );
  }

  // ==================================================
  // FILTER BUTTON
  // ==================================================
  Widget _buildFilter({required String label, required bool selected}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? orangeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? orangeColor : const Color(0xFFE5E5E5),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF222222),
          ),
        ),
      ),
    );
  }

  // ==================================================
  // HISTORY LIST
  // ==================================================
  Widget _buildHistoryList() {
    return Consumer<HistoryViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: orangeColor),
            ),
          );
        }

        if (viewModel.errorMessage != null) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                'Gagal memuat riwayat.',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
          );
        }

        // Filter history berdasarkan pilihan user
        final filteredHistories = viewModel.histories.where((history) {
          if (_selectedFilter == 'Semua') {
            return true;
          }

          if (_selectedFilter == 'Emas Fisik') {
            return history.calculatorType == 'physical_gold';
          }

          if (_selectedFilter == 'PP Emas') {
            return history.calculatorType == 'pivot_gold';
          }

          if (_selectedFilter == 'PP Hang Seng') {
            return history.calculatorType == 'pivot_hangseng';
          }

          if (_selectedFilter == 'Nest') {
            return history.calculatorType == 'nest';
          }

          return false;
        }).toList();

        if (filteredHistories.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  const Icon(
                    Icons.history_rounded,
                    size: 48,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada riwayat perhitungan.',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${filteredHistories.length} riwayat ditemukan.',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 12),

            for (final history in filteredHistories)
              if (history.calculatorType == 'physical_gold')
                _buildPhysicalGoldCard(history),
          ],
        );
      },
    );
  }

  // ==================================================
  // EMAS FISIK
  // ==================================================
  Widget _buildPhysicalGoldCard(HistoryModel history) {
    final input = history.inputData;
    final result = history.resultData;

    final double modal = (input['modal'] as num).toDouble();
    final double hargaBeli = (input['harga_beli'] as num).toDouble();
    final double hargaJual = (input['harga_jual'] as num).toDouble();
    final double keuntungan = (result['keuntungan'] as num).toDouble();

    final date = history.createdAt.toLocal();

    return _buildHistoryCard(
      type: 'EMAS FISIK',
      date:
          '${date.day.toString().padLeft(2, '0')} '
          '${_getMonthName(date.month)} '
          '${date.year}, '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}',
      icon: Icons.monetization_on_outlined,
      resultLabel: 'Profit',
      resultValue:
          '${keuntungan >= 0 ? '+' : '-'}Rp ${_formatNumber(keuntungan.abs())}',
      details: [
        _DetailItem(
          label: 'Harga Beli/Jual',
          value: '${_formatNumber(hargaBeli)} / ${_formatNumber(hargaJual)}',
        ),
        _DetailItem(label: 'Modal', value: 'Rp ${_formatNumber(modal)}'),
      ],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhysicalGoldHistoryDetail(history: history),
          ),
        );
      },
    );
  }

  // ==================================================
  // PIVOT EMAS
  // ==================================================
  Widget _buildPivotGoldCard() {
    return _buildHistoryCard(
      type: 'PP EMAS',
      date: '24 Okt 2026, 09:15',
      icon: Icons.show_chart_rounded,
      resultLabel: 'Pivot Point Emas (LGD)',
      resultValue: '1972.80',
      details: [
        _DetailItem(label: 'High / Low / Close', value: '1985 / 1960 / 1972'),
      ],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PivotHistoryDetail()),
        );
      },
    );
  }

  // ==================================================
  // PIVOT HANG SENG
  // ==================================================
  Widget _buildPivotHangSengCard() {
    return _buildHistoryCard(
      type: 'PP HANG SENG',
      date: '24 Okt 2026, 09:15',
      icon: Icons.trending_up_rounded,
      resultLabel: 'Pivot Point Hang Seng (HSI)',
      resultValue: '24850.00',
      details: [
        _DetailItem(
          label: 'High / Low / Close',
          value: '24980 / 24720 / 24850',
        ),
      ],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HangsengHistoryDetail(),
          ),
        );
      },
    );
  }

  // ==================================================
  // NEST
  // ==================================================
  Widget _buildNestCard() {
    return _buildHistoryCard(
      type: 'NEST',
      date: '24 Okt 2026, 09:15',
      icon: Icons.account_tree_outlined,
      resultLabel: 'Nest',
      resultValue: 'BUY',
      details: [_DetailItem(label: 'Open / Close', value: '2650 / 2680')],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NestHistoryDetail()),
        );
      },
    );
  }

  // ==================================================
  // HISTORY CARD
  // ==================================================
  Widget _buildHistoryCard({
    required String type,
    required String date,
    required IconData icon,
    required String resultLabel,
    required String resultValue,
    required List<_DetailItem> details,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(15, 13, 15, 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.045),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // ==================================================
                // CARD HEADER
                // ==================================================
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: lightOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: orangeColor, size: 17),
                    ),

                    const SizedBox(width: 9),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: lightOrange,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: orangeColor,
                        ),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF777777),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ==================================================
                // MAIN RESULT
                // ==================================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          resultLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),

                      Text(
                        resultValue,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: greenColor,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          color: orangeColor,
                          size: 19,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Divider(height: 1, color: Color(0xFFF0F0F0)),

                const SizedBox(height: 9),

                // ==================================================
                // CARD DETAILS
                // ==================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < details.length; i++) ...[
                      Expanded(child: _buildDetailItem(details[i])),

                      if (i < details.length - 1) const SizedBox(width: 16),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================================================
  // DETAIL ITEM
  // ==================================================
  Widget _buildDetailItem(_DetailItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: const TextStyle(fontSize: 10, color: Color(0xFF777777)),
        ),

        const SizedBox(height: 3),

        Text(
          item.value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF172033),
          ),
        ),
      ],
    );
  }
}

// ==================================================
// FORMAT NUMBER
// ==================================================
String _formatNumber(double value) {
  return value
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
}

// ==================================================
// MONTH NAME
// ==================================================
String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  return months[month - 1];
}

// ==================================================
// DETAIL DATA
// ==================================================
class _DetailItem {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});
}
