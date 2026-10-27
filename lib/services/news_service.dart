import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

import '../models/news_model.dart';

class NewsService {
  // ============================================================
  // RSS FEED BAHASA INDONESIA
  // ============================================================

  static const Map<String, String> _indonesianFeeds = {
    'CNBC Indonesia': 'https://www.cnbcindonesia.com/rss',
    'ANTARA Ekonomi': 'https://www.antaranews.com/rss/ekonomi.xml',
    'ANTARA Finansial': 'https://www.antaranews.com/rss/ekonomi-finansial.xml',
  };

  // ============================================================
  // RSS FEED BAHASA INGGRIS
  // ============================================================

  static const Map<String, String> _englishFeeds = {
    'CNBC Markets': 'https://www.cnbc.com/id/10000664/device/rss/rss.html',
    'CNBC Business': 'https://www.cnbc.com/id/10001147/device/rss/rss.html',
    'BBC Business': 'https://feeds.bbci.co.uk/news/business/rss.xml',
  };

  // ============================================================
  // KATA KUNCI BERITA INDONESIA
  // ============================================================

  static const List<String> _indonesianKeywords = [
    // Emas dan komoditas
    'emas',
    'harga emas',
    'emas dunia',
    'logam mulia',
    'xau',
    'xauusd',
    'xau/usd',
    'gold',
    'bullion',
    'komoditas',

    // Forex dan kurs
    'forex',
    'valuta asing',
    'nilai tukar',
    'kurs',
    'dolar',
    'dollar',
    'dolar as',
    'rupiah',
    'yen',
    'yuan',
    'mata uang',
    'usd/idr',
    'usd/jpy',
    'usd/cnh',
    'pasar valuta',

    // Suku bunga dan bank sentral
    'suku bunga',
    'the fed',
    'federal reserve',
    'bank sentral',
    'inflasi',
    'obligasi',
    'imbal hasil',
    'yield',
    'kebijakan moneter',
    'bank indonesia',
    'bank of japan',
    'boj',

    // Nikkei dan Jepang
    'nikkei',
    'nikkei 225',
    'indeks jepang',
    'bursa jepang',
    'ekonomi jepang',
    'saham jepang',

    // Hang Seng dan China
    'hang seng',
    'hang seng index',
    'hong kong',
    'indeks hong kong',
    'bursa hong kong',
    'ekonomi china',
    'ekonomi tiongkok',
    'saham china',
    'saham tiongkok',
    'pasar china',
    'stimulus china',
    'bank sentral china',
    'properti china',

    // Pasar keuangan dan indeks
    'indeks saham',
    'indeks saham global',
    'bursa saham',
    'pasar saham',
    'wall street',
    'saham global',
    'perdagangan saham',
    'pasar keuangan',
    'pasar global',
    'indeks berjangka',
    'futures',
    'trading',
    'perdagangan berjangka',

    // Ekonomi global
    'pertumbuhan ekonomi',
    'data ekonomi',
    'ekonomi global',
    'ekonomi amerika',
    'ekonomi as',
    'ekspor',
    'impor',
    'tarif dagang',
    'perang dagang',
    'sanksi ekonomi',

    // Perang dan geopolitik
    'perang',
    'konflik',
    'serangan',
    'geopolitik',
    'ketegangan',
    'gencatan senjata',
    'timur tengah',
    'iran',
    'israel',
    'ukraina',
    'rusia',
    'china',
    'tiongkok',
    'amerika serikat',
  ];

  // ============================================================
  // KATA KUNCI BERITA INGGRIS
  // ============================================================

  static const List<String> _englishKeywords = [
    // Gold and commodities
    'gold',
    'gold price',
    'bullion',
    'xau',
    'xauusd',
    'xau/usd',
    'precious metals',
    'commodities',
    'oil prices',
    'crude oil',

    // Forex and currencies
    'forex',
    'foreign exchange',
    'currency',
    'currencies',
    'exchange rate',
    'us dollar',
    'u.s. dollar',
    'dollar index',
    'greenback',
    'rupiah',
    'japanese yen',
    'yen',
    'yuan',
    'renminbi',
    'usd/idr',
    'usd/jpy',
    'usd/cnh',
    'currency market',

    // Central banks and interest rates
    'federal reserve',
    'the fed',
    'fed rate',
    'interest rate',
    'rate cut',
    'rate hike',
    'monetary policy',
    'inflation',
    'bond yields',
    'treasury yields',
    'central bank',
    'bank of japan',
    'boj',
    'people’s bank of china',
    'peoples bank of china',
    'bank of china',
    'bank indonesia',

    // Japan and Nikkei
    'nikkei',
    'nikkei 225',
    'japan stocks',
    'japanese stocks',
    'japanese economy',
    'tokyo stock exchange',
    'japan inflation',
    'japan gdp',

    // Hong Kong and China
    'hang seng',
    'hang seng index',
    'hong kong stocks',
    'hong kong market',
    'china economy',
    'chinese economy',
    'chinese stocks',
    'china stocks',
    'china stimulus',
    'chinese stimulus',
    'china property',
    'chinese property',
    'china trade',
    'china tariffs',
    'china growth',

    // Global markets and trading
    'stock market',
    'stock markets',
    'global markets',
    'financial markets',
    'market futures',
    'index futures',
    'stock index',
    'equity index',
    'trading',
    'futures trading',
    'market volatility',
    'risk sentiment',
    'safe haven',
    'safe-haven',
    'investor sentiment',

    // Economic indicators
    'economic growth',
    'economic data',
    'global economy',
    'us economy',
    'u.s. economy',
    'jobs report',
    'nonfarm payrolls',
    'retail sales',
    'manufacturing data',
    'trade war',
    'trade tariffs',
    'economic sanctions',

    // War and geopolitics
    'war',
    'armed conflict',
    'military strike',
    'airstrike',
    'geopolitical',
    'geopolitics',
    'ceasefire',
    'middle east',
    'iran',
    'israel',
    'ukraine',
    'russia',
    'china tensions',
    'us-china',
    'u.s.-china',
    'trade tensions',
    'sanctions',
  ];

