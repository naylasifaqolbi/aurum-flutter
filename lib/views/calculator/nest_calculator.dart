import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../services/historical_api_service.dart';
import '../../viewmodels/history_viewmodel.dart';
import 'package:provider/provider.dart';
import 'nest_result.dart';

class NestCalculatorScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const NestCalculatorScreen({super.key, this.onBack});

  @override
  State<NestCalculatorScreen> createState() => _NestCalculatorScreenState();
}

class _NestCalculatorScreenState extends State<NestCalculatorScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _openController = TextEditingController();

  final TextEditingController _closeController = TextEditingController();

  bool _isLoadingHistorical = true;

  @override
  void initState() {
    super.initState();

    _loadLatestHistoricalData();
  }

  Future<void> _loadLatestHistoricalData() async {
    try {
      final result = await HistoricalApiService.getHistoricalData(
        category: 'LGD Daily',
        page: 1,
        limit: 10,
      );

      final dynamic rawData = result['data'];

      if (rawData is List && rawData.isNotEmpty) {
        final dynamic latest = rawData.first;

        if (!mounted) {
          return;
        }

        setState(() {
          _closeController.text = latest['close']?.toString() ?? '';

          _isLoadingHistorical = false;
        });
      } else {
        if (!mounted) {
          return;
        }

        setState(() {
          _isLoadingHistorical = false;
        });
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingHistorical = false;
      });
    }
  }

  @override
  void dispose() {
    _openController.dispose();
    _closeController.dispose();

    super.dispose();
  }

  Future<void> _hitung() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final double open = double.parse(
      _openController.text.trim().replaceAll(',', '.'),
    );

    final double close = double.parse(
      _closeController.text.trim().replaceAll(',', '.'),
    );

    String indication;
    String description;

    if (close > open) {
      indication = 'BUY';
      description = 'Harga Close berada di atas harga Open.';
    } else if (close < open) {
      indication = 'SELL';
      description = 'Harga Close berada di bawah harga Open.';
    } else {
      indication = 'NETRAL';
      description = 'Harga Close sama dengan harga Open.';
    }

    final historySaved = await context.read<HistoryViewModel>().saveHistory(
      calculatorType: 'nest',
      inputData: {'open': open, 'close': close},
      resultData: {'indication': indication, 'description': description},
    );

    if (!historySaved) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NestResult(
          open: open,
          close: close,
          indication: indication,
          description: description,
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

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required String errorMessage,
    bool showLoading = true,
  }) {
    final bool isLoading = showLoading && _isLoadingHistorical;

    return TextFormField(
      controller: controller,
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
