import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/history_viewmodel.dart';
import '../../viewmodels/physical_gold_calculator_viewmodel.dart';
import 'physical_gold_result.dart';

class PhysicalGoldCalculator extends StatelessWidget {
  final VoidCallback? onBack;

  const PhysicalGoldCalculator({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PhysicalGoldCalculatorViewModel(
        historyViewModel: context.read<HistoryViewModel>(),
      ),
      child: _PhysicalGoldCalculatorContent(onBack: onBack),
    );
  }
}

class _PhysicalGoldCalculatorContent extends StatefulWidget {
  final VoidCallback? onBack;

  const _PhysicalGoldCalculatorContent({this.onBack});

  @override
  State<_PhysicalGoldCalculatorContent> createState() =>
      _PhysicalGoldCalculatorContentState();
}

class _PhysicalGoldCalculatorContentState
    extends State<_PhysicalGoldCalculatorContent> {
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

  // ==================================================
  // FORMAT ANGKA RIBUAN
  // ==================================================

  final TextInputFormatter _thousandsFormatter =
      TextInputFormatter.withFunction((oldValue, newValue) {
        final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

        if (digits.isEmpty) {
          return const TextEditingValue(
            text: '',
            selection: TextSelection.collapsed(offset: 0),
          );
        }

        final formatted = digits.replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => '.',
        );

        return TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      });

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

  Future<void> _hitung() async {
    // ================================================
    // VALIDASI FORM
    // ================================================

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ================================================
    // KONVERSI INPUT MENJADI DOUBLE
    // ================================================

    final double modal = double.parse(
      _modalController.text.replaceAll('.', '').trim(),
    );

    final double kurs = double.parse(
      _kursController.text.replaceAll('.', '').trim(),
    );

    final double hargaBeli = double.parse(_hargaBeliController.text.trim());

    final double hargaJual = double.parse(_hargaJualController.text.trim());

    // ================================================
    // AMBIL VIEWMODEL
    // ================================================

    final viewModel = context.read<PhysicalGoldCalculatorViewModel>();

    // ================================================
    // HITUNG DAN SIMPAN HISTORY
    // ================================================

    final result = await viewModel.hitung(
      modal: modal,
      kurs: kurs,
      hargaBeli: hargaBeli,
      hargaJual: hargaJual,
    );

    if (!mounted) {
      return;
    }

    // ================================================
    // JIKA HISTORY GAGAL DISIMPAN
    // ================================================

    if (result == null) {
      if (viewModel.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(viewModel.errorMessage!)));
      }

      return;
    }

    // ================================================
    // PINDAH KE HALAMAN HASIL
    // ================================================

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhysicalGoldResult(
          modal: result.modal,
          kurs: result.kurs,
          hargaBeli: result.hargaBeli,
          hargaJual: result.hargaJual,
          hasilHargaBeli: result.hasilHargaBeli,
          hasilHargaJual: result.hasilHargaJual,
          selisihHarga: result.selisihHarga,
          jumlahEmas: result.jumlahEmas,
          keuntungan: result.keuntungan,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),

      // ==================================================
      // HEADER
      // ==================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,

        // ==================================================
        // STATUS BAR
        // ==================================================
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),

        // ==================================================
        // GARIS PEMBATAS HEADER
        // ==================================================
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),

        // ==================================================
        // TOMBOL BACK
        // ==================================================
        leading: IconButton(
          onPressed: () {
            if (widget.onBack != null) {
              widget.onBack!();
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF3D2B1F),
            size: 25,
          ),
        ),

        // ==================================================
        // JUDUL HEADER
        // ==================================================
        title: const Text(
          'Emas Fisik',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF28C28),
          ),
        ),
      ),

      // ==================================================
      // BODY
      // ==================================================
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  inputFormatters: [_thousandsFormatter],
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
                  inputFormatters: [_thousandsFormatter],
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
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,

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
