import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../services/live_interaction_service.dart';
import '../../../../core/auth/auth.dart';

// Simple provider for the service (singleton usually)
final liveInteractionServiceProvider = Provider((ref) => LiveInteractionService());

class LiveInteractionScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final String sessionTitle;

  const LiveInteractionScreen({
    super.key,
    required this.sessionId,
    required this.sessionTitle,
  });

  @override
  ConsumerState<LiveInteractionScreen> createState() => _LiveInteractionScreenState();
}

class _LiveInteractionScreenState extends ConsumerState<LiveInteractionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _questionController = TextEditingController();
  
  List<dynamic> _questions = [];
  dynamic _activePoll;
  dynamic _pollResults;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    _connectSocket();
  }
  
  void _connectSocket() {
    final service = ref.read(liveInteractionServiceProvider);
    
    // Setup listeners
    service.onQuestionApproved = (data) {
      if (mounted) {
        setState(() {
          _questions.insert(0, data); // Newest first
        });
      }
    };

    service.onPollLive = (data) {
       if (mounted) {
        setState(() {
          _activePoll = data;
          _tabController.animateTo(1); // Switch to polls tab
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New poll is live!'))
          );
        });
      }
    };

    service.onPollResults = (data) {
       if (mounted) {
         setState(() {
           _pollResults = data;
         });
       }
    };

    // Connect
    service.connect(widget.sessionId);
  }

  @override
  void dispose() {
    ref.read(liveInteractionServiceProvider).leaveSession(widget.sessionId);
    _tabController.dispose();
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Live Interaction', style: TextStyle(fontSize: 16)),
            Text(widget.sessionTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Q&A'),
            Tab(text: 'Polls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQATab(),
           _buildPollsTab(),
        ],
      ),
    );
  }

  Widget _buildQATab() {
    final user = ref.watch(authProvider).user;

    return Column(
        children: [
            Expanded(
                child: _questions.isEmpty 
                    ? const Center(child: Text('No questions yet. Be the first to ask!'))
                    : ListView.builder(
                        itemCount: _questions.length,
                        padding: const EdgeInsets.all(16),
                        itemBuilder: (context, index) {
                            final q = _questions[index];
                            return Card(
                                child: ListTile(
                                    leading: CircleAvatar(child: Text(q['user']?['profile']?['fullNameEn']?[0] ?? 'U')),
                                    title: Text(q['content']),
                                    subtitle: Text(q['user']?['profile']?['fullNameEn'] ?? 'Anonymous'),
                                    trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Text('${q['upvotes'] ?? 0}'),
                                            const Icon(Icons.thumb_up_alt_outlined, size: 16),
                                        ],
                                    ),
                                ),
                            );
                        },
                    )
            ),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))]
                ),
                child: Row(
                    children: [
                        Expanded(
                            child: TextField(
                                controller: _questionController,
                                decoration: const InputDecoration(
                                    hintText: 'Ask a question...',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                ),
                            ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                            onPressed: () {
                                if (_questionController.text.trim().isNotEmpty && user != null) {
                                    ref.read(liveInteractionServiceProvider).askQuestion(
                                        widget.sessionId, 
                                        _questionController.text.trim(),
                                         user.id // Handle user ID properly
                                    );
                                    _questionController.clear();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Question sent for approval'))
                                    );
                                }
                            }, 
                            icon: const Icon(Icons.send, color: Colors.blue),
                        )
                    ],
                ),
            )
        ],
    );
  }

  Widget _buildPollsTab() {
      if (_activePoll == null) {
          return const Center(child: Text('No active polls at the moment.'));
      }
      
      final poll = _activePoll;
      final options = (poll['options'] as List<dynamic>?) ?? [];
      final user = ref.watch(authProvider).user;

      return ListView(
          padding: const EdgeInsets.all(20),
          children: [
              Text(poll['questionEn'] ?? '', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ...options.map((opt) {
                  return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                          onPressed: () {
                               if (user != null) {
                                   ref.read(liveInteractionServiceProvider).votePoll(
                                       widget.sessionId, 
                                       poll['id'], 
                                       opt['id'], 
                                       null,
                                       user.id
                                   );
                                   // show thank you or transition to results
                               }
                          },
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.centerLeft
                          ),
                          child: Text(opt['textEn'] ?? ''),
                      ),
                  );
              }).toList(),
              
              const SizedBox(height: 20),
              if (_pollResults != null)
                 _buildResultsChart()
          ],
      );
  }

  Widget _buildResultsChart() {
      return const Card(
          child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Live Results Placeholder'), // Implement chart later
          ),
      );
  }
}
