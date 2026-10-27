import 'package:flutter/material.dart';

import '../../viewmodels/dashboard_viewmodel.dart';

import 'historical_gold_screen.dart';
import 'company_profile_screen.dart';
import 'news_screen.dart';

class DashboardScreen extends StatefulWidget {
  // ============================================================
  // CALLBACK KE MENU KALKULATOR
  // ============================================================

  final VoidCallback? onGoToCalculator;

  const DashboardScreen({super.key, this.onGoToCalculator});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
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

  late final DashboardViewModel _viewModel;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _viewModel = DashboardViewModel();

    _viewModel.addListener(_onViewModelChanged);

    _viewModel.initialize();
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
  // LOAD PROFILE
  // ============================================================

  Future<void> loadProfile() async {
    await _viewModel.loadProfile();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();

    super.dispose();
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
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        toolbarHeight: 64,
        titleSpacing: 20,

        // ==================================================
        // HEADER
        // ==================================================
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

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE8E8E8)),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              Text(
                _viewModel.nama,
                style: const TextStyle(
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

              // ==================================================
              // CARD PROFIL PERUSAHAAN
              // ==================================================
              const SizedBox(height: 16),

              _buildCompanyProfileCard(context),

              // ==================================================
              // CARD BERITA EKONOMI DAN KEUANGAN
              // ==================================================
              const SizedBox(height: 12),

              _buildNewsCard(context),

              const SizedBox(height: 34),
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
    final String latestDate = _viewModel.latestGoldData.date;
    final String latestOpen = _viewModel.latestGoldData.open;
    final String latestHigh = _viewModel.latestGoldData.high;
    final String latestLow = _viewModel.latestGoldData.low;
    final String latestClose = _viewModel.latestGoldData.close;

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
                      _viewModel.isLoadingGoldData
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
                  value: _viewModel.isLoadingGoldData ? '...' : latestOpen,
                ),
              ),

              Expanded(
                child: _buildPriceItem(
                  label: 'HIGH',
                  value: _viewModel.isLoadingGoldData ? '...' : latestHigh,
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
                  value: _viewModel.isLoadingGoldData ? '...' : latestLow,
                ),
              ),

              Expanded(
                child: _buildPriceItem(
                  label: 'CLOSE',
                  value: _viewModel.isLoadingGoldData ? '...' : latestClose,
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
  // COMPANY PROFILE CARD
  // ============================================================

  Widget _buildCompanyProfileCard(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(20),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CompanyProfileScreen(),
            ),
          );
        },

        child: Ink(
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

          child: Row(
            children: [
              // ==================================================
              // ICON PERUSAHAAN
              // ==================================================
              Container(
                width: 58,
                height: 58,

                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(16),
                ),

                child: const Icon(
                  Icons.business_rounded,
                  color: orangeColor,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              // ==================================================
              // INFORMASI CARD
              // ==================================================
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Perusahaan',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    SizedBox(height: 6),

                    Text(
                      'Kenali PT Equityworld Futures '
                      'dan informasi mengenai perusahaan.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 10),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Selengkapnya',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: orangeColor,
                          ),
                        ),

                        SizedBox(width: 6),

                        Icon(
                          Icons.arrow_forward_rounded,
                          color: orangeColor,
                          size: 17,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // NEWS CARD
  // ============================================================

  Widget _buildNewsCard(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(16),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewsScreen()),
          );
        },

        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),

            border: Border.all(color: const Color(0xFFFFE0C2), width: 1),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),

          child: Row(
            children: [
              // ==================================================
              // NEWS ICON
              // ==================================================
              Container(
                width: 46,
                height: 46,

                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(13),
                ),

                child: const Icon(
                  Icons.newspaper_rounded,
                  color: orangeColor,
                  size: 25,
                ),
              ),

              const SizedBox(width: 12),

              // ==================================================
              // NEWS INFORMATION
              // ==================================================
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berita Ekonomi & Keuangan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: darkBrown,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Berita terbaru Indonesia dan internasional',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.black54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // ==================================================
              // ARROW
              // ==================================================
              Container(
                width: 32,
                height: 32,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E7),
                  borderRadius: BorderRadius.circular(10),
                ),

                child: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                  color: orangeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
