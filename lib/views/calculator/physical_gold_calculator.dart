import 'package:flutter/material.dart';
import 'physical_gold_result.dart';

class PhysicalGoldCalculator extends StatefulWidget {
  const PhysicalGoldCalculator({super.key});

  @override
  State<PhysicalGoldCalculator> createState() => _PhysicalGoldCalculatorState();
}

class _PhysicalGoldCalculatorState extends State<PhysicalGoldCalculator> {
  // ==================================================
  // FORM KEY
  // ==================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ==================================================
  // CONTROLLER INPUT
  // ==================================================

  final TextEditingController _modalController = TextEditingController();
  final TextEditingController _kursController = TextEditingController();
  final TextEditingController _hargaBeliController = TextEditingController();
  final TextEditingController _hargaJualController = TextEditingController();

  @override
  void dispose() {
    _modalController.dispose();
    _kursController.dispose();
    _hargaBeliController.dispose();
    _hargaJualController.dispose();

    super.dispose();
  }

  // ==================================================
  // TOMBOL HITUNG
  // ==================================================

  void _hitung() {
    // ================================================
    // VALIDASI FORM
    // ================================================

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ================================================
    // KONVERSI INPUT MENJADI DOUBLE
    // ================================================

    final double modal = double.parse(_modalController.text.trim());

    final double kurs = double.parse(_kursController.text.trim());

    final double hargaBeli = double.parse(_hargaBeliController.text.trim());

    final double hargaJual = double.parse(_hargaJualController.text.trim());

    // ================================================
    // TOZ
    // ================================================

    const double toz = 31.1;

    // ================================================
    // LANGKAH 1
    //
    // Harga Beli × Kurs ÷ Toz
    //
    // Desimal dibuang tanpa pembulatan.
    // ================================================

    final double hasilHargaBeli = ((hargaBeli * kurs) / toz).floorToDouble();

    // ================================================
    // LANGKAH 2
    //
    // Harga Jual × Kurs ÷ Toz
    //
    // Desimal dibuang tanpa pembulatan.
    // ================================================

    final double hasilHargaJual = ((hargaJual * kurs) / toz).floorToDouble();

    // ================================================
    // LANGKAH 3
    //
    // Hasil harga jual - hasil harga beli
    //
    // Tidak dilakukan pembulatan.
    // ================================================

    final double selisihHarga = hasilHargaJual - hasilHargaBeli;

    // ================================================
    // LANGKAH 4
    //
    // Modal ÷ hasil harga beli
    //
    // Hanya mengambil 2 angka di belakang koma.
    // Tidak dibulatkan.
    //
    // Contoh:
    // 9,7189 → 9,71
    // 9,7265 → 9,72
    // ================================================

    final double jumlahEmas = ((modal / hasilHargaBeli) * 100).floor() / 100;

    // ================================================
    // LANGKAH 5
    //
    // Hasil langkah 3 × hasil langkah 4
    //
    // Angka di belakang koma dibuang.
    // Tidak dibulatkan.
    // ================================================

    final double keuntungan = (selisihHarga * jumlahEmas).floorToDouble();

    // ================================================
    // PINDAH KE HALAMAN HASIL
    // ================================================

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhysicalGoldResult(
          modal: modal,
          kurs: kurs,
          hargaBeli: hargaBeli,
          hargaJual: hargaJual,
          hasilHargaBeli: hasilHargaBeli,
          hasilHargaJual: hasilHargaJual,
          selisihHarga: selisihHarga,
          jumlahEmas: jumlahEmas,
          keuntungan: keuntungan,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),

          child: Form(
            key: _formKey,

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
                      onPressed: () {
                        // Fitur notifikasi akan dibuat nanti.
                      },

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
                  'Hitung Emas Fisik',

                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF28C28),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Masukkan data transaksi emas fisik '
                  'untuk menghitung keuntungan atau kerugian.',

                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // ==========================================
                // MODAL
                // ==========================================
                _buildInputLabel('Modal (IDR)'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _modalController,
                  hintText: 'Masukkan modal',
                  icon: Icons.account_balance_wallet_outlined,
                  keyboardType: TextInputType.number,
                  errorMessage: 'Modal wajib diisi',
                ),

                const SizedBox(height: 20),

                // ==========================================
                // KURS
                // ==========================================
                _buildInputLabel('Kurs (IDR)'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _kursController,
                  hintText: 'Masukkan kurs',
                  icon: Icons.currency_exchange_rounded,
                  keyboardType: TextInputType.number,
                  errorMessage: 'Kurs wajib diisi',
                ),

                const SizedBox(height: 20),

                // ==========================================
                // HARGA BELI
                // ==========================================
                _buildInputLabel('Harga Beli'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _hargaBeliController,
                  hintText: 'Masukkan harga beli',
                  icon: Icons.shopping_cart_outlined,
                  keyboardType: TextInputType.number,
                  errorMessage: 'Harga beli wajib diisi',
                ),

                const SizedBox(height: 20),

                // ==========================================
                // HARGA JUAL
                // ==========================================
                _buildInputLabel('Harga Jual'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _hargaJualController,
                  hintText: 'Masukkan harga jual',
                  icon: Icons.sell_outlined,
                  keyboardType: TextInputType.number,
                  errorMessage: 'Harga jual wajib diisi',
                ),

                const SizedBox(height: 32),

                // ==========================================
                // BUTTON HITUNG
                // ==========================================
                SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed: _hitung,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF28C28),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Icon(Icons.calculate_outlined, size: 21),

                        SizedBox(width: 10),

                        Text(
                          'Hitung',

                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================================================
  // LABEL INPUT
  // ==================================================

  Widget _buildInputLabel(String label) {
    return Text(
      label,

      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF333333),
      ),
    );
  }

  // ==================================================
  // INPUT FIELD
  // ==================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
    required String errorMessage,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,

      // ================================================
      // VALIDASI
      // ================================================
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorMessage;
        }

        return null;
      },

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),

        prefixIcon: Icon(icon, color: const Color(0xFFF28C28)),

        filled: true,
        fillColor: Colors.white,

        // ==============================================
        // BORDER NORMAL
        // ==============================================
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),

        // ==============================================
        // BORDER KETIKA TIDAK FOKUS
        // ==============================================
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),

        // ==============================================
        // BORDER KETIKA FOKUS
        // ==============================================
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF28C28), width: 1.5),
        ),

        // ==============================================
        // BORDER ERROR
        // ==============================================
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),

        // ==============================================
        // BORDER ERROR + FOKUS
        // ==============================================
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
