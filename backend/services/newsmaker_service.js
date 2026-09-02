const https = require('https');

// ============================================================
// NEWSMAKER API
// ============================================================

const NEWSMAKER_URL =
  'https://www.newsmaker.id/api/historical-data';

// ============================================================
// KATEGORI YANG DIPERBOLEHKAN
// ============================================================

const AVAILABLE_CATEGORIES = [
  'LGD Daily',
  'HSI Daily',
  'SNI Daily',
];

const DEFAULT_CATEGORY = 'LGD Daily';

// ============================================================
// NORMALIZE CATEGORY
// ============================================================

function normalizeCategory(value) {
  return String(value ?? '')
    .trim()
    .toLowerCase();
}

// ============================================================
// CARI NAMA KATEGORI RESMI
// ============================================================

function getCanonicalCategory(category) {
  const normalized = normalizeCategory(category);

  return (
    AVAILABLE_CATEGORIES.find(
      (item) => normalizeCategory(item) === normalized
    ) ?? null
  );
}

// ============================================================
// GET HISTORICAL DATA
// ============================================================

async function getHistoricalData({
  category = DEFAULT_CATEGORY,
  startDate,
  endDate,
  page = 1,
  limit = 10,
}) {
  return new Promise((resolve, reject) => {
    // ========================================================
    // VALIDASI CATEGORY
    // ========================================================

    const selectedCategory =
      getCanonicalCategory(category);

    if (!selectedCategory) {
      return reject(
        new Error(
          `Kategori tidak tersedia: ${category}. ` +
          `Kategori yang tersedia: ${AVAILABLE_CATEGORIES.join(', ')}`
        )
      );
    }

    // ========================================================
    // REQUEST KE NEWSMAKER
    // ========================================================

    const request = https.get(
      NEWSMAKER_URL,
      {
        headers: {
          'User-Agent': 'Mozilla/5.0',
          Accept: 'application/json',
        },
      },
      (response) => {
        let body = '';

        response.setEncoding('utf8');

        // ======================================================
        // TERIMA DATA
        // ======================================================

        response.on('data', (chunk) => {
          body += chunk;
        });

        // ======================================================
        // SELESAI
        // ======================================================

        response.on('end', () => {
          try {
            // ==================================================
            // VALIDASI STATUS HTTP
            // ==================================================

            if (response.statusCode !== 200) {
              return reject(
                new Error(
                  `Newsmaker server error: ${response.statusCode}`
                )
              );
            }

            // ==================================================
            // VALIDASI BODY
            // ==================================================

            if (!body || body.trim() === '') {
              return reject(
                new Error(
                  'Response dari Newsmaker kosong.'
                )
              );
            }

            // ==================================================
            // PARSE JSON
            // ==================================================

            let result;

            try {
              result = JSON.parse(body);
            } catch (error) {
              console.error(
                'Response Newsmaker bukan JSON:',
                body.substring(0, 500)
              );

              return reject(
                new Error(
                  'Response dari Newsmaker bukan JSON yang valid.'
                )
              );
            }

            // ==================================================
            // VALIDASI STATUS DARI API
            // ==================================================

            if (
              result.status !== undefined &&
              Number(result.status) !== 200
            ) {
              return reject(
                new Error(
                  result.message ||
                    'Gagal mengambil data dari Newsmaker.'
                )
              );
            }

            // ==================================================
            // AMBIL DATA
            // ==================================================

            let data = Array.isArray(result.data)
              ? result.data
              : [];

            // ==================================================
            // FILTER BERDASARKAN CATEGORY
            // ==================================================

            data = data.filter((item) => {
              return (
                normalizeCategory(item.category) ===
                normalizeCategory(selectedCategory)
              );
            });

            // ==================================================
            // NORMALISASI DATA
            // ==================================================

            data = data.map((item) => ({
              date:
                item.date ??
                item.tanggal ??
                item.Date ??
                item.Tanggal ??
                '-',

              open:
                item.open ??
                item.Open ??
                '-',

              high:
                item.high ??
                item.High ??
                '-',

              low:
                item.low ??
                item.Low ??
                '-',

              close:
                item.close ??
                item.Close ??
                '-',

              category:
                item.category ??
                selectedCategory,
            }));

            // ==================================================
            // FILTER START DATE
            // ==================================================

            if (startDate) {
              data = data.filter((item) => {
                return (
                  String(item.date).substring(0, 10) >=
                  startDate
                );
              });
            }

            // ==================================================
            // FILTER END DATE
            // ==================================================

            if (endDate) {
              data = data.filter((item) => {
                return (
                  String(item.date).substring(0, 10) <=
                  endDate
                );
              });
            }

            // ==================================================
            // SORT DATA
            // TERBARU → TERLAMA
            // ==================================================

            data.sort((a, b) => {
              return (
                new Date(b.date) -
                new Date(a.date)
              );
            });

            // ==================================================
            // PAGINATION
            // ==================================================

            const total = data.length;

            const safeLimit = Math.max(
              1,
              Math.min(
                Number(limit) || 10,
                100
              )
            );

            const safePage = Math.max(
              1,
              Number(page) || 1
            );

            const totalPages = Math.max(
              1,
              Math.ceil(total / safeLimit)
            );

            const currentPage = Math.min(
              safePage,
              totalPages
            );

            const startIndex =
              (currentPage - 1) *
              safeLimit;

            const paginatedData =
              data.slice(
                startIndex,
                startIndex + safeLimit
              );

            // ==================================================
            // RESPONSE
            // ==================================================

            resolve({
              status: 200,

              message: 'OK',

              category: selectedCategory,

              data: paginatedData,

              pagination: {
                current_page: currentPage,

                per_page: safeLimit,

                total_data: total,

                total_pages: totalPages,
              },

              updated_at:
                new Date().toISOString(),
            });
          } catch (error) {
            reject(error);
          }
        });
      }
    );

    // ========================================================
    // REQUEST ERROR
    // ========================================================

    request.on('error', (error) => {
      reject(
        new Error(
          `Gagal terhubung ke Newsmaker: ${error.message}`
        )
      );
    });

    // ========================================================
    // TIMEOUT
    // ========================================================

    request.setTimeout(15000, () => {
      request.destroy();

      reject(
        new Error(
          'Request ke Newsmaker timeout.'
        )
      );
    });
  });
}

// ============================================================
// EXPORT
// ============================================================

module.exports = {
  getHistoricalData,
  AVAILABLE_CATEGORIES,
  DEFAULT_CATEGORY,
};