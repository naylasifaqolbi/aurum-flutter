const express = require('express');
const cors = require('cors');
require('dotenv').config();

const {
  getHistoricalData,
} = require('./services/newsmaker_service');

const app = express();

const PORT = process.env.PORT || 3000;

/*
|--------------------------------------------------------------------------
| MIDDLEWARE
|--------------------------------------------------------------------------
*/

app.use(cors());

app.use(express.json());

/*
|--------------------------------------------------------------------------
| HEALTH CHECK
|--------------------------------------------------------------------------
*/

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'AURUM Historical Gold API is running',
    server_time: new Date().toISOString(),
  });
});

/*
|--------------------------------------------------------------------------
| HISTORICAL GOLD
|--------------------------------------------------------------------------
|
| GET:
|
| http://localhost:3000/api/historical-gold
|
| Filter:
|
| ?start_date=2026-08-01
|
| ?start_date=2026-08-01&end_date=2026-08-31
|
| Pagination:
|
| ?page=1&limit=10
|
|--------------------------------------------------------------------------
*/

app.get(
  '/api/historical-gold',
  async (req, res) => {
    try {
      const {
        start_date,
        end_date,
        page = 1,
        limit = 10,
      } = req.query;

      /*
      |--------------------------------------------------------------------------
      | VALIDASI PAGE
      |--------------------------------------------------------------------------
      */

      const parsedPage = Number(page);

      if (
        !Number.isInteger(parsedPage) ||
        parsedPage < 1
      ) {
        return res.status(400).json({
          success: false,
          message:
            'Parameter page tidak valid.',
        });
      }

      /*
      |--------------------------------------------------------------------------
      | VALIDASI LIMIT
      |--------------------------------------------------------------------------
      */

      const parsedLimit = Number(limit);

      if (
        !Number.isInteger(parsedLimit) ||
        parsedLimit < 1 ||
        parsedLimit > 100
      ) {
        return res.status(400).json({
          success: false,
          message:
            'Parameter limit harus antara 1 sampai 100.',
        });
      }

      /*
      |--------------------------------------------------------------------------
      | REQUEST KE NEWSMAKER
      |--------------------------------------------------------------------------
      */

      console.log('');
      console.log(
        '======================================'
      );

      console.log(
        ' REQUEST HISTORICAL DATA'
      );

      console.log(
        '======================================'
      );

      console.log(
        'Start date:',
        start_date || 'Semua'
      );

      console.log(
        'End date:',
        end_date || 'Semua'
      );

      console.log(
        'Page:',
        parsedPage
      );

      console.log(
        'Limit:',
        parsedLimit
      );

      /*
      |--------------------------------------------------------------------------
      | GET DATA
      |--------------------------------------------------------------------------
      */

      const result =
        await getHistoricalData({
          startDate: start_date,

          endDate: end_date,

          page: parsedPage,

          limit: parsedLimit,
        });

      /*
      |--------------------------------------------------------------------------
      | RESPONSE KE FLUTTER
      |--------------------------------------------------------------------------
      */

      return res.status(200).json({
        success: true,

        message:
          'Historical gold data retrieved successfully',

        ...result,
      });
    } catch (error) {
      /*
      |--------------------------------------------------------------------------
      | ERROR
      |--------------------------------------------------------------------------
      */

      console.error('');

      console.error(
        '======================================'
      );

      console.error(
        ' HISTORICAL API ERROR'
      );

      console.error(
        '======================================'
      );

      console.error(
        error.message
      );

      return res.status(500).json({
        success: false,

        message:
          'Failed to retrieve historical gold data',

        error: error.message,
      });
    }
  }
);

/*
|--------------------------------------------------------------------------
| 404
|--------------------------------------------------------------------------
*/

app.use((req, res) => {
  res.status(404).json({
    success: false,

    message:
      'Endpoint tidak ditemukan.',
  });
});

/*
|--------------------------------------------------------------------------
| GLOBAL ERROR HANDLER
|--------------------------------------------------------------------------
*/

app.use(
  (
    error,
    req,
    res,
    next
  ) => {
    console.error(
      'Global Error:',
      error
    );

    res.status(500).json({
      success: false,

      message:
        'Internal server error.',

      error:
        error.message,
    });
  }
);

/*
|--------------------------------------------------------------------------
| SERVER
|--------------------------------------------------------------------------
*/

app.listen(
  PORT,
  '0.0.0.0',
  () => {
    console.log('');

    console.log(
      '======================================'
    );

    console.log(
      ' AURUM HISTORICAL GOLD BACKEND'
    );

    console.log(
      '======================================'
    );

    console.log(
      `Server running on http://localhost:${PORT}`
    );

    console.log(
      `Historical endpoint: http://localhost:${PORT}/api/historical-gold`
    );

    console.log('');

    console.log(
      'Server siap menerima request dari Flutter.'
    );

    console.log('');
  }
);