import 'package:flutter/material.dart';
import '../../data/models/chat_enums.dart';

/// New Conversation Screen
/// Start a new conversation with different context types
class NewConversationScreen extends StatefulWidget {
  final Future<void> Function({
    required ChatConversationType type,
    required String recipientId,
    String? subject,
    String? productId,
    String? initialMessage,
  }) onCreateConversation;

  const NewConversationScreen({
    super.key,
    required this.onCreateConversation,
  });

  @override
  State<NewConversationScreen> createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  ChatConversationType? _selectedType;
  String? _selectedCategory;
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isCreating = false;

  final _supportCategories = [
    {'id': 'payment', 'name': 'الدفع والفواتير', 'icon': Icons.payment},
    {'id': 'order', 'name': 'الطلبات والشحن', 'icon': Icons.local_shipping},
    {'id': 'technical', 'name': 'مشاكل تقنية', 'icon': Icons.settings},
    {'id': 'account', 'name': 'الحساب والتسجيل', 'icon': Icons.person},
    {'id': 'refund', 'name': 'الاسترجاع والاستبدال', 'icon': Icons.replay},
    {'id': 'other', 'name': 'استفسارات أخرى', 'icon': Icons.help_outline},
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('محادثة جديدة'),
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: _selectedType == null
          ? _buildTypeSelection(theme)
          : _buildConversationForm(theme),
    );
  }

  Widget _buildTypeSelection(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor.withOpacity(0.1),
                  theme.primaryColor.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: theme.primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  'اختر نوع المحادثة',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'حدد نوع المحادثة المناسب لمساعدتك بشكل أفضل',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Conversation type cards
          _buildTypeCard(
            theme,
            type: ChatConversationType.marketplace,
            title: 'تواصل مع تاجر',
            subtitle: 'استفسارات عن المنتجات، طلب أسعار، التفاوض',
            icon: Icons.shopping_bag_outlined,
            color: const Color(0xFF10B981),
          ),

          const SizedBox(height: 12),

          _buildTypeCard(
            theme,
            type: ChatConversationType.support,
            title: 'الدعم الفني',
            subtitle: 'مساعدة تقنية، مشاكل الحساب، الاستفسارات',
            icon: Icons.support_agent_outlined,
            color: const Color(0xFFF59E0B),
          ),

          const SizedBox(height: 12),

          _buildTypeCard(
            theme,
            type: ChatConversationType.event,
            title: 'استفسارات المؤتمر',
            subtitle: 'الجدول، المواقع، الشهادات، التسجيل',
            icon: Icons.event_outlined,
            color: const Color(0xFF3B82F6),
          ),

          const SizedBox(height: 32),

          // Quick actions
          Text(
            'أو جرب',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickActionChip(theme, 'أين يمكنني إيجاد...؟', Icons.search),
              _buildQuickActionChip(theme, 'لدي مشكلة في الطلب', Icons.error_outline),
              _buildQuickActionChip(theme, 'كيف أحصل على شهادتي؟', Icons.card_membership),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(
    ThemeData theme, {
    required ChatConversationType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedType = type),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionChip(ThemeData theme, String label, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {
        setState(() => _selectedType = ChatConversationType.support);
        _messageController.text = label;
      },
    );
  }

  Widget _buildConversationForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to type selection
          TextButton.icon(
            onPressed: () => setState(() {
              _selectedType = null;
              _selectedCategory = null;
            }),
            icon: const Icon(Icons.arrow_back),
            label: const Text('تغيير نوع المحادثة'),
          ),

          const SizedBox(height: 16),

          // Selected type indicator
          _buildSelectedTypeCard(theme),

          const SizedBox(height: 24),

          // Form based on type
          if (_selectedType == ChatConversationType.support) ...[
            Text(
              'اختر تصنيف المشكلة',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildCategoryGrid(theme),
            const SizedBox(height: 24),
          ],

          // Subject
          Text(
            'عنوان المحادثة',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'مثال: استفسار عن منتج...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            ),
          ),

          const SizedBox(height: 24),

          // Initial message
          Text(
            'رسالتك',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'اكتب رسالتك هنا...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            ),
          ),

          const SizedBox(height: 32),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _isCreating ? null : _createConversation,
              icon: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send),
              label: Text(_isCreating ? 'جاري الإرسال...' : 'إرسال'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTypeCard(ThemeData theme) {
    late Color color;
    late IconData icon;
    late String title;

    switch (_selectedType) {
      case ChatConversationType.marketplace:
        color = const Color(0xFF10B981);
        icon = Icons.shopping_bag_outlined;
        title = 'تواصل مع تاجر';
        break;
      case ChatConversationType.support:
        color = const Color(0xFFF59E0B);
        icon = Icons.support_agent_outlined;
        title = 'الدعم الفني';
        break;
      case ChatConversationType.event:
        color = const Color(0xFF3B82F6);
        icon = Icons.event_outlined;
        title = 'استفسارات المؤتمر';
        break;
      default:
        color = theme.primaryColor;
        icon = Icons.chat;
        title = 'محادثة';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ),
          Icon(Icons.check_circle, color: color),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid(ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _supportCategories.map((cat) {
        final isSelected = _selectedCategory == cat['id'];
        return ChoiceChip(
          selected: isSelected,
          onSelected: (_) => setState(() => _selectedCategory = cat['id'] as String),
          avatar: Icon(cat['icon'] as IconData, size: 18),
          label: Text(cat['name'] as String),
          selectedColor: const Color(0xFFF59E0B).withOpacity(0.2),
        );
      }).toList(),
    );
  }

  Future<void> _createConversation() async {
    if (_selectedType == null) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء كتابة رسالتك')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      await widget.onCreateConversation(
        type: _selectedType!,
        recipientId: 'support', // This would be the actual recipient ID
        subject: _subjectController.text.trim().isNotEmpty
            ? _subjectController.text.trim()
            : null,
        initialMessage: message,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('حدث خطأ: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}
