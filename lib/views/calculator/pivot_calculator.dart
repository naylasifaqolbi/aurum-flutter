import 'package:flutter/material.dart';
import 'pivot_result.dart';

class PivotCalculator extends StatefulWidget {
  const PivotCalculator({super.key});

  @override
  State<PivotCalculator> createState() => _PivotCalculatorState();
}

class _PivotCalculatorState extends State<PivotCalculator> {
  // ============================================================
  // FORM KEY
  // ============================================================

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ============================================================
  // CONTROLLER INPUT
  // ============================================================

  final TextEditingController _openController = TextEditingController();

  final TextEditingController _highController = TextEditingController();

  final TextEditingController _lowController = TextEditingController();

  final TextEditingController _closeController = TextEditingController();

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _openController.dispose();
    _highController.dispose();
    _lowController.dispose();
    _closeController.dispose();

    super.dispose();
  }

  // ============================================================
  // HITUNG PIVOT
  // ============================================================

  void _hitung() {
    // ==========================================================
    // VALIDASI
    // ==========================================================

    if (!_formKey.currentState!.validate()) {
      return;
    }

    // ==========================================================
    // KONVERSI INPUT
    // ==========================================================

    final double open = double.parse(
      _openController.text.trim().replaceAll(',', '.'),
    );

    final double high = double.parse(
      _highController.text.trim().replaceAll(',', '.'),
    );

    final double low = double.parse(
      _lowController.text.trim().replaceAll(',', '.'),
    );

    final double close = double.parse(
      _closeController.text.trim().replaceAll(',', '.'),
    );

    // ==========================================================
    // PIVOT POINT
    //
    // PP = (High + Low + Close) / 3
    // ==========================================================

    final double pp = (high + low + close) / 3;

    // ==========================================================
    // RANGE
    // ==========================================================

    final double range = high - low;

    // ==========================================================
    // RESISTANCE
    // ==========================================================

    // R4
    // PP + (High - Low) x 3
    final double r4 = pp + (range * 3);

    // R3
    // PP + (High - Low) x 2
    final double r3 = pp + (range * 2);

    // R2
    // PP + (High - Low)
    final double r2 = pp + range;

    // R1
    // 2 x PP - High
    final double r1 = (2 * pp) - high;

    // ==========================================================
    // SUPPORT
    // ==========================================================

    // S1
    // 2 x PP - High
    final double s1 = (2 * pp) - high;

    // S2
    // PP - (High - Low)
    final double s2 = pp - range;

    // S3
    // PP - (High - Low) x 2
    final double s3 = pp - (range * 2);

    // S4
    // PP - (High - Low) x 3
    final double s4 = pp - (range * 3);

    // ==========================================================
    // MIDPOINT RESISTANCE
    // ==========================================================

    // Midpoint R4 - R3
    final double midpointR4R3 = (r4 + r3) / 2;

    // Midpoint R3 - R2
    final double midpointR3R2 = (r3 + r2) / 2;

    // Midpoint R2 - R1
    final double midpointR2R1 = (r2 + r1) / 2;

    // Midpoint PP - R1
    final double midpointPPR1 = (pp + r1) / 2;

    // ==========================================================
    // MIDPOINT SUPPORT
    // ==========================================================

    // Midpoint PP - S1
    final double midpointPPS1 = (pp + s1) / 2;

    // Midpoint S1 - S2
    final double midpointS1S2 = (s1 + s2) / 2;

    // Midpoint S2 - S3
    final double midpointS2S3 = (s2 + s3) / 2;

    // Midpoint S3 - S4
    final double midpointS3S4 = (s3 + s4) / 2;

    // ==========================================================
    // INDIKASI
    // ==========================================================

    final String indication = open < pp ? 'BUY' : 'SELL';

    // ==========================================================
    // PINDAH KE HASIL
    // ==========================================================

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PivotResult(
          open: open,
          high: high,
          low: low,
          close: close,

          pp: pp,

          r1: r1,
          r2: r2,
          r3: r3,
          r4: r4,

          s1: s1,
          s2: s2,
          s3: s3,
          s4: s4,

          midpointR4R3: midpointR4R3,
          midpointR3R2: midpointR3R2,
          midpointR2R1: midpointR2R1,
          midpointPPR1: midpointPPR1,

          midpointPPS1: midpointPPS1,
          midpointS1S2: midpointS1S2,
          midpointS2S3: midpointS2S3,
          midpointS3S4: midpointS3S4,

          indication: indication,
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
                // HEADER
                // ==================================================
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

                // ==================================================
                // TITLE
                // ==================================================
                const Text(
                  'Pivot Point',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF28C28),
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Masukkan data Open, High, Low, dan Close '
                  'untuk menghitung Pivot Point.',
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
                ),

                const SizedBox(height: 20),

                // ==================================================
                // HIGH
                // ==================================================
                _buildInputLabel('Harga High'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _highController,
                  hintText: 'Masukkan harga high',
                  icon: Icons.arrow_upward_rounded,
                  errorMessage: 'Harga High wajib diisi',
                ),

                const SizedBox(height: 20),

                // ==================================================
                // LOW
                // ==================================================
                _buildInputLabel('Harga Low'),

                const SizedBox(height: 8),

                _buildInputField(
                  controller: _lowController,
                  hintText: 'Masukkan harga low',
                  icon: Icons.arrow_downward_rounded,
                  errorMessage: 'Harga Low wajib diisi',
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
  }) {
    return TextFormField(
      controller: controller,

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

        return null;
      },

      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),

        prefixIcon: Icon(icon, color: const Color(0xFFF28C28)),

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
