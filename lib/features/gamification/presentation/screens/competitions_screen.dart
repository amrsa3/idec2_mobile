import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../../../../models/competition_model.dart';
import '../providers/competition_provider.dart';

class CompetitionsScreen extends ConsumerWidget {
  const CompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final competitionsAsync = ref.watch(competitionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Competitions & Challenges'),
        centerTitle: true,
      ),
      body: competitionsAsync.when(
        data: (competitions) {
          if (competitions.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: competitions.length,
            itemBuilder: (context, index) {
              return _buildCompetitionCard(context, competitions[index], ref);
            },
          );
        },
        loading: () => const Center(child: LoadingIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No active competitions at the moment.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitionCard(BuildContext context, CompetitionModel comp, WidgetRef ref) {
    final now = DateTime.now();
    final isEnded = now.isAfter(comp.endDate);
    final isActive = comp.isActive && !isEnded;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to details or join
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.grey,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    comp.type.replaceAll('_', ' '), 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    isActive ? 'Ends in ${_getRemainingTime(comp.endDate)}' : 'Ended',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comp.titleEn,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  // Prize preview if available
                  if (comp.prizes != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.card_giftcard, color: Colors.amber),
                          const SizedBox(width: 8),
                          Expanded(child: Text('Win big prizes!')), // Placeholder for dynamic prize text
                        ],
                      ),
                    )
                  ],

                  const SizedBox(height: 16),
                  
                  if (isActive)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                           // Join action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Join Now'),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getRemainingTime(DateTime endDate) {
    final diff = endDate.difference(DateTime.now());
    if (diff.inDays > 0) return '${diff.inDays} days';
    if (diff.inHours > 0) return '${diff.inHours} hours';
    return '${diff.inMinutes} mins';
  }
}
