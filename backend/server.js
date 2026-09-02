const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

const {
  getHistoricalData,
  AVAILABLE_CATEGORIES,
  DEFAULT_CATEGORY,
} = require('./services/newsmaker_service');

// ============================================================
// CONFIG
// ============================================================

dotenv.config();

const app = express();

const PORT = process.env.PORT || 3000;

// ============================================================
// MIDDLEWARE
// ============================================================

app.use(
  cors({
    origin: '*',
  })
);

app.use(express.json());

// ============================================================
// ROOT / HEALTH CHECK
// ============================================================

app.get('/', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'Aurum Backend API is running.',
  });
});

// ============================================================
// HISTORICAL DATA
// ============================================================

app.get('/api/historical-gold', async (req, res) => {
  try {
    // ========================================================
    // QUERY PARAMETER
    // ========================================================

    const {
      category,
      start_date,
      end_date,
      page = '1',
      limit = '10',
    } = req.query;

    // ========================================================
    // CATEGORY
    // DEFAULT = LGD DAILY
    // ========================================================

    const requestedCategory =
      category?.toString().trim() ||
      DEFAULT_CATEGORY;

    // ========================================================
    // CARI CATEGORY RESMI
    // CASE INSENSITIVE
    // ========================================================

    const selectedCategory =
      AVAILABLE_CATEGORIES.find(
        (item) =>
          item.toLowerCase() ===
          requestedCategory.toLowerCase()
      );

    // ========================================================
    // CATEGORY TIDAK VALID
    // ========================================================

    if (!selectedCategory) {
      return res.status(400).json({
        success: false,

        message:
          `Kategori "${requestedCategory}" tidak tersedia.`,

        available_categories:
          AVAILABLE_CATEGORIES,
      });
    }

    // ========================================================
    // VALIDASI PAGE
    // ========================================================

    const parsedPage =
      Number.parseInt(page, 10);

    if (
      Number.isNaN(parsedPage) ||
      parsedPage < 1
    ) {
      return res.status(400).json({
        success: false,
        message:
          'Parameter page harus berupa angka >= 1.',
      });
    }

    // ========================================================
    // VALIDASI LIMIT
    // ========================================================

    const parsedLimit =
      Number.parseInt(limit, 10);

    if (
      Number.isNaN(parsedLimit) ||
      parsedLimit < 1 ||
      parsedLimit > 100
    ) {
      return res.status(400).json({
        success: false,

        message:
          'Parameter limit harus berada antara 1 sampai 100.',
      });
    }

    // ========================================================
    // LOG
    // ========================================================

    console.log(
      `Historical request: ${selectedCategory} | ` +
      `page=${parsedPage} | ` +
      `limit=${parsedLimit} | ` +
      `start=${start_date || '-'} | ` +
      `end=${end_date || '-'}`
    );

    // ========================================================
    // GET DATA
    // ========================================================

    const result =
      await getHistoricalData({
        category: selectedCategory,

        startDate: start_date,

        endDate: end_date,

        page: parsedPage,

        limit: parsedLimit,
      });

    // ========================================================
    // RESPONSE
    // ========================================================

    return res.status(200).json({
      success: true,

      message:
        'Historical data retrieved successfully',

      ...result,
    });
  } catch (error) {
    console.error(
      'Historical API Error:',
      error
    );

    return res.status(500).json({
      success: false,

      message:
        error.message ||
        'Gagal mengambil data historical.',
    });
  }
});

// ============================================================
// 404
// ============================================================

app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint tidak ditemukan.',
  });
});

// ============================================================
// GLOBAL ERROR HANDLER
// ============================================================

app.use(
  (error, req, res, next) => {
    console.error(
      'Unhandled error:',
      error
    );

    res.status(500).json({
      success: false,
      message:
        error.message ||
        'Internal server error.',
    });
  }
);

// ============================================================
// START SERVER
// ============================================================

app.listen(
  PORT,
  '0.0.0.0',
  () => {
    console.log(
      `Aurum Backend running on port ${PORT}`
    );

    console.log(
      'Available historical categories:',
      AVAILABLE_CATEGORIES.join(', ')
    );
  }
);