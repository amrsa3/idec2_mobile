import 'package:dio/dio.dart';
import 'enhanced_dio_service_v2.dart';
import '../models/competition_model.dart';

class CompetitionService {
  static final CompetitionService _instance = CompetitionService._internal();
  factory CompetitionService() => _instance;
  CompetitionService._internal();

  final EnhancedDioServiceV2 _dioService = EnhancedDioServiceV2.instance;

  Future<List<CompetitionModel>> getCompetitions() async {
    try {
      await _dioService.ensureInitialized();
      final response = await _dioService.dio.get('/competitions');
      if (response.statusCode == 200 && response.data != null) {
        return (response.data as List)
            .map((e) => CompetitionModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error fetching competitions: $e');
      return [];
    }
  }

  Future<void> joinCompetition(String id) async {
    await _dioService.ensureInitialized();
    await _dioService.dio.post('/competitions/$id/join');
  }
}