  // ============================================================
  // PUBLIC METHOD
  // ============================================================

  static Future<List<NewsModel>> getIndonesianNews() {
    return _loadFeeds(feeds: _indonesianFeeds, keywords: _indonesianKeywords);
  }

  static Future<List<NewsModel>> getEnglishNews() {
    return _loadFeeds(feeds: _englishFeeds, keywords: _englishKeywords);
  }

  // ============================================================
  // LOAD MULTIPLE RSS FEEDS
  // ============================================================

  static Future<List<NewsModel>> _loadFeeds({
    required Map<String, String> feeds,
    required List<String> keywords,
  }) async {
    final results = await Future.wait(
      feeds.entries.map((entry) async {
        try {
          return await _fetchFeed(
            source: entry.key,
            feedUrl: entry.value,
            keywords: keywords,
          );
        } catch (_) {
          // Jika satu feed gagal, feed lain tetap diproses.
          return <NewsModel>[];
        }
      }),
    );

    final List<NewsModel> news = [];

    for (final result in results) {
      news.addAll(result);
    }

    // ==========================================================
    // HAPUS DUPLIKAT
    // ==========================================================

    final Map<String, NewsModel> uniqueNews = {};

    for (final item in news) {
      final normalizedUrl = _normalizeUrl(item.url);

      if (item.title.trim().isEmpty ||
          normalizedUrl.isEmpty ||
          !_isValidArticleUrl(item.url)) {
        continue;
      }

      uniqueNews.putIfAbsent(normalizedUrl, () => item);
    }

    final List<NewsModel> sortedNews = uniqueNews.values.toList();

    // ==========================================================
    // URUTKAN BERITA TERBARU
    // ==========================================================

    sortedNews.sort((a, b) {
      if (a.publishedAt == null && b.publishedAt == null) {
        return 0;
      }

      if (a.publishedAt == null) {
        return 1;
      }

      if (b.publishedAt == null) {
        return -1;
      }

      return b.publishedAt!.compareTo(a.publishedAt!);
    });

    return sortedNews;
  }

  // ============================================================
  // FETCH RSS
  // ============================================================

