import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';

/// Communities screen — browse, search, join, and manage communities.
class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});

  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> {
  List<Community> _communities = [];
  List<Community> _joinedCommunities = [];
  bool _isLoading = true;
  String? _error;
  bool _showJoinedOnly = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCommunities();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCommunities() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final communities = await client.community.listCommunities(limit: 50);
      final joined = await client.community.getJoinedCommunities(
        currentProfileId!,
      );
      if (mounted) {
        setState(() {
          _communities = communities;
          _joinedCommunities = joined;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _searchCommunities(String query) async {
    if (query.isEmpty) {
      _loadCommunities();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final results = await client.community.searchCommunities(query);
      if (mounted) {
        setState(() {
          _communities = results;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _joinCommunity(int communityId) async {
    try {
      await client.community.joinCommunity(communityId, currentProfileId!);
      _loadCommunities();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Joined community!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  Future<void> _leaveCommunity(int communityId) async {
    try {
      await client.community.leaveCommunity(communityId, currentProfileId!);
      _loadCommunities();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Left community')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  void _showCreateCommunityDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final interestsCtrl = TextEditingController();
    String category = 'Technology';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create Community'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Community Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    'Technology',
                    'Research',
                    'Creative',
                    'Business',
                    'Sports',
                    'Social',
                    'Academic',
                  ]
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setDialogState(() => category = v ?? category),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: interestsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Interests (comma-separated)',
                    hintText: 'e.g., Flutter, Dart, Mobile Dev',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty || descCtrl.text.isEmpty) return;
                try {
                  final interests = interestsCtrl.text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();

                  await client.community.createCommunity(
                    Community(
                      name: nameCtrl.text,
                      description: descCtrl.text,
                      category: category,
                      interests: interests,
                      creatorProfileId: currentProfileId!,
                      memberCount: 0,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                    currentProfileId!,
                  );
                  Navigator.pop(ctx);
                  _loadCommunities();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Community created!')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _openCommunityDetail(Community community) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CommunityDetailScreen(
          community: community,
          isMember: _joinedCommunities.any((c) => c.id == community.id),
          onRefresh: _loadCommunities,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayedCommunities = _showJoinedOnly
        ? _joinedCommunities
        : _communities;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        actions: [
          IconButton(
            icon: Icon(
              _showJoinedOnly ? Icons.group : Icons.group_outlined,
              color: _showJoinedOnly
                  ? CampusTheme.deepTeal
                  : CampusTheme.textMuted,
            ),
            tooltip: 'Show joined only',
            onPressed: () =>
                setState(() => _showJoinedOnly = !_showJoinedOnly),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateCommunityDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search communities...',
                prefixIcon: Icon(Icons.search, size: 20),
              ),
              onChanged: _searchCommunities,
            ),
          ),

          // Communities list
          Expanded(
            child: _isLoading
                ? const CampusLoader()
                : _error != null
                    ? CampusError(
                        message: _error!, onRetry: _loadCommunities)
                    : displayedCommunities.isEmpty
                        ? CampusEmptyState(
                            icon: Icons.groups_outlined,
                            title: _showJoinedOnly
                                ? 'Not a member of any community'
                                : 'No communities found',
                            subtitle: 'Create the first community!',
                            actionLabel: 'Create',
                            onAction: _showCreateCommunityDialog,
                          )
                        : RefreshIndicator(
                            onRefresh: _loadCommunities,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: displayedCommunities.length,
                              itemBuilder: (ctx, i) {
                                final community = displayedCommunities[i];
                                final isMember = _joinedCommunities
                                    .any((c) => c.id == community.id);
                                return _CommunityCard(
                                  community: community,
                                  isMember: isMember,
                                  onJoin: () =>
                                      _joinCommunity(community.id!),
                                  onLeave: () =>
                                      _leaveCommunity(community.id!),
                                  onTap: () =>
                                      _openCommunityDetail(community),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _CommunityCard extends StatelessWidget {
  final Community community;
  final bool isMember;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final VoidCallback onTap;

  const _CommunityCard({
    required this.community,
    required this.isMember,
    required this.onJoin,
    required this.onLeave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = CampusTheme.categoryColor(community.category);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child:
                        Icon(Icons.groups_2, color: catColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          community.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: catColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                community.category,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: catColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(Icons.people_outline,
                                size: 14, color: CampusTheme.textMuted),
                            const SizedBox(width: 4),
                            Text(
                              '${community.memberCount}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: CampusTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  isMember
                      ? OutlinedButton(
                          onPressed: onLeave,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            side: const BorderSide(
                                color: CampusTheme.textMuted),
                          ),
                          child: const Text('Joined',
                              style: TextStyle(fontSize: 12)),
                        )
                      : ElevatedButton(
                          onPressed: onJoin,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                          ),
                          child: const Text('Join',
                              style: TextStyle(fontSize: 12)),
                        ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                community.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textMuted,
                  height: 1.4,
                ),
              ),
              if (community.interests.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: community.interests
                      .map((interest) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: CampusTheme.darkCardLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              interest,
                              style: const TextStyle(
                                fontSize: 11,
                                color: CampusTheme.textMuted,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// ─── Community Detail Screen ───
class _CommunityDetailScreen extends StatefulWidget {
  final Community community;
  final bool isMember;
  final VoidCallback onRefresh;

  const _CommunityDetailScreen({
    required this.community,
    required this.isMember,
    required this.onRefresh,
  });

  @override
  State<_CommunityDetailScreen> createState() =>
      _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<_CommunityDetailScreen> {
  List<CommunityPost> _posts = [];
  List<CommunityMembership> _members = [];
  bool _isLoading = true;
  bool _isMember = false;

  @override
  void initState() {
    super.initState();
    _isMember = widget.isMember;
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final posts = await client.communityPost.listPosts(
        widget.community.id!,
      );
      final members = await client.community.getMembers(
        widget.community.id!,
      );
      final memberCheck = await client.community.isMember(
        widget.community.id!,
        currentProfileId!,
      );
      if (mounted) {
        setState(() {
          _posts = posts;
          _members = members;
          _isMember = memberCheck;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showCreatePostDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Post'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentCtrl,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) return;
              try {
                await client.communityPost.createPost(
                  CommunityPost(
                    communityId: widget.community.id!,
                    authorProfileId: currentProfileId!,
                    title: titleCtrl.text,
                    content: contentCtrl.text,
                    isPinned: false,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
                Navigator.pop(ctx);
                _loadData();
              } catch (e) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catColor = CampusTheme.categoryColor(widget.community.category);
    final isCreator =
        widget.community.creatorProfileId == currentProfileId;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        actions: [
          if (isCreator)
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Community settings coming soon')),
                );
              },
            ),
        ],
      ),
      floatingActionButton: _isMember
          ? FloatingActionButton(
              onPressed: _showCreatePostDialog,
              child: const Icon(Icons.edit),
            )
          : null,
      body: _isLoading
          ? const CampusLoader()
          : ListView(
              children: [
                // Community header
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        catColor.withValues(alpha: 0.15),
                        CampusTheme.darkCard,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: catColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: catColor.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              widget.community.category,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: catColor,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.people, size: 16, color: catColor),
                          const SizedBox(width: 4),
                          Text(
                            '${_members.length} members',
                            style: TextStyle(
                              fontSize: 13,
                              color: catColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.community.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: CampusTheme.textLight,
                          height: 1.5,
                        ),
                      ),
                      if (widget.community.interests.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: widget.community.interests
                              .map((i) => Chip(
                                    label: Text(i,
                                        style:
                                            const TextStyle(fontSize: 12)),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                // Posts section
                SectionHeader(
                  title: 'Posts',
                  actionLabel:
                      _isMember ? 'New Post' : null,
                  onAction: _isMember ? _showCreatePostDialog : null,
                ),

                if (_posts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CampusEmptyState(
                      icon: Icons.article_outlined,
                      title: 'No posts yet',
                      subtitle:
                          'Be the first to share something with the community',
                    ),
                  )
                else
                  ..._posts.map((post) => _PostCard(
                        post: post,
                        isAdmin: isCreator,
                        onDelete: () async {
                          await client.communityPost.deletePost(
                            post.id!,
                            currentProfileId!,
                          );
                          _loadData();
                        },
                      )),

                const SizedBox(height: 80),
              ],
            ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final bool isAdmin;
  final VoidCallback onDelete;

  const _PostCard({
    required this.post,
    required this.isAdmin,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (post.isPinned)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.push_pin,
                        size: 14, color: CampusTheme.coral),
                  ),
                Expanded(
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isAdmin || post.authorProfileId == currentProfileId)
                  PopupMenuButton(
                    icon: const Icon(Icons.more_vert, size: 18),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (v) {
                      if (v == 'delete') onDelete();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.content,
              style: const TextStyle(
                fontSize: 14,
                color: CampusTheme.textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _formatDate(post.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: CampusTheme.textMuted.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
