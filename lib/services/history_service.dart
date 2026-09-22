import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/history_model.dart';

class HistoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> saveHistory({
    required String calculatorType,
    required Map<String, dynamic> inputData,
    required Map<String, dynamic> resultData,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    await _supabase.from('calculation_history').insert({
      'user_id': user.id,
      'calculator_type': calculatorType,
      'input_data': inputData,
      'result_data': resultData,
    });
  }

  Future<List<HistoryModel>> getHistory() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    final response = await _supabase
        .from('calculation_history')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => HistoryModel.fromMap(item))
        .toList();
  }

  Future<void> deleteHistory(String id) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User belum login.');
    }

    await _supabase
        .from('calculation_history')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id);
  }
}
