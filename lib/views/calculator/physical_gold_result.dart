import 'package:flutter/material.dart';

class PhysicalGoldResult extends StatelessWidget {
  final double modal;
  final double kurs;
  final double hargaBeli;
  final double hargaJual;

  final double hasilHargaBeli;
  final double hasilHargaJual;
  final double selisihHarga;
  final double jumlahEmas;
  final double keuntungan;

  const PhysicalGoldResult({
    super.key,
    required this.modal,
    required this.kurs,
    required this.hargaBeli,
    required this.hargaJual,
    required this.hasilHargaBeli,
    required this.hasilHargaJual,
    required this.selisihHarga,
    required this.jumlahEmas,
    required this.keuntungan,
  });

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }

  String _formatRupiah(double value) {
    final rounded = value.round();
    final formatted = rounded.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );

    return 'Rp $formatted';
  }

  @override
  Widget build(BuildContext context) {
    final bool isProfit = keuntungan >= 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================================
              // HEADER
              // ==========================================
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
                      color: Color(0xFFF28C28),
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

              const SizedBox(height: 35),

              // ==========================================
              // TITLE
              // ==========================================
              const Text(
                'Hasil Kalkulasi',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF28C28),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Berikut hasil perhitungan transaksi emas fisik Anda.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF777777),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 25),

              // ==========================================
              // HASIL UTAMA
              // ==========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: isProfit
                      ? const Color(0xFFFFE5CC)
                      : const Color(0xFFFFE2E2),

                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    Icon(
                      isProfit
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 42,
                      color: isProfit ? const Color(0xFFF28C28) : Colors.red,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      isProfit ? 'Keuntungan' : 'Kerugian',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF777777),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      _formatRupiah(keuntungan.abs()),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isProfit ? const Color(0xFFF28C28) : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==========================================
              // DATA INPUT
              // ==========================================
              const Text(
                'Data Transaksi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    _buildResultItem(
                      icon: Icons.account_balance_wallet_outlined,
                      title: 'Modal',
                      value: _formatRupiah(modal),
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildResultItem(
                      icon: Icons.currency_exchange_rounded,
                      title: 'Kurs',
                      value: _formatRupiah(kurs),
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildResultItem(
                      icon: Icons.shopping_cart_outlined,
                      title: 'Harga Beli',
                      value: _formatNumber(hargaBeli),
                    ),

                    const Divider(height: 1, indent: 20, endIndent: 20),

                    _buildResultItem(
                      icon: Icons.sell_outlined,
                      title: 'Harga Jual',
                      value: _formatNumber(hargaJual),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==========================================
              // RINCIAN PERHITUNGAN
              // ==========================================
              const Text(
                'Rincian Perhitungan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCalculationStep(
                      number: '1',
                      title: 'Harga Beli × Kurs ÷ Toz',
                      formula:
                          '${_formatNumber(hargaBeli)} × '
                          '${_formatNumber(kurs)} ÷ 31.1',
                      result: _formatNumber(hasilHargaBeli),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '2',
                      title: 'Harga Jual × Kurs ÷ Toz',
                      formula:
                          '${_formatNumber(hargaJual)} × '
                          '${_formatNumber(kurs)} ÷ 31.1',
                      result: _formatNumber(hasilHargaJual),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '3',
                      title: 'Hasil Harga Jual − Hasil Harga Beli',
                      formula:
                          '${_formatNumber(hasilHargaJual)} − '
                          '${_formatNumber(hasilHargaBeli)}',
                      result: _formatNumber(selisihHarga),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '4',
                      title: 'Modal ÷ Hasil Harga Jual',
                      formula:
                          '${_formatNumber(modal)} ÷ '
                          '${_formatNumber(hasilHargaJual)}',
                      result: _formatNumber(jumlahEmas),
                    ),

                    const SizedBox(height: 18),

                    _buildCalculationStep(
                      number: '5',
                      title: 'Selisih Harga × Jumlah Emas',
                      formula:
                          '${_formatNumber(selisihHarga)} × '
                          '${_formatNumber(jumlahEmas)}',
                      result: _formatRupiah(keuntungan),
                      resultColor: isProfit
                          ? const Color(0xFFF28C28)
                          : Colors.red,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ==========================================
              // BUTTON KEMBALI
              // ==========================================
              SizedBox(
                width: double.infinity,
                height: 52,

                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFF28C28),
                    side: const BorderSide(color: Color(0xFFF28C28)),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  child: const Text(
                    'Kembali ke Kalkulator',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================
  // RESULT ITEM
  // ==================================================

  Widget _buildResultItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),

      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: const Color(0xFFFFE5CC),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Icon(icon, color: const Color(0xFFF28C28), size: 22),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Color(0xFF777777)),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3D2B1F),
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================
  // CALCULATION STEP
  // ==================================================

  Widget _buildCalculationStep({
    required String number,
    required String title,
    required String formula,
    required String result,
    Color resultColor = const Color(0xFFF28C28),
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,

          decoration: const BoxDecoration(
            color: Color(0xFFFFE5CC),
            shape: BoxShape.circle,
          ),

          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF28C28),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D2B1F),
                ),
              ),

              const SizedBox(height: 5),

              Text(
                formula,
                style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
              ),

              const SizedBox(height: 5),

              Text(
                '= $result',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: resultColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
