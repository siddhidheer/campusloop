import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';

/// Discover screen — Events and Study Partners.
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: CampusTheme.deepTeal,
          indicatorWeight: 3,
          labelColor: CampusTheme.deepTeal,
          unselectedLabelColor: CampusTheme.textMuted,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          tabs: const [
            Tab(text: 'Events', icon: Icon(Icons.event, size: 20)),
            Tab(text: 'Study Partners', icon: Icon(Icons.handshake, size: 20)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _EventsTab(),
          _StudyPartnersTab(),
        ],
      ),
    );
  }
}

/// ─── Events Tab ───
class _EventsTab extends StatefulWidget {
  const _EventsTab();

  @override
  State<_EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<_EventsTab> {
  List<CampusEvent> _events = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = true;
  String? _error;
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final events = await client.event.listEvents(
        category: _selectedCategory,
        limit: 50,
      );
      final categories = await client.event.getCategories();
      if (mounted) {
        setState(() {
          _events = events;
          _categories = categories;
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

  Future<void> _searchEvents(String query) async {
    if (query.isEmpty) {
      _loadEvents();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final results = await client.event.searchEvents(query);
      if (mounted) {
        setState(() {
          _events = results;
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

  void _showCreateEventDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final venueCtrl = TextEditingController();
    String category = 'Technology';
    DateTime eventDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Create Event'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(labelText: 'Event Title'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: venueCtrl,
                  decoration: const InputDecoration(labelText: 'Venue'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    'Technology',
                    'Workshop',
                    'Cultural',
                    'Career',
                    'Sports',
                    'Social',
                  ]
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setDialogState(() => category = v ?? category),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Event Date', style: TextStyle(fontSize: 14)),
                  subtitle: Text(
                    '${eventDate.day}/${eventDate.month}/${eventDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: eventDate,
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() => eventDate = picked);
                    }
                  },
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
                if (titleCtrl.text.isEmpty || descCtrl.text.isEmpty) {
                  return;
                }
                try {
                  await client.event.createEvent(
                    CampusEvent(
                      title: titleCtrl.text,
                      description: descCtrl.text,
                      category: category,
                      venue: venueCtrl.text,
                      organizer: '',
                      organizerProfileId: currentProfileId!,
                      dateTime: eventDate,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                  Navigator.pop(ctx);
                  _loadEvents();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event created!')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search events...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _isSearching = false);
                        _loadEvents();
                      },
                    )
                  : null,
            ),
            onChanged: (q) {
              setState(() => _isSearching = q.isNotEmpty);
              _searchEvents(q);
            },
          ),
        ),

        // Category filters
        if (!_isSearching && _categories.isNotEmpty)
          CategoryFilterChips(
            categories: _categories,
            selected: _selectedCategory,
            onSelected: (cat) {
              setState(() => _selectedCategory = cat);
              _loadEvents();
            },
          ),

        const SizedBox(height: 8),

        // Events list
        Expanded(
          child: _isLoading
              ? const CampusLoader()
              : _error != null
                  ? CampusError(message: _error!, onRetry: _loadEvents)
                  : _events.isEmpty
                      ? CampusEmptyState(
                          icon: Icons.event_outlined,
                          title: _isSearching
                              ? 'No results found'
                              : 'No upcoming events',
                          subtitle: _isSearching
                              ? 'Try a different search term'
                              : 'Create the first event!',
                          actionLabel: 'Create Event',
                          onAction: _showCreateEventDialog,
                        )
                      : RefreshIndicator(
                          onRefresh: _loadEvents,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: _events.length,
                            itemBuilder: (ctx, i) =>
                                _EventCard(event: _events[i]),
                          ),
                        ),
        ),
      ],
    );
  }
}

/// ─── Event Card ───
class _EventCard extends StatelessWidget {
  final CampusEvent event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final catColor = CampusTheme.categoryColor(event.category);
    final daysUntil = event.dateTime.difference(DateTime.now()).inDays;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showEventDetail(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Date badge
              Container(
                width: 56,
                height: 64,
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      months[event.dateTime.month - 1],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: catColor,
                      ),
                    ),
                    Text(
                      '${event.dateTime.day}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: catColor,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: catColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            event.category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: catColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (daysUntil <= 3)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: CampusTheme.coral.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              daysUntil == 0
                                  ? 'Today!'
                                  : daysUntil == 1
                                      ? 'Tomorrow'
                                      : 'In $daysUntil days',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: CampusTheme.coral,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: CampusTheme.textMuted),
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
                        const SizedBox(width: 8),
                        const Icon(Icons.person_outline,
                            size: 13, color: CampusTheme.textMuted),
                        const SizedBox(width: 4),
                        Text(
                          event.organizer,
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
            ],
          ),
        ),
      ),
    );
  }

  void _showEventDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (ctx, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: CampusTheme.textMuted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CampusTheme.categoryColor(event.category)
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                event.category,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: CampusTheme.categoryColor(event.category),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: CampusTheme.textLight,
              ),
            ),
            const SizedBox(height: 20),
            _detailRow(Icons.calendar_today,
                '${event.dateTime.day}/${event.dateTime.month}/${event.dateTime.year}'),
            _detailRow(Icons.access_time,
                '${event.dateTime.hour}:${event.dateTime.minute.toString().padLeft(2, '0')}'),
            _detailRow(Icons.location_on, event.venue),
            _detailRow(Icons.person, 'Organized by ${event.organizer}'),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'About this event',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CampusTheme.textLight,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: const TextStyle(
                fontSize: 14,
                color: CampusTheme.textMuted,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: CampusTheme.deepTeal),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: CampusTheme.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─── Study Partners Tab ───
