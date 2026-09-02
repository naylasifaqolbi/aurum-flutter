import 'package:flutter/material.dart';

import '../../services/historical_api_service.dart';
import 'physical_gold_formula_screen.dart';
import 'pivot_formula_screen.dart';
import 'historical_gold_screen.dart';

class DashboardScreen extends StatefulWidget {
  // ============================================================
  // CALLBACK KE MENU KALKULATOR
  // ============================================================

  final VoidCallback? onGoToCalculator;

  const DashboardScreen({super.key, this.onGoToCalculator});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ============================================================
  // COLOR
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);

  // ============================================================
  // CATEGORY DASHBOARD
  // ============================================================

  static const String _dashboardCategory = 'LGD Daily';

  // ============================================================
  // DATA HARGA TERBARU
  // ============================================================

  Map<String, String> _latestGoldData = {};

  // ============================================================
  // LOADING DATA
  // ============================================================

  bool _isLoadingGoldData = true;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _loadLatestGoldData();
  }

  // ============================================================
  // LOAD DATA LGD TERBARU
  // ============================================================

  Future<void> _loadLatestGoldData() async {
    try {
      // ========================================================
      // AMBIL DATA DARI HISTORICAL API SERVICE
      // ========================================================

      final Map<String, dynamic> result =
          await HistoricalApiService.getHistoricalData(
            category: _dashboardCategory,
            page: 1,
            limit: 10,
          );

      // ========================================================
      // AMBIL DATA DARI RESPONSE
      // ========================================================

      final dynamic rawData = result['data'];

      if (rawData is List && rawData.isNotEmpty) {
        final dynamic firstItem = rawData.first;

        if (firstItem is Map) {
          final Map<String, String> latestData = {
            'date': firstItem['date']?.toString() ?? '-',
            'open': firstItem['open']?.toString() ?? '-',
            'high': firstItem['high']?.toString() ?? '-',
            'low': firstItem['low']?.toString() ?? '-',
            'close': firstItem['close']?.toString() ?? '-',
          };

          if (!mounted) {
            return;
          }

          setState(() {
            _latestGoldData = latestData;
            _isLoadingGoldData = false;
          });

          return;
        }
      }

      // ========================================================
      // JIKA DATA KOSONG
      // ========================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _latestGoldData = {
          'date': '-',
          'open': '-',
          'high': '-',
          'low': '-',
          'close': '-',
        };

        _isLoadingGoldData = false;
      });
    } catch (_) {
      // ========================================================
      // JIKA API DAN CACHE TIDAK TERSEDIA
      // ========================================================

      if (!mounted) {
        return;
      }

      setState(() {
        _latestGoldData = {
          'date': '-',
          'open': '-',
          'high': '-',
          'low': '-',
          'close': '-',
        };

        _isLoadingGoldData = false;
      });
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

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
              // WELCOME
              // ==================================================
              const Text(
                'Selamat datang',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Rosalinda',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                'Semangat bekerja hari ini!',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // UPDATE DATA HARGA EMAS
              // ==================================================
              const Text(
                'UPDATE DATA HARGA EMAS TERBARU',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 14),

              // ==================================================
              // LGD DAILY CARD
              // ==================================================
              _buildGoldPriceCard(context),

              const SizedBox(height: 32),

              // ==================================================
              // KELOLA DAN ANALISIS
              // ==================================================
              _buildAboutAurumCard(context),

              const SizedBox(height: 34),

              // ==================================================
              // MENGENAL PERHITUNGAN
              // ==================================================
              const Text(
                'Mengenal Perhitungan AURUM',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Dua metode perhitungan utama yang '
                'tersedia di AURUM.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              // ==================================================
              // EMAS FISIK
              // ==================================================
              _buildCalculationCard(
                context: context,
                icon: Icons.monetization_on_outlined,
                title: 'Emas Fisik',
                description:
                    'Hitung keuntungan transaksi '
                    'emas berdasarkan data yang '
                    'kamu masukkan.',
                onFormulaTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PhysicalGoldFormulaScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ==================================================
              // PIVOT POINT
              // ==================================================
              _buildCalculationCard(
                context: context,
                icon: Icons.show_chart_rounded,
                title: 'Pivot Point',
                description:
                    'Tentukan indikasi BUY atau '
                    'SELL berdasarkan nilai Pivot '
                    'Point.',
                onFormulaTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PivotFormulaScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // GOLD PRICE CARD
  // ============================================================

  Widget _buildGoldPriceCard(BuildContext context) {
    // ==========================================================
    // AMBIL DATA TERBARU DARI HISTORICAL API SERVICE
    // ==========================================================

    final String latestDate = _latestGoldData['date'] ?? '-';

    final String latestOpen = _latestGoldData['open'] ?? '-';

    final String latestHigh = _latestGoldData['high'] ?? '-';

    final String latestLow = _latestGoldData['low'] ?? '-';

    final String latestClose = _latestGoldData['close'] ?? '-';

    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2), width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // LGD DAILY HEADER
          // ======================================================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(14),
                ),

                child: const Icon(
                  Icons.trending_up_rounded,
                  color: orangeColor,
                  size: 27,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'LGD Daily',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      _isLoadingGoldData
                          ? 'Memuat data...'
                          : _formatLatestDate(latestDate),

                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: const Color(0xFFE8F7EC),
                  borderRadius: BorderRadius.circular(20),
                ),

                child: const Text(
                  'LATEST',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E8B57),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ======================================================
          // PRICE DATA
          // ======================================================
          Row(
            children: [
              Expanded(
                child: _buildPriceItem(
                  label: 'OPEN',
                  value: _isLoadingGoldData ? '...' : latestOpen,
                ),
              ),

              Expanded(
                child: _buildPriceItem(
                  label: 'HIGH',
                  value: _isLoadingGoldData ? '...' : latestHigh,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _buildPriceItem(
                  label: 'LOW',
                  value: _isLoadingGoldData ? '...' : latestLow,
                ),
              ),

              Expanded(
                child: _buildPriceItem(
                  label: 'CLOSE',
                  value: _isLoadingGoldData ? '...' : latestClose,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ======================================================
          // HISTORICAL DATA
          // ======================================================
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoricalGoldScreen(),
                ),
              );
            },

            child: Container(
              width: double.infinity,

              padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 15),

              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E7),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: const Color(0xFFFFDFC0)),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: const [
                  Text(
                    'Lihat Historical Data',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: orangeColor,
                    ),
                  ),

                  SizedBox(width: 7),

                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: orangeColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORMAT TANGGAL
  // ============================================================

  String _formatLatestDate(String date) {
    if (date == '-' || date.isEmpty) {
      return '-';
    }

    try {
      final DateTime parsedDate = DateTime.parse(date);

      final String day = parsedDate.day.toString().padLeft(2, '0');

      final String month = parsedDate.month.toString().padLeft(2, '0');

      final String year = parsedDate.year.toString();

      return '$day/$month/$year';
    } catch (_) {
      // ========================================================
      // JIKA FORMAT TANGGAL SUDAH DALAM BENTUK STRING
      // ========================================================

      if (date.length >= 10) {
        return date.substring(0, 10);
      }

      return date;
    }
  }

  // ============================================================
  // PRICE ITEM
  // ============================================================

  Widget _buildPriceItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          label,

          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.black45,
            letterSpacing: 0.8,
          ),
        ),

        const SizedBox(height: 5),

        Text(
          value,

          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ABOUT AURUM CARD
  // ============================================================

  Widget _buildAboutAurumCard(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(22),

      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(color: const Color(0xFFFFD4AD), width: 1),

        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // TITLE
          // ======================================================
          const Text(
            'Kelola dan Analisis Emasmu',

            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: darkBrown,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 2),

          const Text(
            'dengan Lebih Mudah',

            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: orangeColor,
              height: 1.2,
            ),
          ),

          const SizedBox(height: 13),

          const Text(
            'Aurum membantu kamu menghitung '
            'nilai dan keuntungan emas fisik serta '
            'menganalisis pergerakan harga '
            'menggunakan Pivot Point.',

            style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.6),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // BUTTON MULAI MENGHITUNG
          // ======================================================
          SizedBox(
            width: double.infinity,
            height: 52,

            child: ElevatedButton(
              onPressed: widget.onGoToCalculator,

              style: ElevatedButton.styleFrom(
                backgroundColor: orangeColor,
                foregroundColor: Colors.white,
                elevation: 0,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: const [
                  Text(
                    'Mulai Menghitung Sekarang',

                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(width: 8),

                  Icon(Icons.arrow_forward_rounded, size: 19),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CALCULATION CARD
  // ============================================================

  Widget _buildCalculationCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onFormulaTap,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xFFFFE0C2), width: 1),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // ======================================================
          // ICON + TITLE
          // ======================================================
          Row(
            children: [
              Container(
                width: 52,
                height: 52,

                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Icon(icon, color: orangeColor, size: 29),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,

                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // ======================================================
          // DESCRIPTION
          // ======================================================
          Text(
            description,

            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          // ======================================================
          // LIHAT RUMUS
          // ======================================================
          GestureDetector(
            onTap: onFormulaTap,

            child: Row(
              mainAxisSize: MainAxisSize.min,

              children: const [
                Icon(Icons.functions_rounded, size: 17, color: orangeColor),

                SizedBox(width: 6),

                Text(
                  'Lihat Rumus',

                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: orangeColor,
                  ),
                ),

                SizedBox(width: 5),

                Icon(Icons.arrow_forward_ios, size: 11, color: orangeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
