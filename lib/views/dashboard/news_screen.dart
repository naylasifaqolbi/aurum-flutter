import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/news_model.dart';
import '../../services/news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color backgroundColor = Color(0xFFFFF8F0);
  static const Color orangeColor = Color(0xFFF28C28);
  static const Color darkBrown = Color(0xFF3D2B1F);
  static const Color lightOrange = Color(0xFFFFE5CC);

  // ============================================================
  // TAB CONTROLLER
  // ============================================================

  late final TabController _tabController;

  // ============================================================
  // NEWS DATA
  // ============================================================

  List<NewsModel> _indonesianNews = [];
  List<NewsModel> _englishNews = [];

  bool _isLoadingIndonesian = true;
  bool _isLoadingEnglish = true;

  String? _indonesianError;
  String? _englishError;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _loadAllNews();
  }

  // ============================================================
  // LOAD NEWS
  // ============================================================

  Future<void> _loadAllNews() async {
    await Future.wait([_loadIndonesianNews(), _loadEnglishNews()]);
  }

  Future<void> _loadIndonesianNews() async {
    if (mounted) {
      setState(() {
        _isLoadingIndonesian = true;
        _indonesianError = null;
      });
    }

    try {
      final news = await NewsService.getIndonesianNews();

      if (!mounted) return;

      setState(() {
        _indonesianNews = news;
        _isLoadingIndonesian = false;

        _indonesianError = news.isEmpty
            ? 'Belum ada berita relevan yang dapat ditampilkan. '
                  'Coba muat ulang beberapa saat lagi.'
            : null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingIndonesian = false;
        _indonesianError = 'Gagal memuat berita. Periksa koneksi internet.';
      });
    }
  }

  Future<void> _loadEnglishNews() async {
    if (mounted) {
      setState(() {
        _isLoadingEnglish = true;
        _englishError = null;
      });
    }

    try {
      final news = await NewsService.getEnglishNews();

      if (!mounted) return;

      setState(() {
        _englishNews = news;
        _isLoadingEnglish = false;

        _englishError = news.isEmpty
            ? 'No relevant articles are currently available. '
                  'Please try refreshing later.'
            : null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoadingEnglish = false;
        _englishError =
            'Unable to load news. Please check your internet connection.';
      });
    }
  }

  // ============================================================
  // OPEN ARTICLE
  // ============================================================

  Future<void> _openArticle(NewsModel news) async {
    final uri = Uri.tryParse(news.url);

    if (uri == null ||
        uri.scheme.toLowerCase() != 'https' ||
        uri.host.isEmpty) {
      _showMessage('Tautan berita tidak valid.');
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && mounted) {
        _showMessage('Artikel tidak dapat dibuka. Silakan coba lagi.');
      }
    } catch (_) {
      if (mounted) {
        _showMessage('Terjadi kendala saat membuka artikel.');
      }
    }
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: darkBrown,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Tanggal tidak tersedia';
    }

    final localDate = date.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year.toString();

    return '$day/$month/$year';
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _tabController.dispose();
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

        title: const Text(
          'Berita Ekonomi & Keuangan',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),

        iconTheme: const IconThemeData(color: darkBrown),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(58),

          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),

            child: Container(
              height: 46,

              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),

              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,

                indicator: BoxDecoration(
                  color: orangeColor,
                  borderRadius: BorderRadius.circular(12),
                ),

                labelColor: Colors.white,
                unselectedLabelColor: darkBrown,

                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),

                dividerColor: Colors.transparent,

                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.language, size: 18),
                        SizedBox(width: 6),
                        Text('Indonesia'),
                      ],
                    ),
                  ),

                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.public, size: 18),
                        SizedBox(width: 6),
                        Text('English'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: _tabController,

        children: [
          _buildNewsList(
            news: _indonesianNews,
            isLoading: _isLoadingIndonesian,
            error: _indonesianError,
            isEnglish: false,
            onRefresh: _loadIndonesianNews,
          ),

          _buildNewsList(
            news: _englishNews,
            isLoading: _isLoadingEnglish,
            error: _englishError,
            isEnglish: true,
            onRefresh: _loadEnglishNews,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NEWS LIST
  // ============================================================

  Widget _buildNewsList({
    required List<NewsModel> news,
    required bool isLoading,
    required String? error,
    required bool isEnglish,
    required Future<void> Function() onRefresh,
  }) {
    if (isLoading && news.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: orangeColor));
    }

    if (error != null && news.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.newspaper_rounded,
                size: 56,
                color: orangeColor.withOpacity(0.7),
              ),

              const SizedBox(height: 16),

              Text(
                error,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 14,
                  color: darkBrown,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 18),

              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(isEnglish ? 'Try Again' : 'Coba Lagi'),

                style: ElevatedButton.styleFrom(
                  backgroundColor: orangeColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: orangeColor,
      onRefresh: onRefresh,

      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),

        children: [
          // ======================================================
          // HEADER SECTION
          // ======================================================
          Container(
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: const Icon(
                    Icons.candlestick_chart_rounded,
                    color: orangeColor,
                    size: 29,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        isEnglish
                            ? 'Global Market Watch'
                            : 'Berita Pasar Global',

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkBrown,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        isEnglish
                            ? 'Gold, forex, Nikkei, Hang Seng, central banks and geopolitics.'
                            : 'Emas, forex, Nikkei, Hang Seng, bank sentral, dan geopolitik.',

                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ======================================================
          // NEWS SECTION TITLE
          // ======================================================
          Row(
            children: [
              Expanded(
                child: Text(
                  isEnglish ? 'Latest Market News' : 'Berita Pasar Terbaru',

                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),
              ),

              if (isLoading)
                const SizedBox(
                  width: 17,
                  height: 17,

                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: orangeColor,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            isEnglish
                ? 'Articles are filtered by relevant financial and geopolitical keywords.'
                : 'Berita disaring berdasarkan kata kunci pasar keuangan dan geopolitik.',

            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),

          const SizedBox(height: 16),

          // ======================================================
          // ARTICLE CARDS
          // ======================================================
          ...news.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),

              child: _buildNewsCard(item, isEnglish: isEnglish),
            ),
          ),

          if (news.isEmpty && !isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),

              child: Text(
                isEnglish
                    ? 'No relevant articles available.'
                    : 'Belum ada berita relevan yang tersedia.',

                textAlign: TextAlign.center,

                style: const TextStyle(color: Colors.black54),
              ),
            ),

          const SizedBox(height: 4),

          // ======================================================
          // DISCLAIMER
          // ======================================================
          Container(
            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFFFE0C2)),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: orangeColor,
                  size: 20,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    isEnglish
                        ? 'Articles are provided by third-party publishers. Their content and publication times may change. News may affect markets in different ways and is not financial advice.'
                        : 'Berita berasal dari penerbit pihak ketiga. Isi dan waktu publikasi dapat berubah. Dampak berita terhadap pasar dapat berbeda-beda. Informasi ini bukan saran investasi.',

                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.6,
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
  // NEWS CARD
  // ============================================================

  Widget _buildNewsCard(NewsModel news, {required bool isEnglish}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),

      child: InkWell(
        borderRadius: BorderRadius.circular(18),

        onTap: () => _openArticle(news),

        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),

            border: Border.all(color: const Color(0xFFFFE0C2)),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==================================================
              // SOURCE AND DATE
              // ==================================================
              Row(
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),

                      decoration: BoxDecoration(
                        color: lightOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      child: Text(
                        news.source,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: darkBrown,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  const Icon(
                    Icons.access_time_rounded,
                    size: 13,
                    color: Colors.black45,
                  ),

                  const SizedBox(width: 4),

                  Flexible(
                    child: Text(
                      _formatDate(news.publishedAt),
                      overflow: TextOverflow.ellipsis,

                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black45,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ==================================================
              // TITLE
              // ==================================================
              Text(
                news.title,

                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: darkBrown,
                  height: 1.45,
                ),
              ),

              // ==================================================
              // DESCRIPTION
              // ==================================================
              if (news.description.isNotEmpty) ...[
                const SizedBox(height: 9),

                Text(
                  news.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.6,
                  ),
                ),
              ],

              const SizedBox(height: 16),

              // ==================================================
              // OPEN ARTICLE
              // ==================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.end,

                children: [
                  Flexible(
                    child: Text(
                      isEnglish
                          ? 'Read Full Article'
                          : 'Baca Berita Selengkapnya',

                      textAlign: TextAlign.end,

                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: orangeColor,
                      ),
                    ),
                  ),

                  const SizedBox(width: 7),

                  const Icon(
                    Icons.open_in_new_rounded,
                    color: orangeColor,
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
