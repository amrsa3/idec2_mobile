import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/chat_enums.dart';
import '../../data/models/conversation_model.dart';
import '../widgets/conversation_tile.dart';

/// Conversations Screen
/// Main screen showing all conversations with filtering
class ConversationsScreen extends StatefulWidget {
  final List<ChatConversation> conversations;
  final bool isLoading;
  final String? error;
  final Future<void> Function() onRefresh;
  final void Function(ChatConversation) onConversationTap;
  final VoidCallback? onNewConversation;
  final int unreadCount;

  const ConversationsScreen({
    super.key,
    required this.conversations,
    required this.isLoading,
    this.error,
    required this.onRefresh,
    required this.onConversationTap,
    this.onNewConversation,
    this.unreadCount = 0,
  });

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ChatConversationType? _currentFilter;

  final _tabs = const [
    _TabItem(label: 'الكل', type: null, icon: Icons.chat_bubble_outline),
    _TabItem(label: 'المتجر', type: ChatConversationType.marketplace, icon: Icons.shopping_bag_outlined),
    _TabItem(label: 'الدعم', type: ChatConversationType.support, icon: Icons.support_agent_outlined),
    _TabItem(label: 'المؤتمر', type: ChatConversationType.event, icon: Icons.event_outlined),
    _TabItem(label: 'المجموعات', type: ChatConversationType.group, icon: Icons.groups_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentFilter = _tabs[_tabController.index].type;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ChatConversation> get _filteredConversations {
    if (_currentFilter == null) return widget.conversations;
    return widget.conversations.where((c) => c.type == _currentFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          _buildAppBar(context, theme),

          // Tabs
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabController: _tabController,
              tabs: _tabs,
              theme: theme,
            ),
          ),

          // Content
          if (widget.isLoading && widget.conversations.isEmpty)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (widget.error != null && widget.conversations.isEmpty)
            SliverFillRemaining(child: _buildErrorState(theme))
          else if (_filteredConversations.isEmpty)
            SliverFillRemaining(child: _buildEmptyState(theme))
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final conversation = _filteredConversations[index];
                  return ConversationTile(
                    conversation: conversation,
                    onTap: () => widget.onConversationTap(conversation),
                    onLongPress: () => _showConversationOptions(context, conversation),
                  );
                },
                childCount: _filteredConversations.length,
              ),
            ),
        ],
      ),
      floatingActionButton: _buildFAB(theme),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark 
            ? Brightness.light 
            : Brightness.dark,
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        title: Text(
          'المحادثات',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.primaryColor.withOpacity(0.1),
                theme.scaffoldBackgroundColor,
              ],
            ),
          ),
        ),
      ),
      actions: [
        // Unread badge
        if (widget.unreadCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.chat_bubble,
                      size: 16,
                      color: theme.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.unreadCount}',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Search button
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showSearch(context),
        ),

        // More options
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showMoreOptions(context),
        ),
      ],
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    final icon = _currentFilter != null 
        ? _tabs.firstWhere((t) => t.type == _currentFilter).icon
        : Icons.chat_bubble_outline;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.2),
                    theme.primaryColor.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: theme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'لا توجد محادثات',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _currentFilter == null
                  ? 'ابدأ محادثة جديدة مع تاجر أو فريق الدعم'
                  : 'لا توجد محادثات في هذا القسم',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: widget.onNewConversation,
              icon: const Icon(Icons.add),
              label: const Text('محادثة جديدة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'حدث خطأ',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.error ?? 'تعذر تحميل المحادثات',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: widget.onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAB(ThemeData theme) {
    return FloatingActionButton(
      onPressed: widget.onNewConversation,
      backgroundColor: theme.primaryColor,
      child: const Icon(Icons.edit_outlined, color: Colors.white),
    );
  }

  void _showSearch(BuildContext context) {
    // Show search modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SearchSheet(),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.mark_chat_read_outlined),
              title: const Text('تحديد الكل كمقروء'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('المحادثات المؤرشفة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('إعدادات المحادثات'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showConversationOptions(BuildContext context, ChatConversation conversation) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.push_pin_outlined),
              title: const Text('تثبيت'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.notifications_off_outlined),
              title: const Text('كتم الإشعارات'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.archive_outlined),
              title: const Text('أرشفة'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('حذف', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final ChatConversationType? type;
  final IconData icon;

  const _TabItem({
    required this.label,
    this.type,
    required this.icon,
  });
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final List<_TabItem> tabs;
  final ThemeData theme;

  _TabBarDelegate({
    required this.tabController,
    required this.tabs,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        labelColor: theme.primaryColor,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorColor: theme.primaryColor,
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: tabs.map((tab) => Tab(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(tab.icon, size: 18),
              const SizedBox(width: 6),
              Text(tab.label),
            ],
          ),
        )).toList(),
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

class _SearchSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Search field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'ابحث في المحادثات...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Search results
              Expanded(
                child: Center(
                  child: Text(
                    'ابدأ الكتابة للبحث',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
