import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../models/campus_safety_models.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';
import 'community_admin_screen.dart';

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
  bool _canCreateCommunity = false;
  bool _isPlatformAdmin = false;
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
      final communities =
          await client.community.listCommunities(limit: 50, offset: 0);
      final joined = await client.community.getJoinedCommunities(
        currentProfileId ?? 1,
      );

      // Check community creation and admin permissions on Serverpod backend
      bool canCreate = false;
      bool isAdmin = false;
      if (currentProfileId != null) {
        try {
          canCreate = await client.communityAdmin.canCreateCommunity(
            currentProfileId!,
          );
          isAdmin = await client.communityAdmin.isAdministrator(
            currentProfileId!,
          );
        } catch (_) {}
      }

      // Ensure General Discussion community is always pinned to the top
      communities.sort((a, b) {
        if (a.name == 'General Discussion') return -1;
        if (b.name == 'General Discussion') return 1;
        return b.memberCount.compareTo(a.memberCount);
      });

      if (mounted) {
        setState(() {
          _communities = communities;
          _joinedCommunities = joined;
          _canCreateCommunity = canCreate;
          _isPlatformAdmin = isAdmin;
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

  void _showRestrictedCreateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CampusTheme.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: CampusTheme.primaryOrange),
            SizedBox(width: 10),
            Text('Access Restricted'),
          ],
        ),
        content: const Text(
          'Community creation is initially restricted to designated platform administrators (siddhidheer1@gmail.com, lavanyaupta136@gmail.com, aggarwaldivyanshi80@gmail.com) and delegated organizers.\n\nAll verified students can freely browse, join communities, and participate in discussions.\n\nContact an administrator to request community creation privileges.',
          style: TextStyle(height: 1.4, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Understood'),
          ),
        ],
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
          if (_isPlatformAdmin)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_rounded,
                  color: CampusTheme.mint),
              tooltip: 'Admin Access & Moderation',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CommunityAdminScreen(
                      onPermissionsChanged: _loadCommunities,
                    ),
                  ),
                );
              },
            ),
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
        tooltip: _canCreateCommunity
            ? 'Create Community'
            : 'Community Creation Restricted',
        backgroundColor: _canCreateCommunity
            ? CampusTheme.primaryOrange
            : CampusTheme.darkCardLight,
        onPressed: _canCreateCommunity
            ? _showCreateCommunityDialog
            : _showRestrictedCreateDialog,
        child: Icon(_canCreateCommunity
            ? Icons.add
            : Icons.lock_outline_rounded),
      ),
      body: Column(
        children: [
          // Feature Hero Banner
          CampusFeatureBanner(
            imageAsset: 'assets/images/communities_banner.jpg',
            fallbackAsset: 'assets/images/event_cultural.jpg',
            tag: 'Student Clubs & Hubs',
            tagColor: CampusTheme.mint,
            title: 'Campus Communities',
            subtitle:
                'Collaborate with coding clubs, design guilds, robotics labs, and media teams.',
            actionLabel:
                _canCreateCommunity ? 'Create Club +' : 'Restricted Access',
            onAction: _canCreateCommunity
                ? _showCreateCommunityDialog
                : _showRestrictedCreateDialog,
          ),

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
                          cleanCampusTitle(community.name),
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
                  community.name == 'General Discussion'
                      ? ElevatedButton.icon(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CampusTheme.mint,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline_rounded,
                              size: 14),
                          label: const Text(
                            'Open Forum',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : isMember
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
  final Map<int, StudentProfile> _authorProfiles = {};
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _isMember = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _isMember = widget.isMember;
    _loadData();
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final posts = await client.communityPost.listPosts(
        widget.community.id!,
        limit: 50,
        offset: 0,
      );
      final members = await client.community.getMembers(
        widget.community.id!,
      );
      final memberCheck = currentProfileId != null
          ? await client.community.isMember(
              widget.community.id!,
              currentProfileId!,
            )
          : false;
      final blockedIds = currentProfileId != null
          ? await CampusSafetyManager.getBlockedUserIds(currentProfileId!)
          : <int>{};
      final filteredPosts = posts
          .where((p) => !blockedIds.contains(p.authorProfileId))
          .toList();

      // Resolve author profiles in parallel for all unique authors
      final authorIds = filteredPosts.map((p) => p.authorProfileId).toSet();
      if (currentProfileId != null) {
        authorIds.add(currentProfileId!);
      }
      final missingIds =
          authorIds.where((id) => !_authorProfiles.containsKey(id)).toList();
      if (missingIds.isNotEmpty) {
        final profileResults = await Future.wait(
          missingIds.map((id) async {
            try {
              final p = await client.profile.getProfile(id);
              return MapEntry(id, p);
            } catch (_) {
              return null;
            }
          }),
        );
        for (final entry in profileResults) {
          if (entry != null && entry.value != null) {
            _authorProfiles[entry.key] = entry.value!;
          }
        }
      }

      if (mounted) {
        setState(() {
          _posts = filteredPosts;
          _members = members;
          _isMember = memberCheck;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Send instant chat message in General Discussion or joined community
  Future<void> _sendChatMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;
    if (currentProfileId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to chat.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    _chatController.clear();
    setState(() => _isSending = true);

    try {
      final now = DateTime.now();
      final post = CommunityPost(
        communityId: widget.community.id!,
        authorProfileId: currentProfileId!,
        title: text.length > 50 ? '${text.substring(0, 47)}...' : text,
        content: text,
        isPinned: false,
        createdAt: now,
        updatedAt: now,
      );

      await client.communityPost.createPost(post);
      await _loadData();
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      final rawMsg = e.toString().replaceAll('Exception: ', '');
      final isSpam = rawMsg.toLowerCase().contains('spam') ||
          rawMsg.toLowerCase().contains('promotional');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  isSpam ? Icons.shield_rounded : Icons.error_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    rawMsg,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: isSpam ? CampusTheme.coral : Colors.red,
            duration: Duration(seconds: isSpam ? 7 : 4),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  /// Organizer-only modal displaying enrolled students, their skills, and academic interests
  Future<void> _showOrganizerInsightsModal() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (ctx, scrollCtrl) => FutureBuilder<List<StudentProfile>>(
          future: Future.wait(
            _members.map((m) async {
              try {
                final p = await client.profile.getProfile(m.profileId);
                return p;
              } catch (_) {
                return null;
              }
            }),
          ).then((list) => list.whereType<StudentProfile>().toList()),
          builder: (ctx, snap) {
            final profiles = snap.data ?? [];
            final isLoading = snap.connectionState == ConnectionState.waiting;

            // Calculate skill clusters
            final skillCounts = <String, int>{};
            for (final p in profiles) {
              for (final s in p.studySubjects) {
                skillCounts[s] = (skillCounts[s] ?? 0) + 1;
              }
              for (final i in p.interests) {
                skillCounts[i] = (skillCounts[i] ?? 0) + 1;
              }
            }
            final sortedSkills = skillCounts.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            return ListView(
              controller: scrollCtrl,
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CampusTheme.mint.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: CampusTheme.mint,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Organizer Insights & Member Skills',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Confidential: Visible only to the community organizer',
                            style: TextStyle(
                              fontSize: 11,
                              color: CampusTheme.mint,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Skill clusters card
                if (sortedSkills.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CampusTheme.darkSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.bolt_rounded,
                                size: 16, color: CampusTheme.amberOrange),
                            SizedBox(width: 6),
                            Text(
                              'Top Skills in this Community',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: sortedSkills.take(8).map((e) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: CampusTheme.mint.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color:
                                      CampusTheme.mint.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                '${e.key} (${e.value})',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: CampusTheme.mint,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    const Text(
                      'Joined Members Roster',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${profiles.length} students',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CampusTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CampusLoader(
                          message: 'Loading member skill profiles...'),
                    ),
                  )
                else if (profiles.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No joined members yet.',
                        style: TextStyle(color: CampusTheme.textMuted),
                      ),
                    ),
                  )
                else
                  ...profiles.map((p) {
                    final isCreator =
                        p.id == widget.community.creatorProfileId;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: CampusTheme.darkSurface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isCreator
                              ? CampusTheme.mint.withValues(alpha: 0.4)
                              : Colors.white10,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: isCreator
                                    ? CampusTheme.mint.withValues(alpha: 0.2)
                                    : CampusTheme.primaryOrange
                                        .withValues(alpha: 0.2),
                                child: Text(
                                  p.displayName.isNotEmpty
                                      ? p.displayName[0].toUpperCase()
                                      : 'S',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isCreator
                                        ? CampusTheme.mint
                                        : CampusTheme.primaryOrange,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            p.displayName,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isCreator
                                                ? CampusTheme.mint
                                                    .withValues(alpha: 0.2)
                                                : Colors.white
                                                    .withValues(alpha: 0.08),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            isCreator
                                                ? '👑 Organizer'
                                                : 'Member',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              color: isCreator
                                                  ? CampusTheme.mint
                                                  : CampusTheme.textMuted,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${p.department ?? "General Studies"} · Year ${p.year ?? 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CampusTheme.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Study Subjects (Skills)
                          if (p.studySubjects.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            const Text(
                              'Academic Subjects & Strengths:',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: CampusTheme.textMuted),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children: p.studySubjects
                                  .map((s) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: CampusTheme.darkCard,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: Colors.white12),
                                        ),
                                        child: Text(
                                          s,
                                          style: const TextStyle(
                                              fontSize: 11,
                                              color: CampusTheme.textLight),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                          // Technical & Creative Interests
                          if (p.interests.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'Technical Skills & Interests:',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: CampusTheme.textMuted),
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 5,
                              runSpacing: 4,
                              children: p.interests
                                  .map((i) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: CampusTheme.primaryOrange
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                            color: CampusTheme.primaryOrange
                                                .withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Text(
                                          i,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: CampusTheme.primaryOrange,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
              ],
            );
          },
        ),
      ),
    );
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
                final rawMsg = e.toString().replaceAll('Exception: ', '');
                final isSpam = rawMsg.toLowerCase().contains('spam') ||
                    rawMsg.toLowerCase().contains('promotional');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            isSpam
                                ? Icons.shield_rounded
                                : Icons.error_outline_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              rawMsg,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: isSpam ? CampusTheme.coral : Colors.red,
                      duration: Duration(seconds: isSpam ? 7 : 4),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
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
    final isGeneral = widget.community.name == 'General Discussion';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        actions: [
          if (isCreator)
            IconButton(
              icon: const Icon(Icons.workspace_premium_rounded,
                  color: CampusTheme.mint),
              tooltip: 'Organizer Insights & Skills',
              onPressed: _showOrganizerInsightsModal,
            ),
        ],
      ),
      body: _isLoading
          ? const CampusLoader()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    controller: _scrollController,
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

                // Organizer-Only Exclusive Member Insights & Skills Banner
                if (isCreator)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CampusTheme.mint.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: CampusTheme.mint.withValues(alpha: 0.4),
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: CampusTheme.mint.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.workspace_premium_rounded,
                                color: CampusTheme.mint,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                '👑 Organizer Studio (Exclusive to You)',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: CampusTheme.mint,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Only you as the community organizer can access full member roster details, joined student profiles, and their specific skills & interests.',
                          style: TextStyle(
                            fontSize: 12,
                            color: CampusTheme.textLight,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.people_outline_rounded,
                                size: 18),
                            label: Text(
                                'View Joined Members & Skills (${_members.length})'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CampusTheme.mint,
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _showOrganizerInsightsModal,
                          ),
                        ),
                      ],
                    ),
                  ),

                // General Discussion Info Banner
                if (isGeneral)
                  Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CampusTheme.mint.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CampusTheme.mint.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user_rounded,
                            color: CampusTheme.mint, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Campus Common Space • Open to all verified students. Ask questions, discuss campus events, and share useful resources. Smart spam moderation is active.',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Posts & Discussion section
                SectionHeader(
                  title: isGeneral ? '💬 Live Campus Chat' : 'Discussion & Posts',
                  actionLabel: (_isMember || isGeneral) ? 'New Topic' : null,
                  onAction: (_isMember || isGeneral) ? _showCreatePostDialog : null,
                ),

                if (_posts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CampusEmptyState(
                      icon: isGeneral
                          ? Icons.chat_bubble_outline_rounded
                          : Icons.article_outlined,
                      title: isGeneral ? 'No messages yet' : 'No posts yet',
                      subtitle: isGeneral
                          ? 'Start the conversation below! Say hi to your fellow students.'
                          : 'Be the first to share something with the community',
                    ),
                  ),

                for (final post in _posts)
                  _PostCard(
                    post: post,
                    author: _authorProfiles[post.authorProfileId],
                    isAdmin: isCreator,
                    isGeneral: isGeneral,
                    onTapProfile: () =>
                        _showStudentProfileModal(post.authorProfileId),
                    onDelete: () async {
                      await client.communityPost.deletePost(
                        post.id!,
                        currentProfileId!,
                      );
                      _loadData();
                    },
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
          // Bottom Chat Composer Bar (Visible when member or in General Discussion)
          if (_isMember || isGeneral)
            _buildBottomChatComposer(isGeneral),
        ],
      ),
    );
  }

  /// Modern bottom chat composer bar for instant messaging
  Widget _buildBottomChatComposer(bool isGeneral) {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0
            ? MediaQuery.of(context).viewInsets.bottom + 10
            : MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: CampusTheme.darkSurface,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.post_add_rounded,
                color: CampusTheme.mint, size: 22),
            tooltip: 'Create Titled Post / Topic',
            onPressed: _showCreatePostDialog,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: CampusTheme.darkCard,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: CampusTheme.primaryOrange.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _chatController,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  hintText: isGeneral
                      ? '💬 Chat in General Discussion...'
                      : '💬 Message in ${widget.community.name}...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: CampusTheme.textMuted.withValues(alpha: 0.7),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _sendChatMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [CampusTheme.primaryOrange, CampusTheme.coral],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CampusTheme.primaryOrange.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: _isSending
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white, size: 18),
              onPressed: _isSending ? null : _sendChatMessage,
            ),
          ),
        ],
      ),
    );
  }

  /// Displays detailed profile of student posting or chatting
  void _showStudentProfileModal(int authorProfileId) {
    final profile = _authorProfiles[authorProfileId];
    if (profile == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [CampusTheme.primaryOrange, CampusTheme.coral],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(profile.displayName),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              profile.displayName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.verified_rounded,
                            size: 16,
                            color: CampusTheme.mint,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: CampusTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CampusTheme.darkSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
              child: Column(
                children: [
                  _modalInfoRow(
                    Icons.school_rounded,
                    'Department',
                    profile.department ?? 'Campus Student',
                    CampusTheme.primaryOrange,
                  ),
                  const Divider(height: 18, color: Colors.white12),
                  _modalInfoRow(
                    Icons.calendar_today_rounded,
                    'Academic Year',
                    profile.year != null ? 'Year ${profile.year}' : 'Active Student',
                    CampusTheme.mint,
                  ),
                  const Divider(height: 18, color: Colors.white12),
                  _modalInfoRow(
                    Icons.badge_rounded,
                    'Role',
                    profile.role == 'admin' ? 'Campus Administrator' : 'Verified Student',
                    CampusTheme.coral,
                  ),
                ],
              ),
            ),
            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'About',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                profile.bio!,
                style: const TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textLight,
                  height: 1.4,
                ),
              ),
            ],
            if (profile.studySubjects.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Study Subjects & Skills',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: profile.studySubjects
                    .map((s) => Chip(
                          label: Text(s, style: const TextStyle(fontSize: 11)),
                          backgroundColor: CampusTheme.darkSurface,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _modalInfoRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: CampusTheme.textMuted),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _PostCard extends StatelessWidget {
  final CommunityPost post;
  final StudentProfile? author;
  final bool isAdmin;
  final bool isGeneral;
  final VoidCallback onTapProfile;
  final VoidCallback onDelete;

  const _PostCard({
    required this.post,
    required this.author,
    required this.isAdmin,
    required this.isGeneral,
    required this.onTapProfile,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = post.authorProfileId == currentProfileId;
    final authorName = author?.displayName ??
        (isMe ? 'You' : 'Student #${post.authorProfileId}');
    final authorDept = author?.department ?? 'Campus Student';
    final authorYear = author?.year != null ? ' · Year ${author!.year}' : '';
    final isAuthorAdmin = author?.role == 'admin' ||
        author?.email == 'siddhidheer1@gmail.com' ||
        author?.email == 'lavanyaupta136@gmail.com' ||
        author?.email == 'aggarwaldivyanshi80@gmail.com';

    final isChatMessage = post.title.trim() == post.content.trim() ||
        post.title.startsWith('Chat') ||
        post.content.startsWith(post.title.replaceAll('...', ''));

    final initials = _getInitials(authorName);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: isMe
            ? CampusTheme.primaryOrange.withValues(alpha: 0.08)
            : CampusTheme.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMe
              ? CampusTheme.primaryOrange.withValues(alpha: 0.35)
              : post.isPinned
                  ? CampusTheme.coral.withValues(alpha: 0.4)
                  : Colors.white.withValues(alpha: 0.06),
          width: post.isPinned ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author Details Header (with Name, Department, Year & Verified Badge)
            InkWell(
              onTap: onTapProfile,
              borderRadius: BorderRadius.circular(10),
              child: Row(
                children: [
                  // Author Avatar Circle
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isMe
                            ? [CampusTheme.primaryOrange, CampusTheme.amberOrange]
                            : isAuthorAdmin
                                ? [CampusTheme.coral, CampusTheme.amberOrange]
                                : [CampusTheme.mint, const Color(0xFF00B4D8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isMe ? CampusTheme.primaryOrange : CampusTheme.mint)
                              .withValues(alpha: 0.25),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Name and Department/Year Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                authorName,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.verified_rounded,
                              size: 14,
                              color: CampusTheme.mint,
                            ),
                            if (isMe) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: CampusTheme.primaryOrange
                                      .withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'You',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: CampusTheme.primaryOrange,
                                  ),
                                ),
                              ),
                            ],
                            if (isAuthorAdmin) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: CampusTheme.coral.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Admin',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: CampusTheme.coral,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                '$authorDept$authorYear',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: CampusTheme.textMuted
                                      .withValues(alpha: 0.9),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              ' · ${_formatDate(post.createdAt)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: CampusTheme.textMuted
                                      .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (post.isPinned)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: CampusTheme.coral.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.push_pin,
                          size: 14,
                          color: CampusTheme.coral,
                        ),
                      ),
                    ),
                  // Actions menu
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 18,
                      color: CampusTheme.textMuted.withValues(alpha: 0.7),
                    ),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'profile',
                        child: Row(
                          children: [
                            Icon(Icons.person_outline,
                                size: 16, color: CampusTheme.mint),
                            SizedBox(width: 8),
                            Text('View Student Details'),
                          ],
                        ),
                      ),
                      if (isAdmin || post.authorProfileId == currentProfileId)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline,
                                  size: 16, color: CampusTheme.coral),
                              SizedBox(width: 8),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'report',
                        child: Row(
                          children: [
                            Icon(Icons.flag_outlined,
                                size: 16, color: CampusTheme.coral),
                            SizedBox(width: 8),
                            Text('Report Message'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (v) {
                      if (v == 'profile') {
                        onTapProfile();
                      } else if (v == 'delete') {
                        onDelete();
                      } else if (v == 'report') {
                        CampusSafetyManager.showReportModal(
                          context,
                          currentUserId: currentProfileId ?? 1,
                          targetType: 'post',
                          targetId: post.id ?? 0,
                          targetName: post.title,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Message / Post content
            if (!isChatMessage) ...[
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
            ],
            Text(
              post.content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.95),
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 45) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

String _getInitials(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts[0].isEmpty) return 'S';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}
