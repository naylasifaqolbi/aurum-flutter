class HistoryModel {
  final String id;
  final String userId;
  final String calculatorType;
  final DateTime createdAt;
  final Map<String, dynamic> inputData;
  final Map<String, dynamic> resultData;

  HistoryModel({
    required this.id,
    required this.userId,
    required this.calculatorType,
    required this.createdAt,
    required this.inputData,
    required this.resultData,
  });

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      userId: map['user_id'],
      calculatorType: map['calculator_type'],
      createdAt: DateTime.parse(map['created_at']),
      inputData: Map<String, dynamic>.from(map['input_data']),
      resultData: Map<String, dynamic>.from(map['result_data']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'calculator_type': calculatorType,
      'created_at': createdAt.toIso8601String(),
      'input_data': inputData,
      'result_data': resultData,
    };
  }
}
