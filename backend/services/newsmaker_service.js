/*
|--------------------------------------------------------------------------
| NEWSMAKER SERVICE
|--------------------------------------------------------------------------
*/

const https = require('https');

const NEWSMAKER_URL =
  'https://www.newsmaker.id/api/historical-data';

/*
|--------------------------------------------------------------------------
| GET HISTORICAL DATA FROM NEWSMAKER
|--------------------------------------------------------------------------
*/

async function getHistoricalData({
  startDate,
  endDate,
  page = 1,
  limit = 10,
}) {
  return new Promise((resolve, reject) => {
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

        response.on('data', (chunk) => {
          body += chunk;
        });

        response.on('end', () => {
          try {
            /*
            |--------------------------------------------------------------------------
            | CEK HTTP STATUS
            |--------------------------------------------------------------------------
            */

            if (response.statusCode !== 200) {
              return reject(
                new Error(
                  `Newsmaker server error: ${response.statusCode}`
                )
              );
            }

            /*
            |--------------------------------------------------------------------------
            | CEK RESPONSE KOSONG
            |--------------------------------------------------------------------------
            */

            if (!body || body.trim() === '') {
              return reject(
                new Error(
                  'Response dari Newsmaker kosong.'
                )
              );
            }

            /*
            |--------------------------------------------------------------------------
            | PARSE JSON
            |--------------------------------------------------------------------------
            */

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

            /*
            |--------------------------------------------------------------------------
            | CEK STATUS API NEWSMAKER
            |--------------------------------------------------------------------------
            */

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

            /*
            |--------------------------------------------------------------------------
            | AMBIL DATA
            |--------------------------------------------------------------------------
            */

            let data = Array.isArray(result.data)
              ? result.data
              : [];

            /*
            |--------------------------------------------------------------------------
            | FILTER CATEGORY
            |--------------------------------------------------------------------------
            */

            data = data.filter((item) => {
              return (
                item.category === 'LGD Daily' ||
                item.category === 'LGD DAILY' ||
                item.category === 'lgd daily'
              );
            });

            /*
            |--------------------------------------------------------------------------
            | NORMALISASI DATA
            |--------------------------------------------------------------------------
            |
            | Data dari Newsmaker kemungkinan menggunakan:
            | tanggal, open, high, low, close
            |
            | Flutter akan menerima:
            | date, open, high, low, close
            |
            |--------------------------------------------------------------------------
            */

            data = data.map((item) => {
              return {
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
                  'LGD Daily',
              };
            });

            /*
            |--------------------------------------------------------------------------
            | FILTER START DATE
            |--------------------------------------------------------------------------
            */

            if (startDate) {
              data = data.filter((item) => {
                return (
                  String(item.date).substring(0, 10) >=
                  startDate
                );
              });
            }

            /*
            |--------------------------------------------------------------------------
            | FILTER END DATE
            |--------------------------------------------------------------------------
            */

            if (endDate) {
              data = data.filter((item) => {
                return (
                  String(item.date).substring(0, 10) <=
                  endDate
                );
              });
            }

            /*
            |--------------------------------------------------------------------------
            | SORT TERBARU
            |--------------------------------------------------------------------------
            */

            data.sort((a, b) => {
              return (
                new Date(b.date) -
                new Date(a.date)
              );
            });

            /*
            |--------------------------------------------------------------------------
            | PAGINATION
            |--------------------------------------------------------------------------
            */

            const total = data.length;

            const safeLimit = Math.max(
              1,
              Math.min(Number(limit) || 10, 100)
            );

            const safePage = Math.max(
              1,
              Number(page) || 1
            );

            const totalPages =
              Math.max(
                1,
                Math.ceil(total / safeLimit)
              );

            const currentPage = Math.min(
              safePage,
              totalPages
            );

            const startIndex =
              (currentPage - 1) * safeLimit;

            const paginatedData = data.slice(
              startIndex,
              startIndex + safeLimit
            );

            /*
            |--------------------------------------------------------------------------
            | RESPONSE
            |--------------------------------------------------------------------------
            */

            resolve({
              status: 200,

              message: 'OK',

              category: 'LGD Daily',

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

    /*
    |--------------------------------------------------------------------------
    | REQUEST ERROR
    |--------------------------------------------------------------------------
    */

    request.on('error', (error) => {
      reject(
        new Error(
          `Gagal terhubung ke Newsmaker: ${error.message}`
        )
      );
    });

    /*
    |--------------------------------------------------------------------------
    | TIMEOUT
    |--------------------------------------------------------------------------
    */

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

/*
|--------------------------------------------------------------------------
| EXPORT
|--------------------------------------------------------------------------
*/

module.exports = {
  getHistoricalData,
};