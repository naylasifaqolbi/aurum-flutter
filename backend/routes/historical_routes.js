const express = require('express');

const {
  getHistoricalData,
} = require('../services/newsmaker_service');

const router = express.Router();

/*
|--------------------------------------------------------------------------
| GET /api/historical-gold
|--------------------------------------------------------------------------
|
| Contoh:
|
| /api/historical-gold
|
| /api/historical-gold?page=1&limit=10
|
| /api/historical-gold?start_date=2026-08-01&end_date=2026-08-31
|
|--------------------------------------------------------------------------
*/

router.get('/historical-gold', async (req, res) => {
  try {
    /*
    |--------------------------------------------------------------------------
    | QUERY
    |--------------------------------------------------------------------------
    */

    const {
      start_date,
      end_date,
      page = 1,
      limit = 10,
    } = req.query;

    /*
    |--------------------------------------------------------------------------
    | VALIDASI DATE
    |--------------------------------------------------------------------------
    */

    if (start_date && !/^\d{4}-\d{2}-\d{2}$/.test(start_date)) {
      return res.status(400).json({
        success: false,
        message:
          'Format start_date harus YYYY-MM-DD.',
      });
    }

    if (end_date && !/^\d{4}-\d{2}-\d{2}$/.test(end_date)) {
      return res.status(400).json({
        success: false,
        message:
          'Format end_date harus YYYY-MM-DD.',
      });
    }

    /*
    |--------------------------------------------------------------------------
    | AMBIL DATA
    |--------------------------------------------------------------------------
    */

    const result = await getHistoricalData({
      startDate: start_date,
      endDate: end_date,
      page: Number(page),
      limit: Number(limit),
    });

    /*
    |--------------------------------------------------------------------------
    | RESPONSE
    |--------------------------------------------------------------------------
    */

    return res.status(200).json({
      success: true,

      message: 'Historical data berhasil diambil.',

      category: result.category,

      data: result.data,

      pagination: result.pagination,

      updated_at: result.updated_at,
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
        'Gagal mengambil historical data.',
    });
  }
});

module.exports = router;