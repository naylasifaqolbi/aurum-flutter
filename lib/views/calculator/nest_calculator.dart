import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/nest_calculator_model.dart';
import '../../viewmodels/history_viewmodel.dart';
import '../../viewmodels/nest_calculator_viewmodel.dart';
import 'nest_result.dart';

class NestCalculatorScreen extends StatelessWidget {
  final VoidCallback? onBack;

  const NestCalculatorScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NestCalculatorViewModel(
        historyViewModel: context.read<HistoryViewModel>(),
      ),
      child: _NestCalculatorView(onBack: onBack),
    );
  }
}

class _NestCalculatorView extends StatefulWidget {
  final VoidCallback? onBack;

  const _NestCalculatorView({this.onBack});

  @override
  State<_NestCalculatorView> createState() => _NestCalculatorViewState();
}

class _NestCalculatorViewState extends State<_NestCalculatorView> {
  // ============================================================
  // FORM KEY
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // CONTROLLER INPUT
  // ============================================================

  final TextEditingController _openController = TextEditingController();

  final TextEditingController _closeController = TextEditingController();

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLatestHistoricalData();
    });
  }

  // ============================================================
  // LOAD DATA HISTORICAL TERBARU
  // ============================================================

  Future<void> _loadLatestHistoricalData() async {
    final viewModel = context.read<NestCalculatorViewModel>();

    final String? close = await viewModel.loadLatestHistoricalData();

    if (!mounted || close == null) {
      return;
    }

    // ==========================================================
    // HARGA OPEN TIDAK DIISI OTOMATIS
    // Harga Open tetap diketik manual oleh pengguna.
    // ==========================================================

    // ==========================================================
    // HARGA CLOSE DIISI OTOMATIS
    // ==========================================================

    _closeController.text = close;
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _openController.dispose();
    _closeController.dispose();

    super.dispose();
  }

  // ============================================================
  // HITUNG NEST
  // ============================================================

  Future<void> _hitung() async {
    // ==========================================================
    // VALIDASI FORM
    // ==========================================================

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ==========================================================
    // KONVERSI INPUT MENJADI DOUBLE
    // ==========================================================

    final double open = double.parse(
      _openController.text.trim().replaceAll(',', '.'),
    );

    final double close = double.parse(
      _closeController.text.trim().replaceAll(',', '.'),
    );

    // ==========================================================
    // HITUNG DAN SIMPAN MELALUI VIEWMODEL
    // ==========================================================

    final NestCalculatorModel? result = await context
        .read<NestCalculatorViewModel>()
        .hitungDanSimpan(open: open, close: close);

    if (!mounted || result == null) {
      return;
    }

    // ==========================================================
    // PINDAH KE HALAMAN HASIL
    // ==========================================================

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NestResult(
          open: result.open,
          close: result.close,
          indication: result.indication,
          description: result.description,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

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

        // ==========================================
        // STATUS BAR
        // ==========================================
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),

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

        title: const Text(
          'Nest',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF28C28),
          ),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  'Indikator Nest',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Masukkan harga Open secara manual. '
                  'Harga Close diambil otomatis dari data historical. '
                  'Indikator BUY, SELL, atau NETRAL ditentukan berdasarkan '
                  'perbandingan harga Close dan Open.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF777777),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                // ==================================================
                // OPEN
                // ==================================================
                _buildInputLabel('Harga Open'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _openController,
                  hintText: 'Masukkan harga open',
                  icon: Icons.radio_button_checked_rounded,
                  errorMessage: 'Harga Open wajib diisi',
                  showLoading: false,
                ),

                const SizedBox(height: 20),

                // ==================================================
                // CLOSE
                // ==================================================
                _buildInputLabel('Harga Close'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _closeController,
                  hintText: 'Masukkan harga close',
                  icon: Icons.show_chart_rounded,
                  errorMessage: 'Harga Close wajib diisi',
                  showLoading: true,
                ),

                const SizedBox(height: 32),

                // ==================================================
                // BUTTON HITUNG
                // ==================================================
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

  // ============================================================
  // LABEL INPUT
  // ============================================================

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

  // ============================================================
  // INPUT FIELD
  // ============================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String errorMessage,
    bool showLoading = true,
  }) {
    final bool isLoading =
        showLoading &&
        context.watch<NestCalculatorViewModel>().isLoadingHistorical;

    return TextFormField(
      controller: controller,

      // Harga Open tidak loading sehingga tetap bisa diketik.
      // Harga Close readOnly saat proses loading.
      readOnly: isLoading,

      keyboardType: const TextInputType.numberWithOptions(decimal: true),

      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return errorMessage;
        }

        final double? number = double.tryParse(
          value.trim().replaceAll(',', '.'),
        );

        if (number == null) {
          return 'Masukkan angka yang valid';
        }

        if (number < 0) {
          return 'Angka tidak boleh negatif';
        }

        return null;
      },

      decoration: InputDecoration(
        hintText: isLoading ? 'Memuat data...' : hintText,

        hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 14),

        prefixIcon: isLoading
            ? const SizedBox(width: 50, child: Center(child: _LoadingArrow()))
            : Icon(icon, color: const Color(0xFFF28C28)),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFF28C28), width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.red),
        ),

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

// ============================================================
// LOADING ARROW
// ============================================================

class _LoadingArrow extends StatefulWidget {
  const _LoadingArrow();

  @override
  State<_LoadingArrow> createState() => _LoadingArrowState();
}

class _LoadingArrowState extends State<_LoadingArrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Text(
        '↻',
        style: TextStyle(fontSize: 20, color: Color(0xFF888888)),
      ),
    );
  }
}
