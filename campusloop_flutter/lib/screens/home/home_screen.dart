import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';
import '../app_shell.dart';

/// Home dashboard — vibrant, personalized CampusLoop landing page.
///
/// Features the orange infinity brand logo, cohesive dark hello card matching the whole app,
/// interactive quick action tiles, and rich peer discovery by shared interests.
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
      final eventsFuture = client.event.listEvents(limit: 5, offset: 0);
      final communitiesFuture =
          client.community.listCommunities(limit: 4, offset: 0);
      final updatesFuture =
          client.campusUpdate.listUpdates(limit: 3, offset: 0);

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

      // Load peers matching shared interests, subjects, or department
      try {
        final allProfiles =
            await client.profile.listProfiles(limit: 30, offset: 0);
        final otherProfiles = allProfiles
            .where((p) => p.id != null && p.id != currentProfileId)
            .toList();

        otherProfiles.sort((a, b) {
          final aSharedInterests = a.interests
              .where((i) => _profile?.interests.contains(i) ?? false)
              .length;
          final bSharedInterests = b.interests
              .where((i) => _profile?.interests.contains(i) ?? false)
              .length;

          final aSharedSubjects = a.studySubjects
              .where((s) => _profile?.studySubjects.contains(s) ?? false)
              .length;
          final bSharedSubjects = b.studySubjects
              .where((s) => _profile?.studySubjects.contains(s) ?? false)
              .length;

          final aSameDept =
              (a.department != null && a.department == _profile?.department)
                  ? 1
                  : 0;
          final bSameDept =
              (b.department != null && b.department == _profile?.department)
                  ? 1
                  : 0;

          final aScore =
              (aSharedInterests * 4) + (aSharedSubjects * 2) + aSameDept;
          final bScore =
              (bSharedInterests * 4) + (bSharedSubjects * 2) + bSameDept;

          return bScore.compareTo(aScore);
        });

        _suggestedPartners = otherProfiles.take(6).toList();
      } catch (_) {
        _suggestedPartners = [];
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

  Future<void> _sendStudyRequest(StudentProfile partner) async {
    if (currentProfileId == null || partner.id == null) return;
    try {
      await client.studyPartner.sendRequest(
        currentProfileId!,
        partner.id!,
        'Hi ${partner.displayName}, let\'s connect on CampusLoop!',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 Connection request sent to ${partner.displayName}!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.primaryOrange,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const OrangeInfinityLogo(size: 34),
            const SizedBox(width: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(text: 'Campus'),
                  TextSpan(
                    text: 'Loop',
                    style: TextStyle(color: CampusTheme.primaryOrange),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🔔 You are all caught up! No new notifications.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const CampusLoader(message: 'Loading your campus...')
          : _error != null
              ? CampusError(message: _error!, onRetry: _loadDashboard)
              : RefreshIndicator(
                  onRefresh: _loadDashboard,
                  color: CampusTheme.primaryOrange,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _buildWelcomeSection(),
                      _buildQuickActions(),
                      _buildUpcomingEvents(),
                      _buildStudyPartners(),
                      _buildCommunities(),
                      _buildLatestUpdates(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
    );
  }

  // ── Cohesive Welcome Card Matching the Rest of the App ──
  Widget _buildWelcomeSection() {
    final name = _profile?.displayName ?? 'Student';
    final firstName = name.split(' ').first;
    final dept = _profile?.department;
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CampusTheme.darkCard,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: CampusTheme.primaryOrange.withValues(alpha: 0.35),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: CampusTheme.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, $firstName 👋',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    if (dept != null && dept.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: CampusTheme.primaryOrange.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: CampusTheme.primaryOrange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          dept,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: CampusTheme.primaryOrange,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: CampusTheme.primaryOrange.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: CampusTheme.primaryOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: const Icon(
                  Icons.all_inclusive_rounded,
                  color: CampusTheme.primaryOrange,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Your Campus. Your Community. One Loop.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: CampusTheme.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          // Responsive stat chips that match the dark card aesthetic
          Row(
            children: [
              Expanded(
                child: _buildStatChip(
                  Icons.event_available_rounded,
                  '${_upcomingEvents.length}',
                  'Events',
                  () => AppShell.switchTab(context, 1, subTab: 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  Icons.people_alt_rounded,
                  '${_suggestedPartners.length}',
                  'Matches',
                  () => AppShell.switchTab(context, 1, subTab: 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildStatChip(
                  Icons.groups_rounded,
                  '${_communities.length}',
                  'Clubs',
                  () => AppShell.switchTab(context, 2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(
      IconData icon, String count, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 9),
        decoration: BoxDecoration(
          color: CampusTheme.darkCardLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CampusTheme.divider.withValues(alpha: 0.4),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: CampusTheme.primaryOrange),
              const SizedBox(width: 5),
              Text(
                '$count $label',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          _buildQuickAction(
            Icons.event_available_rounded,
            'Events',
            CampusTheme.coral,
            () => AppShell.switchTab(context, 1, subTab: 0),
          ),
          const SizedBox(width: 10),
          _buildQuickAction(
            Icons.handshake_rounded,
            'Partners',
            CampusTheme.softBlue,
            () => AppShell.switchTab(context, 1, subTab: 1),
          ),
          const SizedBox(width: 10),
          _buildQuickAction(
            Icons.groups_2_rounded,
            'Clubs',
            CampusTheme.mint,
            () => AppShell.switchTab(context, 2),
          ),
          const SizedBox(width: 10),
          _buildQuickAction(
            Icons.campaign_rounded,
            'Updates',
            CampusTheme.lavender,
            () => AppShell.switchTab(context, 3),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.28)),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(height: 6),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
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
          actionLabel: 'See all →',
          onAction: () => AppShell.switchTab(context, 1, subTab: 0),
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
            height: 185,
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
    final cleanTitle = cleanCampusTitle(event.title);

    return Container(
      width: 270,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showEventModal(context, event),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: catColor.withValues(alpha: 0.35)),
                      ),
                      child: Text(
                        event.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: catColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        daysUntil == 0
                            ? 'Today'
                            : daysUntil == 1
                                ? 'Tomorrow'
                                : 'In $daysUntil days',
                        style: TextStyle(
                          fontSize: 11,
                          color: daysUntil <= 3
                              ? CampusTheme.primaryOrange
                              : CampusTheme.textMuted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  cleanTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.textLight,
                    height: 1.25,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 14, color: CampusTheme.primaryOrange),
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
                    const Icon(Icons.arrow_forward_ios_rounded,
                        size: 12, color: CampusTheme.textMuted),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Connect by Interests & Study Partners ──
  Widget _buildStudyPartners() {
    return Column(
      children: [
        SectionHeader(
          title: 'Connect by Interests & Peers',
          actionLabel: 'Find more →',
          onAction: () => AppShell.switchTab(context, 1, subTab: 1),
        ),
        if (_suggestedPartners.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CampusEmptyState(
              icon: Icons.people_outline_rounded,
              title: 'No other students online',
              subtitle: 'Invite your classmates to CampusLoop to connect!',
              actionLabel: 'Explore Events',
              onAction: () => AppShell.switchTab(context, 1, subTab: 0),
            ),
          )
        else
          SizedBox(
            height: 168,
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
    final sharedInterests = partner.interests
        .where((i) => _profile?.interests.contains(i) ?? false)
        .toList();
    final sharedSubjects = partner.studySubjects
        .where((s) => _profile?.studySubjects.contains(s) ?? false)
        .toList();

    String matchLabel;
    if (sharedInterests.isNotEmpty) {
      matchLabel = '🔥 ${sharedInterests.first}';
    } else if (sharedSubjects.isNotEmpty) {
      matchLabel = '📚 ${sharedSubjects.first}';
    } else if (partner.interests.isNotEmpty) {
      matchLabel = '✨ ${partner.interests.first}';
    } else {
      matchLabel = partner.department ?? 'Campus Peer';
    }

    return Container(
      width: 165,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Card(
        child: InkWell(
          onTap: () => _showPartnerModal(context, partner),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: CampusTheme.primaryOrange.withValues(alpha: 0.2),
                  child: Text(
                    partner.displayName.isNotEmpty
                        ? partner.displayName[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: CampusTheme.primaryOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  partner.displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CampusTheme.primaryOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    matchLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      color: CampusTheme.primaryOrange,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => _sendStudyRequest(partner),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: CampusTheme.primaryOrange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Connect',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommunities() {
    return Column(
      children: [
        SectionHeader(
          title: 'Campus Clubs & Hubs',
          actionLabel: 'Browse all →',
          onAction: () => AppShell.switchTab(context, 2),
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
    final cleanName = cleanCampusTitle(community.name);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        onTap: () => _showCommunityModal(context, community),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: catColor.withValues(alpha: 0.3)),
          ),
          child: Icon(Icons.groups_2_rounded, color: catColor, size: 22),
        ),
        title: Text(
          cleanName,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '${community.memberCount} members · ${community.category}',
          style: const TextStyle(fontSize: 12, color: CampusTheme.textMuted),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: CampusTheme.primaryOrange,
            size: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLatestUpdates() {
    return Column(
      children: [
        SectionHeader(
          title: 'Latest Announcements',
          actionLabel: 'View all →',
          onAction: () => AppShell.switchTab(context, 3),
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
    final cleanTitle = cleanCampusTitle(update.title);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        onTap: () => _showUpdateModal(context, update),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 5,
          height: 42,
          decoration: BoxDecoration(
            color: priorityColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        title: Text(
          cleanTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
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
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: CampusTheme.primaryOrange,
            size: 14,
          ),
        ),
      ),
    );
  }

  // ── Bottom Sheet Modals for Interactivity ──

  void _showEventModal(BuildContext context, CampusEvent event) {
    final cleanTitle = cleanCampusTitle(event.title);
    final catColor = CampusTheme.categoryColor(event.category);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                event.category,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: catColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              cleanTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.location_on_rounded,
                    size: 18, color: CampusTheme.primaryOrange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.venue,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CampusTheme.textMuted,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time_filled_rounded,
                    size: 18, color: CampusTheme.softBlue),
                const SizedBox(width: 8),
                Text(
                  '${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year} · ${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: CampusTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🎉 RSVP Confirmed for $cleanTitle!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: CampusTheme.primaryOrange,
                    ),
                  );
                },
                icon: const Icon(Icons.check_circle_rounded),
                label: const Text('RSVP / Register Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPartnerModal(BuildContext context, StudentProfile partner) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: CampusTheme.primaryOrange.withValues(alpha: 0.2),
              child: Text(
                partner.displayName.isNotEmpty
                    ? partner.displayName[0].toUpperCase()
                    : 'S',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: CampusTheme.primaryOrange,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              partner.displayName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            if (partner.department != null) ...[
              const SizedBox(height: 4),
              Text(
                '${partner.department} · Year ${partner.year ?? 1}',
                style: const TextStyle(
                  fontSize: 14,
                  color: CampusTheme.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              partner.bio ?? 'CampusLoop student looking to connect with peers.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            if (partner.interests.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Interests',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: partner.interests
                    .map((i) => Chip(
                          label: Text(i),
                          backgroundColor:
                              CampusTheme.primaryOrange.withValues(alpha: 0.15),
                          labelStyle: const TextStyle(
                              color: CampusTheme.primaryOrange,
                              fontWeight: FontWeight.w600),
                        ))
                    .toList(),
              ),
            ],
            if (partner.studySubjects.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Study Subjects',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: partner.studySubjects
                    .map((s) => Chip(
                          label: Text(s),
                          backgroundColor: CampusTheme.darkCardLight,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _sendStudyRequest(partner);
                },
                icon: const Icon(Icons.person_add_rounded),
                label: Text('Connect with ${partner.displayName}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCommunityModal(BuildContext context, Community community) {
    final cleanName = cleanCampusTitle(community.name);
    final catColor = CampusTheme.categoryColor(community.category);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(Icons.groups_2_rounded, color: catColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cleanName,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${community.memberCount} members · ${community.category}',
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
            Text(
              community.description,
              style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🎉 You joined $cleanName!'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: CampusTheme.primaryOrange,
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_rounded),
                label: const Text('Join Community'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateModal(BuildContext context, CampusUpdate update) {
    final cleanTitle = cleanCampusTitle(update.title);
    final priorityColor = CampusTheme.priorityColor(update.priority);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${update.priority.toUpperCase()} PRIORITY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: priorityColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  update.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: CampusTheme.categoryColor(update.category),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              cleanTitle,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              update.content,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Dismiss'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
