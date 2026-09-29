import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/pivot_result_model.dart';
import '../../viewmodels/pivot_result_viewmodel.dart';

// ================================================================
// COLORS
// ================================================================

const Color backgroundColor = Color(0xFFFFF8F0);
const Color orangeColor = Color(0xFFF28C28);
const Color darkBrown = Color(0xFF3D2B1F);
const Color greenColor = Color(0xFF2E8B57);
const Color lightGreen = Color(0xFFE8F7EC);
const Color redColor = Color(0xFFD9534F);
const Color lightRed = Color(0xFFFCEAEA);
const Color lightOrange = Color(0xFFFFE5CC);

// ================================================================
// PIVOT RESULT
// ================================================================

class PivotResult extends StatelessWidget {
  // ==============================================================
  // INPUT DATA
  // ==============================================================

  final double open;
  final double high;
  final double low;
  final double close;

  // ==============================================================
  // PIVOT POINT
  // ==============================================================

  final double pp;

  // ==============================================================
  // RESISTANCE
  // ==============================================================

  final double r1;
  final double r2;
  final double r3;
  final double r4;

  // ==============================================================
  // SUPPORT
  // ==============================================================

  final double s1;
  final double s2;
  final double s3;
  final double s4;

  // ==============================================================
  // MIDPOINT RESISTANCE
  // ==============================================================

  final double midpointR4R3;
  final double midpointR3R2;
  final double midpointR2R1;
  final double midpointPPR1;

  // ==============================================================
  // MIDPOINT SUPPORT
  // ==============================================================

  final double midpointPPS1;
  final double midpointS1S2;
  final double midpointS2S3;
  final double midpointS3S4;

  // ==============================================================
  // INDIKASI
  // ==============================================================

  final String indication;

  // ==============================================================
  // PIVOT TYPE
  // ==============================================================

  final String pivotType;

  // ==============================================================
  // CONSTRUCTOR
  // ==============================================================

  const PivotResult({
    super.key,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.pp,
    required this.r1,
    required this.r2,
    required this.r3,
    required this.r4,
    required this.s1,
    required this.s2,
    required this.s3,
    required this.s4,
    required this.midpointR4R3,
    required this.midpointR3R2,
    required this.midpointR2R1,
    required this.midpointPPR1,
    required this.midpointPPS1,
    required this.midpointS1S2,
    required this.midpointS2S3,
    required this.midpointS3S4,
    required this.indication,
    this.pivotType = 'Emas',
  });

  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {
    final model = PivotResultModel(
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
      pivotType: pivotType,
    );

    return ChangeNotifierProvider(
      create: (_) => PivotResultViewModel(model: model),
      child: const _PivotResultContent(),
    );
  }
}

// ================================================================
// PIVOT RESULT CONTENT
// ================================================================

class _PivotResultContent extends StatelessWidget {
  const _PivotResultContent();

  @override
  Widget build(BuildContext context) {
    final model = context.read<PivotResultViewModel>().model;

    final bool isHangSeng = model.pivotType == 'Hang Seng';

    final String resultTitle = isHangSeng
        ? 'Hasil Pivot Hang Seng'
        : 'Hasil Pivot Point Emas';

    return Scaffold(
      backgroundColor: backgroundColor,

      // ==========================================================
      // APP BAR
      // ==========================================================
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkBrown,
            size: 25,
          ),
        ),

