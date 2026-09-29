class DashboardModel {
  final String date;
  final String open;
  final String high;
  final String low;
  final String close;

  const DashboardModel({
    this.date = '-',
    this.open = '-',
    this.high = '-',
    this.low = '-',
    this.close = '-',
  });

  factory DashboardModel.fromMap(Map<dynamic, dynamic> map) {
    return DashboardModel(
      date: map['date']?.toString() ?? '-',
      open: map['open']?.toString() ?? '-',
      high: map['high']?.toString() ?? '-',
      low: map['low']?.toString() ?? '-',
      close: map['close']?.toString() ?? '-',
    );
  }
}
