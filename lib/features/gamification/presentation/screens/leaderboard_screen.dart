import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../models/gamification_models.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../shared/widgets/profile_image_widget.dart';
import '../../../../features/profile/providers/gamification_provider.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final myProfileAsync = ref.watch(myGamificationProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background pattern or color
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.background, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          
          leaderboardAsync.when(
            data: (leaderboard) {
              if (leaderboard.isEmpty) {
                return _buildEmptyState();
              }
              
              // Split top 3 and others
              final topThree = leaderboard.take(3).toList();
              final others = leaderboard.skip(3).toList();

              return Column(
                children: [
                  // Top 3 Podium
                  if (topThree.isNotEmpty)
                    _buildPodium(context, topThree),
                  
                  // Rest of the list
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(top: 16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          )
                        ],
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(top: 20, bottom: 80),
                        itemCount: others.length,
                        separatorBuilder: (_, __) => const Divider(indent: 70),
                        itemBuilder: (context, index) {
                          final profile = others[index];
                          final rank = index + 4; // 1-3 are in podium
                          return _buildRankItem(context, profile, rank);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: LoadingIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),

          // Sticky User Rank at Bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: myProfileAsync.when(
              data: (profile) {
                if (profile == null) return const SizedBox.shrink();
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      )
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        Text(
                          '#${profile.rank ?? '-'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 16),
                        ProfileImageWidget(
                          imageUrl: profile.user?['profile']?['profilePhotoUrl'] ?? '',
                           // Fallback logic handled within widget usually, or pass initials
                           fallbackText: 'ME',
                           size: 40,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'You',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                '${profile.totalPoints} Points',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text('No leaderboard data available yet.'),
    );
  }

  Widget _buildPodium(BuildContext context, List<GamificationProfile> topThree) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place
          if (topThree.length > 1)
            Expanded(child: _buildPodiumItem(context, topThree[1], 2)),
          
          // 1st Place (Center and larger)
          Expanded(child: _buildPodiumItem(context, topThree[0], 1, isWinner: true)),

          // 3rd Place
          if (topThree.length > 2)
            Expanded(child: _buildPodiumItem(context, topThree[2], 3)),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(BuildContext context, GamificationProfile profile, int rank, {bool isWinner = false}) {
    final double size = isWinner ? 100 : 80;
    final Color ringColor = _getRankColor(rank);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: ringColor.withOpacity(0.4),
                    blurRadius: 10,
                  )
                ],
              ),
              child: ProfileImageWidget(
                imageUrl: profile.user?['profile']?['profilePhotoUrl'] ?? '',
                size: size,
                fallbackText: '${rank}',
              ),
            ),
            Positioned(
              bottom: -10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: ringColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '#$rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          profile.user?['profile']?['fullNameEn'] ?? 'User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isWinner ? Colors.white : Colors.white70, // Assuming on dark bg/gradient context
             // Note: In this specific layout, top section is over gradient app bar extension?
             // Actually app bar is normal flexible space. We need to ensure text contrast.
          ),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          '${profile.totalPoints}',
          style: TextStyle(
            color: isWinner ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(BuildContext context, GamificationProfile profile, int rank) {
    return ListTile(
      leading: Container(
        width: 40,
        alignment: Alignment.center,
        child: Text(
          '$rank',
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        children: [
           ProfileImageWidget(
              imageUrl: profile.user?['profile']?['profilePhotoUrl'] ?? '',
              size: 40,
              fallbackText: profile.user?['email']?[0].toUpperCase() ?? 'U',
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.user?['profile']?['fullNameEn'] ?? profile.user?['email'] ?? 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Level ${profile.currentLevel}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '${profile.totalPoints} pts',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return Colors.grey;
    }
  }
}