        title: Text(
          resultTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: orangeColor,
          ),
        ),

        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFE5E5E5)),
        ),
      ),

      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputCard(model),

              const SizedBox(height: 20),

              _buildSectionTitle('Hasil Pivot Point'),

              const SizedBox(height: 12),

              _buildPivotLevelsCard(model),

              const SizedBox(height: 25),

              _buildIndicationCard(model),

              const SizedBox(height: 20),

              // ==================================================
              // HITUNG LAGI
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text(
                    'Hitung Lagi',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: orangeColor,
                    side: const BorderSide(color: orangeColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ==================================================
              // UNDUH PDF
              // ==================================================
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _downloadResult(context);
                  },
                  icon: const Icon(Icons.download_rounded, size: 20),
                  label: const Text(
                    'Unduh Hasil Perhitungan',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orangeColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
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

  // ==============================================================
  // DOWNLOAD RESULT
  // ==============================================================

  Future<void> _downloadResult(BuildContext context) async {
    final viewModel = context.read<PivotResultViewModel>();

    final bool success = await viewModel.downloadResult();

    if (!context.mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal membuat PDF: ${viewModel.errorMessage}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==============================================================
  // SECTION TITLE
  // ==============================================================

  Widget _buildSectionTitle(String title, {Color color = darkBrown}) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
    );
  }

  // ==============================================================
  // INPUT CARD
  // ==============================================================

  Widget _buildInputCard(PivotResultModel model) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ========================================================
          // WATERMARK EWF
          // ========================================================
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.35,
                child: Image.asset(
                  'assets/images/ewf-logo.png',
                  width: 500,
                  height: 500,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // ========================================================
          // DATA
          // ========================================================
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Rincian Perhitungan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkBrown,
                ),
              ),

              const SizedBox(height: 10),

              _buildInputRow(
                icon: Icons.radio_button_checked_rounded,
                title: 'Open',
                value: model.open,
              ),

              const Divider(height: 20),

              _buildInputRow(
                icon: Icons.arrow_upward_rounded,
                title: 'High',
                value: model.high,
              ),

              const Divider(height: 20),

              _buildInputRow(
                icon: Icons.arrow_downward_rounded,
                title: 'Low',
                value: model.low,
              ),

              const Divider(height: 20),

              _buildInputRow(
                icon: Icons.show_chart_rounded,
                title: 'Close',
                value: model.close,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // INPUT ROW
  // ==============================================================

  Widget _buildInputRow({
    required IconData icon,
    required String title,
    required double value,
  }) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: orangeColor, size: 22),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFF777777)),
          ),
        ),

        Text(
          _formatNumber(value),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: darkBrown,
          ),
        ),
      ],
    );
  }

  // ==============================================================
  // PIVOT LEVELS CARD
  // ==============================================================

  Widget _buildPivotLevelsCard(PivotResultModel model) {
    return Column(
      children: [
        _buildPivotLevelRow(
          level: 'R4',
          formula: 'PP + (H - L) × 3',
          value: model.r4,
          color: greenColor,
          midpoint: model.midpointR4R3,
          midpointFormula: '(R4 + R3) / 2',
        ),

        _buildPivotLevelRow(
          level: 'R3',
          formula: 'PP + (H - L) × 2',
          value: model.r3,
          color: greenColor,
          midpoint: model.midpointR3R2,
          midpointFormula: '(R3 + R2) / 2',
        ),

        _buildPivotLevelRow(
          level: 'R2',
          formula: 'PP + (H - L)',
          value: model.r2,
          color: greenColor,
          midpoint: model.midpointR2R1,
          midpointFormula: '(R2 + R1) / 2',
        ),

        _buildPivotLevelRow(
          level: 'R1',
          formula: '2 × PP - L',
          value: model.r1,
          color: greenColor,
          midpoint: model.midpointPPR1,
          midpointFormula: '(PP + R1) / 2',
        ),

        _buildPivotLevelRow(
          level: 'PP',
          formula: '(H + L + C) / 3',
          value: model.pp,
          color: orangeColor,
          midpoint: model.midpointPPS1,
          midpointFormula: '(PP + S1) / 2',
        ),

        _buildPivotLevelRow(
          level: 'S1',
          formula: '2 × PP - H',
          value: model.s1,
          color: redColor,
          midpoint: model.midpointS1S2,
          midpointFormula: '(S1 + S2) / 2',
        ),

        _buildPivotLevelRow(
          level: 'S2',
          formula: 'PP - (H - L)',
          value: model.s2,
          color: redColor,
          midpoint: model.midpointS2S3,
          midpointFormula: '(S2 + S3) / 2',
        ),

        _buildPivotLevelRow(
          level: 'S3',
          formula: 'PP - (H - L) × 2',
          value: model.s3,
          color: redColor,
          midpoint: model.midpointS3S4,
          midpointFormula: '(S3 + S4) / 2',
        ),

        _buildPivotLevelRow(
          level: 'S4',
          formula: 'PP - (H - L) × 3',
          value: model.s4,
          color: redColor,
        ),
      ],
    );
  }

  // ==============================================================
  // PIVOT LEVEL ROW
  // ==============================================================

  Widget _buildPivotLevelRow({
    required String level,
    required String formula,
    required double value,
    required Color color,
    double? midpoint,
    String? midpointFormula,
  }) {
    final bool isPivotPoint = level == 'PP';

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            color: isPivotPoint ? lightOrange : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isPivotPoint
                  ? orangeColor.withOpacity(0.45)
                  : const Color(0xFFE5E5E5),
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 38,
                child: Text(
                  level,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  formula,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF777777),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Text(
                _formatNumber(value),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),

        if (midpoint != null && midpointFormula != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Midpoint $midpointFormula',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF999999),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  _formatNumber(midpoint),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 5),
      ],
    );
  }

  // ==============================================================
  // PIVOT CARD
  // ==============================================================

  Widget _buildPivotCard(PivotResultModel model) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAD6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: orangeColor, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: orangeColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: orangeColor,
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.show_chart_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pivot Point (PP) ${model.pivotType}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkBrown,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'PP = (High + Low + Close) / 3',
                  style: TextStyle(fontSize: 10, color: Color(0xFF777777)),
                ),

                const SizedBox(height: 3),

                Text(
                  _formatNumber(model.pp),
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: orangeColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // RESISTANCE BLOCK
  // ==============================================================

  Widget _buildResistanceBlock({
    required String level,
    required double value,
    required String formula,
    required String midpointText,
    required double midpoint,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: greenColor, width: 3),
          top: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
          bottom: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 38,
            child: Text(
              level,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: greenColor,
              ),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formula,
                  style: const TextStyle(fontSize: 11, color: darkBrown),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Text(
                      'midpoint',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF999999)),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        midpointText.replaceFirst('Midpoint = ', ''),
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF999999),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Text(
            _formatNumber(value),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: greenColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // SUPPORT BLOCK
  // ==============================================================

  Widget _buildSupportBlock({
    required String level,
    required double value,
    required String formula,
    required String midpointText,
    required double midpoint,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(color: redColor, width: 3),
          top: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
          bottom: const BorderSide(color: Color(0xFFE5E5E5), width: 0.7),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 38,
            child: Text(
              level,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: redColor,
              ),
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formula,
                  style: const TextStyle(fontSize: 11, color: darkBrown),
                ),

                const SizedBox(height: 3),

                Row(
                  children: [
                    const Text(
                      'midpoint',
                      style: TextStyle(fontSize: 9.5, color: Color(0xFF999999)),
                    ),

                    const SizedBox(width: 5),

                    Expanded(
                      child: Text(
                        midpointText.replaceFirst('Midpoint = ', ''),
                        style: const TextStyle(
                          fontSize: 9.5,
                          color: Color(0xFF999999),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 6),

          Text(
            _formatNumber(value),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: redColor,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // MIDPOINT CARD
  // ==============================================================

  Widget _buildMidpointCard({
    required String text,
    required double value,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.compare_arrows_rounded, size: 19, color: color),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MIDPOINT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: color,
                    letterSpacing: 0.7,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777777),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Text(
            _formatNumber(value),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // INDIKASI CARD
  // ==============================================================

  Widget _buildIndicationCard(PivotResultModel model) {
    final bool isBuy = model.indication == 'BUY';

    final Color indicationColor = isBuy ? greenColor : redColor;

    final Color indicationBackground = isBuy ? lightGreen : lightRed;

    final bool isHangSeng = model.pivotType == 'Hang Seng';

    final String indicationDescription;

    if (isHangSeng) {
      indicationDescription = isBuy
          ? 'Open berada di atas Pivot Point Hang Seng.'
          : 'Open berada di bawah Pivot Point Hang Seng.';
    } else {
      indicationDescription = isBuy
          ? 'Open berada di bawah Pivot Point Emas.'
          : 'Open berada di atas Pivot Point Emas.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: indicationColor.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'INDIKASI',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: darkBrown,
              letterSpacing: 0.8,
            ),
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: indicationBackground,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: indicationColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isBuy
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.indication,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: indicationColor,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        indicationDescription,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 9),

          Text(
            'Open: ${_formatNumber(model.open)}  •  '
            'Pivot Point: ${_formatNumber(model.pp)}',
            style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }

  // ==============================================================
  // FORMAT NUMBER
  // ==============================================================

  String _formatNumber(double value) {
    return value.toStringAsFixed(2);
  }
}