  static Future<List<NewsModel>> _fetchFeed({
    required String source,
    required String feedUrl,
    required List<String> keywords,
  }) async {
    final response = await http
        .get(
          Uri.parse(feedUrl),
          headers: const {
            'Accept': 'application/rss+xml, application/xml, text/xml, */*',
            'User-Agent': 'AurumFinanceNews/1.0',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil berita dari $source');
    }

    final document = XmlDocument.parse(response.body);

    final items = document.findAllElements('item');

    final List<NewsModel> news = [];

    for (final item in items) {
      final title = _cleanDescription(_readElement(item, 'title'));
      final description = _cleanDescription(_readElement(item, 'description'));

      final link = _readElement(item, 'link').trim();

      final publishedText = _readElement(item, 'pubDate');

      final publishedAt =
          DateTime.tryParse(publishedText) ?? _tryParseRssDate(publishedText);

      // ========================================================
      // VALIDASI ARTIKEL
      // ========================================================

      if (title.isEmpty || !_isValidArticleUrl(link)) {
        continue;
      }

      // ========================================================
      // FILTER RELEVANSI
      // ========================================================

      if (!_isRelevant(
        title: title,
        description: description,
        keywords: keywords,
      )) {
        continue;
      }

      news.add(
        NewsModel(
          title: title,
          description: description,
          url: link,
          source: source,
          publishedAt: publishedAt,
        ),
      );
    }

    return news;
  }

  // ============================================================
  // FILTER BERITA RELEVAN
  // ============================================================

  static bool _isRelevant({
    required String title,
    required String description,
    required List<String> keywords,
  }) {
    final text = _normalizeText('$title $description');

    return keywords.any((keyword) {
      final normalizedKeyword = _normalizeText(keyword);

      if (normalizedKeyword.isEmpty) {
        return false;
      }

      return text.contains(normalizedKeyword);
    });
  }

  // ============================================================
  // NORMALISASI TEKS
  // ============================================================

  static String _normalizeText(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[\u2018\u2019]'), "'")
        .replaceAll(RegExp(r'[\u2010-\u2015]'), '-')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ============================================================
  // NORMALISASI URL UNTUK CEGAH DUPLIKAT
  // ============================================================

  static String _normalizeUrl(String value) {
    final uri = Uri.tryParse(value.trim());

    if (uri == null || uri.host.isEmpty) {
      return '';
    }

    // Parameter pelacakan tidak diperlukan untuk membedakan artikel.
    final filteredQuery = Map<String, String>.fromEntries(
      uri.queryParameters.entries.where((entry) {
        final key = entry.key.toLowerCase();

        return !key.startsWith('utm_') && key != 'fbclid' && key != 'gclid';
      }),
    );

    return uri
        .replace(
          fragment: '',
          queryParameters: filteredQuery.isEmpty ? null : filteredQuery,
        )
        .toString()
        .replaceFirst(RegExp(r'/$'), '');
  }

  // ============================================================
  // READ XML ELEMENT
  // ============================================================

  static String _readElement(XmlElement parent, String name) {
    final elements = parent.findElements(name);

    if (elements.isEmpty) {
      return '';
    }

    return elements.first.innerText.trim();
  }

  // ============================================================
  // CLEAN HTML DESCRIPTION
  // ============================================================

  static String _cleanDescription(String value) {
    return value
        .replaceAll(
          RegExp(r'<script[\s\S]*?</script>', caseSensitive: false),
          ' ',
        )
        .replaceAll(
          RegExp(r'<style[\s\S]*?</style>', caseSensitive: false),
          ' ',
        )
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'&nbsp;|&#160;|&#xA0;', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'&amp;'), '&')
        .replaceAll(RegExp(r'&quot;'), '"')
        .replaceAll(RegExp(r'&#39;|&apos;'), "'")
        .replaceAll(RegExp(r'&lt;'), '<')
        .replaceAll(RegExp(r'&gt;'), '>')
        .replaceAll(RegExp(r'&#(\d+);'), ' ')
        .replaceAll(RegExp(r'&#x([0-9a-f]+);', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  // ============================================================
  // PARSE RSS DATE
  // ============================================================

  static DateTime? _tryParseRssDate(String value) {
    if (value.trim().isEmpty) {
      return null;
    }

    // Contoh:
    // Tue, 27 Oct 2026 09:00:00 +0700
    // Tue, 27 Oct 2026 02:00:00 GMT

    final match = RegExp(
      r'^\w{3},?\s+(\d{1,2})\s+'
      r'(\w{3})\s+(\d{4})\s+'
      r'(\d{2}):(\d{2})(?::(\d{2}))?\s*'
      r'(GMT|UTC|[+-]\d{4})?$',
      caseSensitive: false,
    ).firstMatch(value.trim());

    if (match == null) {
      return null;
    }

    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };

    final month = months[match.group(2)!.toLowerCase()];

    final day = int.tryParse(match.group(1)!);
    final year = int.tryParse(match.group(3)!);
    final hour = int.tryParse(match.group(4)!);
    final minute = int.tryParse(match.group(5)!);
    final second = int.tryParse(match.group(6) ?? '0');

    if (month == null ||
        day == null ||
        year == null ||
        hour == null ||
        minute == null ||
        second == null) {
      return null;
    }

    final zone = (match.group(7) ?? 'GMT').toUpperCase();

    final dateUtc = DateTime.utc(year, month, day, hour, minute, second);

    if (zone == 'GMT' || zone == 'UTC') {
      return dateUtc;
    }

    final sign = zone.startsWith('-') ? -1 : 1;
    final zoneHours = int.tryParse(zone.substring(1, 3));
    final zoneMinutes = int.tryParse(zone.substring(3, 5));

    if (zoneHours == null || zoneMinutes == null) {
      return dateUtc;
    }

    final offsetMinutes = sign * (zoneHours * 60 + zoneMinutes);

    // Waktu lokal RSS dikonversi menjadi UTC.
    return dateUtc.subtract(Duration(minutes: offsetMinutes));
  }

  // ============================================================
  // VALIDATE ARTICLE URL
  // ============================================================

  static bool _isValidArticleUrl(String value) {
    final uri = Uri.tryParse(value.trim());

    return uri != null &&
        uri.scheme.toLowerCase() == 'https' &&
        uri.host.isNotEmpty;
  }
}
