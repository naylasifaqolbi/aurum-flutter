class PivotResultModel {
  // ============================================================
  // INPUT
  // ============================================================

  final double open;
  final double high;
  final double low;
  final double close;

  // ============================================================
  // PIVOT POINT
  // ============================================================

  final double pp;

  // ============================================================
  // RESISTANCE
  // ============================================================

  final double r1;
  final double r2;
  final double r3;
  final double r4;

  // ============================================================
  // SUPPORT
  // ============================================================

  final double s1;
  final double s2;
  final double s3;
  final double s4;

  // ============================================================
  // MIDPOINT RESISTANCE
  // ============================================================

  final double midpointR4R3;
  final double midpointR3R2;
  final double midpointR2R1;
  final double midpointPPR1;

  // ============================================================
  // MIDPOINT SUPPORT
  // ============================================================

  final double midpointPPS1;
  final double midpointS1S2;
  final double midpointS2S3;
  final double midpointS3S4;

  // ============================================================
  // INDIKASI
  // ============================================================

  final String indication;

  // ============================================================
  // TIPE PIVOT
  // ============================================================

  final String pivotType;

  // ============================================================
  // CONSTRUCTOR
  // ============================================================

  const PivotResultModel({
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
}
