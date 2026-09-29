class PhysicalGoldCalculatorModel {
  final double modal;
  final double kurs;
  final double hargaBeli;
  final double hargaJual;

  final double hasilHargaBeli;
  final double hasilHargaJual;
  final double selisihHarga;
  final double jumlahEmas;
  final double keuntungan;

  const PhysicalGoldCalculatorModel({
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
}
