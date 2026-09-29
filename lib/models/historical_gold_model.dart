class HistoricalGoldModel {
  final String date;
  final String open;
  final String high;
  final String low;
  final String close;

  const HistoricalGoldModel({
    this.date = '-',
    this.open = '-',
    this.high = '-',
    this.low = '-',
    this.close = '-',
  });

  factory HistoricalGoldModel.fromMap(dynamic data) {
    if (data is! Map) {
      return const HistoricalGoldModel();
    }

    return HistoricalGoldModel(
      date: data['date']?.toString() ?? '-',
      open: data['open']?.toString() ?? '-',
      high: data['high']?.toString() ?? '-',
      low: data['low']?.toString() ?? '-',
      close: data['close']?.toString() ?? '-',
    );
  }
}
