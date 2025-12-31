import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../models/gamification_models.dart';
import '../../../../services/gamification_service.dart';

final gamificationServiceProvider = Provider<GamificationService>((ref) {
  return GamificationService();
});

final myGamificationProfileProvider = FutureProvider.autoDispose<GamificationProfile?>((ref) async {
  final service = ref.watch(gamificationServiceProvider);
  return service.getMyProfile();
});

final leaderboardProvider = FutureProvider.autoDispose<List<GamificationProfile>>((ref) async {
  final service = ref.watch(gamificationServiceProvider);
  return service.getLeaderboard();
});
