import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/competition_model.dart';
import '../../../../services/competition_service.dart';

final competitionServiceProvider = Provider<CompetitionService>((ref) {
  return CompetitionService();
});

final competitionsProvider = FutureProvider.autoDispose<List<CompetitionModel>>((ref) async {
  final service = ref.watch(competitionServiceProvider);
  return service.getCompetitions();
});
