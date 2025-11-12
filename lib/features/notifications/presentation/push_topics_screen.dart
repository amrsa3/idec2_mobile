import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/push/push_models.dart';
import '../providers/push_topics_provider.dart';

class PushTopicsScreen extends ConsumerStatefulWidget {
  const PushTopicsScreen({super.key});

  @override
  ConsumerState<PushTopicsScreen> createState() => _PushTopicsScreenState();
}

class _PushTopicsScreenState extends ConsumerState<PushTopicsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pushTopicsProvider.notifier).refreshFromServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pushTopicsProvider);
    final notifier = ref.read(pushTopicsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تفضيلات الإشعارات الفورية'),
      ),
      body: RefreshIndicator(
        onRefresh: () => notifier.refreshFromServer(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _HeaderCard(state: state),
            const SizedBox(height: 16),
            if (state.loading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (state.availableTopics.isEmpty)
              _EmptyTopicsPlaceholder(state: state)
            else
              ...state.availableTopics.map(
                (topic) => _TopicTile(
                  topic: topic,
                  enabled: state.subscribedTopics.contains(topic.key),
                  saving: state.saving,
                  onChanged: (value) => notifier.toggleTopic(topic.key, value),
                ),
              ),
            const SizedBox(height: 24),
            if (state.error != null)
              Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({required this.state});

  final PushTopicsState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إدارة تفضيلات FCM',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'قم باختيار المواضيع التي تهمك للحصول على إشعارات فورية مخصصة. يمكنك تغيير تفضيلاتك في أي وقت.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
            if (state.broadcastTopic != null &&
                state.broadcastTopic!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.security, color: AppColors.primaryDark),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'الموضوع العام ${state.broadcastTopic} مفعّل تلقائياً لاستقبال الإشعارات الحرجة مثل التنبيهات الأمنية وتحديثات المؤتمر.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.topic,
    required this.enabled,
    required this.saving,
    required this.onChanged,
  });

  final FcmTopicOption topic;
  final bool enabled;
  final bool saving;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SwitchListTile(
        value: enabled,
        onChanged: saving ? null : onChanged,
        title: Text(
          topic.label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: topic.description != null
            ? Text(
                topic.description!,
                style: const TextStyle(fontSize: 13),
              )
            : null,
        activeColor: AppColors.primary,
      ),
    );
  }
}

class _EmptyTopicsPlaceholder extends StatelessWidget {
  const _EmptyTopicsPlaceholder({required this.state});

  final PushTopicsState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(Icons.notifications_off_outlined,
                color: Colors.grey.shade400, size: 48),
            const SizedBox(height: 12),
            const Text(
              'لا توجد مواضيع اختيارية حالياً',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error != null
                  ? 'تعذر تحميل المواضيع: ${state.error}'
                  : 'سيتم عرض المواضيع الاختيارية هنا بمجرد توفيرها من إدارة المؤتمر.',
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
