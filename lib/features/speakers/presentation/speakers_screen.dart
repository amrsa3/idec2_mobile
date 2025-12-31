import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/speaker_model.dart';
import '../../../services/speaker_service.dart';
import '../../../shared/widgets/authenticated_image_widget.dart';
import 'speaker_details_screen.dart';

// Provider for speakers - using a key to force refresh
final speakersProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, key) async {
  final speakerService = SpeakerService();
  // Parse filters from key
  final parts = key.split('|');
  final page = int.tryParse(parts[0]) ?? 1;
  final limit = int.tryParse(parts[1]) ?? 100;
  final search = parts.length > 2 && parts[2].isNotEmpty ? parts[2] : null;

  return await speakerService.getSpeakers(
    page: page,
    limit: limit,
    search: search,
  );
});

class SpeakersScreen extends ConsumerStatefulWidget {
  const SpeakersScreen({super.key});

  @override
  ConsumerState<SpeakersScreen> createState() => _SpeakersScreenState();
}

class _SpeakersScreenState extends ConsumerState<SpeakersScreen> {
  String? _searchQuery;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Create a unique key for the provider based on filters
    // This ensures the provider refreshes when search query changes
    final providerKey = '1|100|${_searchQuery ?? ''}';
    final speakersAsync = ref.watch(speakersProvider(providerKey));

    return Scaffold(
      backgroundColor: context.colors.background,
      appBar: AppBar(
        title: Text(
          l10n.speakers,
          style: TextStyle(
            color: context.colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.colors.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            color: context.colors.surface,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'ابحث عن متحدث...',
                prefixIcon:
                    Icon(Icons.search, color: context.colors.textSecondary),
                filled: true,
                fillColor: context.colors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.isEmpty ? null : value;
                });
                // Provider will automatically refresh when filters change
              },
            ),
          ),
          // Speakers list
          Expanded(
            child: speakersAsync.when(
              data: (data) {
                final speakers = (data['data'] as List<SpeakerModel>);

                if (speakers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 80,
                          color: context.colors.textSecondary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'لا يوجد متحدثون',
                          style: TextStyle(
                            fontSize: 18,
                            color: context.colors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Force refresh by invalidating with current key
                    ref.invalidate(speakersProvider(providerKey));
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.7, // Reduced from 0.75 to fix overflow
                    ),
                    itemCount: speakers.length,
                    itemBuilder: (context, index) {
                      return _buildSpeakerCard(context, speakers[index]);
                    },
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) {
                print('❌ [SPEAKERS_SCREEN] Error: $error');
                print('❌ [SPEAKERS_SCREEN] Stack: $stack');
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'حدث خطأ في تحميل المتحدثين',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: context.colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          ref.invalidate(speakersProvider(providerKey));
                        },
                        child: Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerCard(BuildContext context, SpeakerModel speaker) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SpeakerDetailsScreen(speakerId: speaker.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Photo
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  color: AppColors.surfaceVariant,
                ),
                child: speaker.hasPhoto
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16)),
                        child: AuthenticatedImageWidget(
                          imageUrl: speaker.photoUrl!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: context.colors.textSecondary,
                        ),
                      ),
              ),
            ),
            // Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
                  children: [
                    // Name (Arabic only, without title)
                    Text(
                      speaker.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: context.colors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Title (separate field below name)
                    if (speaker.title != null && speaker.title!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        speaker.title!,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (speaker.organization != null &&
                        speaker.organization!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        speaker.organization!,
                        style: TextStyle(
                          fontSize: 10,
                          color: context.colors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const Spacer(), // Add spacer to push events count to bottom
                    if (speaker.eventsCountValue > 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event,
                              size: 12, color: context.colors.textSecondary),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${speaker.eventsCountValue} فعالية',
                              style: TextStyle(
                                fontSize: 10,
                                color: context.colors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
