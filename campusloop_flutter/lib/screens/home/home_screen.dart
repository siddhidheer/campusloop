import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';

/// Home dashboard — personalized CampusLoop landing page.
///
/// Shows welcome section, upcoming events, suggested study partners,
/// communities, and latest announcements.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StudentProfile? _profile;
  List<CampusEvent> _upcomingEvents = [];
  List<StudentProfile> _suggestedPartners = [];
  List<Community> _communities = [];
  List<CampusUpdate> _latestUpdates = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load all dashboard data in parallel
      final profileFuture = currentProfileId != null
          ? client.profile.getProfile(currentProfileId!)
          : Future.value(null);
      final eventsFuture = client.event.listEvents(limit: 5);
      final communitiesFuture = client.community.listCommunities(limit: 4);
      final updatesFuture = client.campusUpdate.listUpdates(limit: 3);

      final results = await Future.wait([
        profileFuture,
        eventsFuture,
        communitiesFuture,
        updatesFuture,
      ]);

      _profile = results[0] as StudentProfile?;
      _upcomingEvents = results[1] as List<CampusEvent>;
      _communities = results[2] as List<Community>;
      _latestUpdates = results[3] as List<CampusUpdate>;

      // Load study partners if profile exists
      if (_profile != null && _profile!.studySubjects.isNotEmpty) {
        _suggestedPartners = await client.profile.findStudyPartners(
          currentProfileId!,
        );
        if (_suggestedPartners.length > 4) {
          _suggestedPartners = _suggestedPartners.sublist(0, 4);
        }
      }

      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [CampusTheme.deepTeal, CampusTheme.darkTeal],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.loop_rounded, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 10),
            const Text('CampusLoop'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const CampusLoader(message: 'Loading your dashboard...')
          : _error != null
              ? CampusError(message: _error!, onRetry: _loadDashboard)
              : RefreshIndicator(
                  onRefresh: _loadDashboard,
                  color: CampusTheme.deepTeal,
                  child: ListView(
                    children: [
                      _buildWelcomeSection(),
                      _buildQuickActions(),
                      _buildUpcomingEvents(),
                      _buildStudyPartners(),
                      _buildCommunities(),
                      _buildLatestUpdates(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
    );
  }

  Widget _buildWelcomeSection() {
    final name = _profile?.displayName ?? 'Student';
    final firstName = name.split(' ').first;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [CampusTheme.deepTeal, CampusTheme.darkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CampusTheme.deepTeal.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$greeting, $firstName 👋',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your Campus. Your Community. One Loop.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatChip(
                  Icons.event, '${_upcomingEvents.length}', 'Events'),
              const SizedBox(width: 12),
              _buildStatChip(
                  Icons.people, '${_suggestedPartners.length}', 'Matches'),
              const SizedBox(width: 12),
              _buildStatChip(
                  Icons.groups, '${_communities.length}', 'Groups'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String count, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            '$count $label',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildQuickAction(
            Icons.event_available,
            'Events',
            CampusTheme.coral,
            () {
              // Navigate to Discover tab
              final shell = context.findAncestorStateOfType<State>();
              if (shell != null) {
                // Switch to discover tab
              }
            },
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            Icons.handshake,
            'Partners',
            CampusTheme.softBlue,
            () {},
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            Icons.groups_2,
            'Communities',
            CampusTheme.mint,
            () {},
          ),
          const SizedBox(width: 12),
          _buildQuickAction(
            Icons.campaign,
            'Updates',
            CampusTheme.lavender,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: color),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingEvents() {
    return Column(
      children: [
        SectionHeader(
          title: 'Upcoming Events',
          actionLabel: 'See all',
          onAction: () {},
        ),
        if (_upcomingEvents.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CampusEmptyState(
              icon: Icons.event_outlined,
              title: 'No upcoming events',
              subtitle: 'Check back later for campus events',
            ),
          )
        else
          SizedBox(
            height: 165,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _upcomingEvents.length,
              itemBuilder: (ctx, i) => _buildEventCard(_upcomingEvents[i]),
            ),
          ),
      ],
    );
  }

  Widget _buildEventCard(CampusEvent event) {
    final catColor = CampusTheme.categoryColor(event.category);
    final daysUntil = event.dateTime.difference(DateTime.now()).inDays;

    return Container(
      width: 260,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: catColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      event.category,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: catColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    daysUntil == 0
                        ? 'Today'
                        : daysUntil == 1
                            ? 'Tomorrow'
                            : 'In $daysUntil days',
                    style: TextStyle(
                      fontSize: 11,
                      color: daysUntil <= 3
                          ? CampusTheme.coral
                          : CampusTheme.textMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                event.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: CampusTheme.textLight,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 14, color: CampusTheme.textMuted),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.venue,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CampusTheme.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStudyPartners() {
    return Column(
      children: [
        SectionHeader(
          title: 'Study Partners',
          actionLabel: 'Find more',
          onAction: () {},
        ),
        if (_suggestedPartners.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CampusEmptyState(
              icon: Icons.handshake_outlined,
              title: 'No matches yet',
              subtitle: 'Add study subjects to your profile to find partners',
            ),
          )
        else
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _suggestedPartners.length,
              itemBuilder: (ctx, i) =>
                  _buildPartnerCard(_suggestedPartners[i]),
            ),
          ),
      ],
    );
  }

  Widget _buildPartnerCard(StudentProfile partner) {
    final matchCount = _profile?.studySubjects
            .where((s) => partner.studySubjects.contains(s))
            .length ??
        0;

    return Container(
      width: 150,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: CampusTheme.softBlue.withValues(alpha: 0.2),
                child: Text(
                  partner.displayName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.softBlue,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                partner.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CampusTheme.textLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$matchCount shared ${matchCount == 1 ? 'subject' : 'subjects'}',
                style: const TextStyle(
                  fontSize: 11,
                  color: CampusTheme.mint,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommunities() {
    return Column(
      children: [
        SectionHeader(
          title: 'Communities',
          actionLabel: 'Browse all',
          onAction: () {},
        ),
        if (_communities.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CampusEmptyState(
              icon: Icons.groups_outlined,
              title: 'No communities yet',
              subtitle: 'Be the first to create one!',
            ),
          )
        else
          ..._communities.map((c) => _buildCommunityTile(c)),
      ],
    );
  }

  Widget _buildCommunityTile(Community community) {
    final catColor = CampusTheme.categoryColor(community.category);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.groups_2, color: catColor, size: 22),
        ),
        title: Text(
          community.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '${community.memberCount} members · ${community.category}',
          style: const TextStyle(fontSize: 12, color: CampusTheme.textMuted),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: CampusTheme.textMuted,
        ),
      ),
    );
  }

  Widget _buildLatestUpdates() {
    return Column(
      children: [
        SectionHeader(
          title: 'Latest Updates',
          actionLabel: 'View all',
          onAction: () {},
        ),
        if (_latestUpdates.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: CampusEmptyState(
              icon: Icons.campaign_outlined,
              title: 'No updates yet',
              subtitle: 'Campus announcements will appear here',
            ),
          )
        else
          ..._latestUpdates.map((u) => _buildUpdateTile(u)),
      ],
    );
  }

  Widget _buildUpdateTile(CampusUpdate update) {
    final priorityColor = CampusTheme.priorityColor(update.priority);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          update.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            update.category,
            style: TextStyle(
              fontSize: 12,
              color: CampusTheme.categoryColor(update.category),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: CampusTheme.textMuted,
        ),
      ),
    );
  }
}