class _StudyPartnersTab extends StatefulWidget {
  const _StudyPartnersTab();

  @override
  State<_StudyPartnersTab> createState() => _StudyPartnersTabState();
}

class _StudyPartnersTabState extends State<_StudyPartnersTab> {
  List<StudentProfile> _matches = [];
  List<StudyPartnerRequest> _incoming = [];
  List<StudyPartnerRequest> _outgoing = [];
  List<StudyPartnerRequest> _connections = [];
  StudentProfile? _myProfile;
  bool _isLoading = true;
  String? _error;
  int _selectedTab = 0; // 0=matches, 1=requests, 2=connections

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _myProfile = await client.profile.getProfile(currentProfileId!);
      _matches = await client.profile.findStudyPartners(currentProfileId!);
      _incoming =
          await client.studyPartner.getIncomingRequests(currentProfileId!);
      _outgoing =
          await client.studyPartner.getOutgoingRequests(currentProfileId!);
      _connections =
          await client.studyPartner.getConnections(currentProfileId!);
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

  Future<void> _sendRequest(int toProfileId) async {
    try {
      await client.studyPartner.sendRequest(
        currentProfileId!,
        toProfileId,
        null,
      );
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request sent!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  Future<void> _acceptRequest(int requestId) async {
    try {
      await client.studyPartner.acceptRequest(requestId, currentProfileId!);
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Connection accepted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  Future<void> _rejectRequest(int requestId) async {
    try {
      await client.studyPartner.rejectRequest(requestId, currentProfileId!);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const CampusLoader();
    if (_error != null) {
      return CampusError(message: _error!, onRetry: _loadData);
    }

    return Column(
      children: [
        // Sub-tabs
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: [
              _subTab('Matches', 0, _matches.length),
              const SizedBox(width: 8),
              _subTab('Requests', 1, _incoming.length + _outgoing.length),
              const SizedBox(width: 8),
              _subTab('Connected', 2, _connections.length),
            ],
          ),
        ),

        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadData,
            child: _selectedTab == 0
                ? _buildMatches()
                : _selectedTab == 1
                    ? _buildRequests()
                    : _buildConnections(),
          ),
        ),
      ],
    );
  }

  Widget _subTab(String label, int index, int count) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? CampusTheme.deepTeal.withValues(alpha: 0.15)
                : CampusTheme.darkCardLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? CampusTheme.deepTeal
                  : CampusTheme.divider.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? CampusTheme.deepTeal
                      : CampusTheme.textMuted,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected
                      ? CampusTheme.deepTeal
                      : CampusTheme.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatches() {
    if (_matches.isEmpty) {
      return const CampusEmptyState(
        icon: Icons.search_off,
        title: 'No matches found',
        subtitle:
            'Add more study subjects to your profile to find study partners',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _matches.length,
      itemBuilder: (ctx, i) {
        final partner = _matches[i];
        final matchingSubjects = partner.studySubjects
            .where((s) => _myProfile?.studySubjects.contains(s) ?? false)
            .toList();

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                      CampusTheme.softBlue.withValues(alpha: 0.2),
                  child: Text(
                    partner.displayName[0].toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: CampusTheme.softBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        partner.displayName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (partner.department != null)
                        Text(
                          partner.department!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: CampusTheme.textMuted,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: matchingSubjects
                            .map((s) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: CampusTheme.mint
                                        .withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    s,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: CampusTheme.mint,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _sendRequest(partner.id!),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                  ),
                  child: const Text('Connect', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequests() {
    if (_incoming.isEmpty && _outgoing.isEmpty) {
      return const CampusEmptyState(
        icon: Icons.mail_outline,
        title: 'No pending requests',
        subtitle: 'Send connection requests to study partners',
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        if (_incoming.isNotEmpty) ...[
          const SectionHeader(title: 'Incoming Requests'),
          ..._incoming.map((r) => _requestTile(r, isIncoming: true)),
        ],
        if (_outgoing.isNotEmpty) ...[
          const SectionHeader(title: 'Sent Requests'),
          ..._outgoing.map((r) => _requestTile(r, isIncoming: false)),
        ],
      ],
    );
  }

  Widget _requestTile(StudyPartnerRequest request,
      {required bool isIncoming}) {
    return FutureBuilder<StudentProfile?>(
      future: client.profile.getProfile(
        isIncoming ? request.fromProfileId : request.toProfileId,
      ),
      builder: (ctx, snap) {
        final profile = snap.data;
        final name = profile?.displayName ?? 'Student';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: CampusTheme.lavender.withValues(alpha: 0.2),
              child: Text(
                name[0],
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: CampusTheme.lavender,
                ),
              ),
            ),
            title: Text(name,
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: request.matchingSubjects.isNotEmpty
                ? Text(
                    'Matching: ${request.matchingSubjects.join(', ')}',
                    style: const TextStyle(
                        fontSize: 12, color: CampusTheme.mint),
                  )
                : null,
            trailing: isIncoming
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle,
                            color: CampusTheme.mint),
                        onPressed: () => _acceptRequest(request.id!),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel,
                            color: CampusTheme.coral),
                        onPressed: () => _rejectRequest(request.id!),
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: CampusTheme.softBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Pending',
                      style: TextStyle(
                        fontSize: 12,
                        color: CampusTheme.softBlue,
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildConnections() {
    if (_connections.isEmpty) {
      return const CampusEmptyState(
        icon: Icons.people_outline,
        title: 'No connections yet',
        subtitle: 'Accept requests or find study partners',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: _connections.length,
      itemBuilder: (ctx, i) {
        final conn = _connections[i];
        final partnerId = conn.fromProfileId == currentProfileId
            ? conn.toProfileId
            : conn.fromProfileId;

        return FutureBuilder<StudentProfile?>(
          future: client.profile.getProfile(partnerId),
          builder: (ctx, snap) {
            final profile = snap.data;
            final name = profile?.displayName ?? 'Student';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                      CampusTheme.mint.withValues(alpha: 0.2),
                  child: Text(
                    name[0],
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: CampusTheme.mint,
                    ),
                  ),
                ),
                title: Text(name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: conn.matchingSubjects.isNotEmpty
                    ? Text(
                        conn.matchingSubjects.join(', '),
                        style: const TextStyle(
                          fontSize: 12,
                          color: CampusTheme.textMuted,
                        ),
                      )
                    : null,
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: CampusTheme.mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Connected',
                    style: TextStyle(
                      fontSize: 12,
                      color: CampusTheme.mint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
