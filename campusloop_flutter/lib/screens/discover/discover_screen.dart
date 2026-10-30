import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../models/study_collab_models.dart';
import '../../models/campus_safety_models.dart';
import '../../widgets/common/student_avatar_widget.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';
import 'study_room_screen.dart';

/// Discover screen — Events and Study Partners.
class DiscoverScreen extends StatefulWidget {
  final int initialSubTab;
  const DiscoverScreen({super.key, this.initialSubTab = 0});

  /// 0 = Events, 1 = Study Partners
  static final ValueNotifier<int> requestedSubTab = ValueNotifier<int>(0);
  static int _requestTriggerCount = 0;
  static final ValueNotifier<int> trigger = ValueNotifier<int>(0);

  static void switchToSubTab(int subTab) {
    requestedSubTab.value = subTab.clamp(0, 1);
    trigger.value = ++_requestTriggerCount;
  }

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentSubTab = 0;

  @override
  void initState() {
    super.initState();
    _currentSubTab = widget.initialSubTab.clamp(0, 1);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _currentSubTab,
    );
    _tabController.addListener(_onTabControllerChanged);
    DiscoverScreen.trigger.addListener(_onSubTabTrigger);
  }

  @override
  void didUpdateWidget(DiscoverScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSubTab != oldWidget.initialSubTab) {
      final target = widget.initialSubTab.clamp(0, 1);
      setState(() {
        _currentSubTab = target;
        if (_tabController.index != target) {
          _tabController.index = target;
        }
      });
    }
  }

  void _onTabControllerChanged() {
    if (!_tabController.indexIsChanging && _currentSubTab != _tabController.index) {
      setState(() {
        _currentSubTab = _tabController.index;
      });
      DiscoverScreen.requestedSubTab.value = _tabController.index;
    }
  }

  void _onSubTabTrigger() {
    if (!mounted) return;
    final target = DiscoverScreen.requestedSubTab.value.clamp(0, 1);
    setState(() {
      _currentSubTab = target;
      if (_tabController.index != target) {
        _tabController.index = target;
      }
    });
  }

  @override
  void dispose() {
    DiscoverScreen.trigger.removeListener(_onSubTabTrigger);
    _tabController.removeListener(_onTabControllerChanged);
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
          indicatorColor: CampusTheme.primaryOrange,
          indicatorWeight: 3,
          labelColor: CampusTheme.primaryOrange,
          unselectedLabelColor: CampusTheme.textMuted,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          onTap: (index) {
            setState(() {
              _currentSubTab = index;
            });
          },
          tabs: const [
            Tab(text: 'Events', icon: Icon(Icons.event, size: 20)),
            Tab(text: 'Study Partners', icon: Icon(Icons.handshake, size: 20)),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentSubTab,
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
        offset: 0,
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
    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 80),
        children: [
          // Feature Hero Banner
          CampusFeatureBanner(
            imageAsset: 'assets/images/events_banner.jpg',
            fallbackAsset: 'assets/images/event_tech.jpg',
            tag: 'Hackathons & Grand Fests',
            tagColor: CampusTheme.coral,
            title: 'Campus Events & Workshops',
            subtitle:
                'Join tech sprints, guest seminars, and cultural festivals happening across blocks.',
            actionLabel: 'Host an Event +',
            onAction: _showCreateEventDialog,
          ),

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

          // Events list content
          if (_isLoading)
            const SizedBox(
              height: 260,
              child: CampusLoader(),
            )
          else if (_error != null)
            CampusError(message: _error!, onRetry: _loadEvents)
          else if (_events.isEmpty)
            CampusEmptyState(
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
          else
            ..._events.map(
              (event) => _EventCard(
                event: event,
                onStatusChanged: _loadEvents,
              ),
            ),
        ],
      ),
    );
  }
}

/// ─── Event Card ───
class _EventCard extends StatelessWidget {
  final CampusEvent event;
  final VoidCallback? onStatusChanged;
  const _EventCard({required this.event, this.onStatusChanged});

  @override
  Widget build(BuildContext context) {
    final catColor = CampusTheme.categoryColor(event.category);
    final daysUntil = event.dateTime.difference(DateTime.now()).inDays;
    final isCancelled = event.title.trim().startsWith('[CANCELLED]');
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isCancelled
              ? CampusTheme.coral.withValues(alpha: 0.5)
              : Colors.transparent,
          width: isCancelled ? 1.2 : 0,
        ),
      ),
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
                  color: isCancelled
                      ? CampusTheme.coral.withValues(alpha: 0.12)
                      : catColor.withValues(alpha: 0.12),
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
                        color: isCancelled ? CampusTheme.coral : catColor,
                      ),
                    ),
                    Text(
                      '${event.dateTime.day}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isCancelled ? CampusTheme.coral : catColor,
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
                        if (isCancelled)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: CampusTheme.coral.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: CampusTheme.coral.withValues(alpha: 0.5),
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              '🚫 CANCELLED',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: CampusTheme.coral,
                              ),
                            ),
                          )
                        else if (daysUntil <= 3)
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
                      cleanCampusTitle(event.title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isCancelled ? Colors.white70 : CampusTheme.textLight,
                        decoration: isCancelled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (isCancelled)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '⚠️ Event cancelled by organizer. Do not travel to venue.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: CampusTheme.coral.withValues(alpha: 0.9),
                          ),
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
    final isCancelled = event.title.trim().startsWith('[CANCELLED]');
    final isOrganizer = currentProfileId != null && event.organizerProfileId == currentProfileId;
    String? cancelReason;
    final reasonMatch = RegExp(r'\[EVENT_CANCELLED:\s*([^\]]+)\]').firstMatch(event.description);
    if (reasonMatch != null) {
      cancelReason = reasonMatch.group(1)?.trim();
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
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
            if (isCancelled) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CampusTheme.coral.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: CampusTheme.coral.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.event_busy_rounded,
                            color: CampusTheme.coral, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'EVENT CANCELLED BY ORGANIZER',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: CampusTheme.coral,
                          ),
                        ),
                      ],
                    ),
                    if (cancelReason != null && cancelReason.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Reason: $cancelReason',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(
                      'This event has been called off. Please do not travel to ${event.venue}.',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CampusTheme.textLight,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
              cleanCampusTitle(event.title),
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
            const SizedBox(height: 24),
            if (isOrganizer) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CampusTheme.darkSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.admin_panel_settings_rounded,
                            color: CampusTheme.mint, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Organizer Controls',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCancelled
                          ? 'This event is currently marked as Cancelled. You can reactivate it if plans change.'
                          : 'As the organizer, you can cancel this event and broadcast an alert to prevent students from travelling to the venue.',
                      style: const TextStyle(fontSize: 12, color: CampusTheme.textMuted),
                    ),
                    const SizedBox(height: 12),
                    if (!isCancelled)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cancel_outlined, size: 18),
                          label: const Text('Cancel Event & Broadcast Alert'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CampusTheme.coral,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _confirmCancelEvent(context),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: const Text('Reactivate Event'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CampusTheme.mint,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => _confirmReactivateEvent(context),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
            // Student Report Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: const Icon(Icons.flag_outlined, size: 15, color: CampusTheme.textMuted),
                label: const Text(
                  'Report event to moderation',
                  style: TextStyle(fontSize: 11, color: CampusTheme.textMuted),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  CampusSafetyManager.showReportModal(
                    context,
                    currentUserId: currentProfileId ?? 1,
                    targetType: 'event',
                    targetId: event.id ?? 0,
                    targetName: event.title,
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancelEvent(BuildContext context) async {
    final reasonCtrl = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CampusTheme.darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: CampusTheme.coral.withValues(alpha: 0.4)),
        ),
        title: const Row(
          children: [
            Icon(Icons.event_busy_rounded, color: CampusTheme.coral, size: 24),
            SizedBox(width: 10),
            Text('Cancel Campus Event',
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cancelling this event will broadcast an urgent alert to all students across campus to prevent travelling to the venue.',
              style: TextStyle(fontSize: 12, color: CampusTheme.textLight),
            ),
            const SizedBox(height: 14),
            const Text(
              'Cancellation Reason (Displayed to Students):',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            const SizedBox(height: 6),
            TextField(
              controller: reasonCtrl,
              maxLines: 2,
              style: const TextStyle(fontSize: 13, color: Colors.white),
              decoration: InputDecoration(
                hintText:
                    'e.g. Guest speaker unavailable / Postponed to next week...',
                hintStyle:
                    const TextStyle(fontSize: 12, color: CampusTheme.textMuted),
                fillColor: CampusTheme.darkCard,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Back'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CampusTheme.coral,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm Cancellation'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final reason = reasonCtrl.text.trim().isNotEmpty
          ? reasonCtrl.text.trim()
          : 'Cancelled by the event organizer';
      await CampusEventManager.cancelEvent(
        client: client,
        event: event,
        reason: reason,
        requestingProfileId: currentProfileId!,
      );
      if (!context.mounted) return;
      Navigator.pop(context); // Close bottom sheet
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '✓ Event marked as CANCELLED. Urgent cancellation alert broadcasted.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: CampusTheme.coral,
        ),
      );
      onStatusChanged?.call();
    }
  }

  Future<void> _confirmReactivateEvent(BuildContext context) async {
    await CampusEventManager.reactivateEvent(
      client: client,
      event: event,
      requestingProfileId: currentProfileId!,
    );
    if (!context.mounted) return;
    Navigator.pop(context); // Close bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Event has been reactivated.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: CampusTheme.mint,
      ),
    );
    onStatusChanged?.call();
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
  List<StudentProfile> _allProfiles = [];
  List<StudentProfile> _matches = [];
  List<StudyPartnerRequest> _incoming = [];
  List<StudyPartnerRequest> _outgoing = [];
  List<StudyPartnerRequest> _connections = [];
  StudentProfile? _myProfile;
  bool _isLoading = true;
  String? _error;
  int _selectedTab = 0; // 0=peers/matches, 1=requests, 2=connections

  String? _selectedInterest;
  final _searchCtrl = TextEditingController();

  final List<String> _interestsList = const [
    'All',
    'Coding',
    'Hackathons',
    'AI',
    'Robotics',
    'Web Dev',
    'Data Science',
    'Gaming',
    'Design',
    'Startups',
    'Music',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
    DiscoverScreen.trigger.addListener(_onDiscoverTrigger);
  }

  void _onDiscoverTrigger() {
    if (DiscoverScreen.requestedSubTab.value == 1 && mounted) {
      if (_selectedTab != 0) {
        setState(() => _selectedTab = 0);
      }
    }
  }

  @override
  void dispose() {
    DiscoverScreen.trigger.removeListener(_onDiscoverTrigger);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      _myProfile = await client.profile.getProfile(currentProfileId!);
      _allProfiles = await client.profile.listProfiles(limit: 50, offset: 0);
      _incoming =
          await client.studyPartner.getIncomingRequests(currentProfileId!);
      _outgoing =
          await client.studyPartner.getOutgoingRequests(currentProfileId!);
      _connections =
          await client.studyPartner.getConnections(currentProfileId!);

      final blockedIds = currentProfileId != null
          ? await CampusSafetyManager.getBlockedUserIds(currentProfileId!)
          : <int>{};

      // Exclude blocked students from incoming requests, outgoing requests, and connections
      _incoming = _incoming
          .where((r) => !blockedIds.contains(r.fromProfileId))
          .toList();
      _outgoing = _outgoing
          .where((r) => !blockedIds.contains(r.toProfileId))
          .toList();
      _connections = _connections
          .where((c) =>
              !blockedIds.contains(c.fromProfileId) &&
              !blockedIds.contains(c.toProfileId))
          .toList();

      // Rank peers by shared interests & subjects, excluding blocked users and corrupted/test names
      final others = _allProfiles
          .where((p) =>
              p.id != null &&
              p.id != currentProfileId &&
              !blockedIds.contains(p.id) &&
              !p.displayName.toLowerCase().contains('serverpod') &&
              !p.displayName.toLowerCase().contains('statuscode') &&
              !p.displayName.toLowerCase().contains('internal server error') &&
              !p.displayName.toLowerCase().contains('exception'))
          .toList();

      others.sort((a, b) {
        final aSharedInterests = a.interests
            .where((i) => _myProfile?.interests.contains(i) ?? false)
            .length;
        final bSharedInterests = b.interests
            .where((i) => _myProfile?.interests.contains(i) ?? false)
            .length;
        final aSharedSubjects = a.studySubjects
            .where((s) => _myProfile?.studySubjects.contains(s) ?? false)
            .length;
        final bSharedSubjects = b.studySubjects
            .where((s) => _myProfile?.studySubjects.contains(s) ?? false)
            .length;

        final aScore = (aSharedInterests * 4) + (aSharedSubjects * 2);
        final bScore = (bSharedInterests * 4) + (bSharedSubjects * 2);
        return bScore.compareTo(aScore);
      });

      _matches = others;
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
    // If there is already an incoming request from this person, accept it immediately!
    StudyPartnerRequest? existingIncoming;
    for (final r in _incoming) {
      if (r.fromProfileId == toProfileId) {
        existingIncoming = r;
        break;
      }
    }

    if (existingIncoming != null) {
      await _acceptRequest(existingIncoming.id!);
      return;
    }

    try {
      await client.studyPartner.sendRequest(
        currentProfileId!,
        toProfileId,
        'Hi, let\'s connect on CampusLoop!',
      );
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Connection request sent!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.primaryOrange,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      final msg = e.toString().toLowerCase();
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        if (msg.contains('already connected')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Already connected with this peer!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: CampusTheme.mint,
              duration: Duration(seconds: 3),
            ),
          );
        } else if (msg.contains('pending request already exists')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⏳ Request already pending between you two!'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: CampusTheme.amberOrange,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<void> _acceptRequest(int requestId) async {
    try {
      await client.studyPartner.acceptRequest(requestId, currentProfileId!);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Connection accepted! You are now study partners.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.mint,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _rejectRequest(int requestId) async {
    try {
      await client.studyPartner.rejectRequest(requestId, currentProfileId!);
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request declined'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.coral,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
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
              _subTab('Find Peers', 0, _matches.length),
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
            color: CampusTheme.primaryOrange,
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
                ? CampusTheme.primaryOrange.withValues(alpha: 0.15)
                : CampusTheme.darkCardLight,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? CampusTheme.primaryOrange
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
                      ? CampusTheme.primaryOrange
                      : CampusTheme.textMuted,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? CampusTheme.primaryOrange
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
    // Filter peers by search query and interest
    final q = _searchCtrl.text.trim().toLowerCase();
    final filtered = _matches.where((p) {
      if (_selectedInterest != null && _selectedInterest != 'All') {
        final hasInterest = p.interests.any(
            (i) => i.toLowerCase() == _selectedInterest!.toLowerCase());
        if (!hasInterest) return false;
      }
      if (q.isNotEmpty) {
        final matchesName = p.displayName.toLowerCase().contains(q);
        final matchesDept = (p.department ?? '').toLowerCase().contains(q);
        final matchesInterest =
            p.interests.any((i) => i.toLowerCase().contains(q));
        final matchesSubject =
            p.studySubjects.any((s) => s.toLowerCase().contains(q));
        return matchesName || matchesDept || matchesInterest || matchesSubject;
      }
      return true;
    }).toList();

    return ListView(
      padding: const EdgeInsets.only(bottom: 80),
      children: [
        // Feature Hero Banner
        CampusFeatureBanner(
          imageAsset: 'assets/images/partners_banner.jpg',
          fallbackAsset: 'assets/images/campus_hero.jpg',
          tag: 'Peer Radar Active',
          tagColor: CampusTheme.mint,
          title: 'Find Your Study Partner',
          subtitle:
              'Match with classmates sharing your subjects, coding interests, and project goals.',
          actionLabel: 'Manage Requests',
          onAction: () => setState(() => _selectedTab = 1),
        ),

        // Search bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: TextField(
            controller: _searchCtrl,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Search peers by interest, subject, or name...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _searchCtrl.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() {});
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Interest filter chips
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _interestsList.length,
            itemBuilder: (ctx, i) {
              final interest = _interestsList[i];
              final isSelected = (_selectedInterest == null && interest == 'All') ||
                  _selectedInterest == interest;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  selectedColor: CampusTheme.primaryOrange,
                  checkmarkColor: Colors.white,
                  backgroundColor: CampusTheme.darkCardLight,
                  labelStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : CampusTheme.textMuted,
                  ),
                  onSelected: (_) {
                    setState(() {
                      _selectedInterest = interest == 'All' ? null : interest;
                    });
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),

        if (filtered.isEmpty)
          const CampusEmptyState(
            icon: Icons.person_search_rounded,
            title: 'No peers found',
            subtitle:
                'Try selecting another interest or invite classmates to join!',
          )
        else
          ...filtered.map((partner) {
            final isConnected = _connections.any((c) =>
                (c.fromProfileId == partner.id &&
                    c.toProfileId == currentProfileId) ||
                (c.toProfileId == partner.id &&
                    c.fromProfileId == currentProfileId));
            final isPending = _outgoing
                .any((c) => c.toProfileId == partner.id);
            StudyPartnerRequest? incomingReq;
            for (final r in _incoming) {
              if (r.fromProfileId == partner.id) {
                incomingReq = r;
                break;
              }
            }

            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StudentAvatarWidget(
                      displayName: partner.displayName,
                      avatarUrl:
                          StudentSocials.fromBio(partner.bio).avatar,
                      radius: 24,
                    ),
                    const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          partner.displayName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      if (partner.email.endsWith('.edu') ||
                                          partner.email.endsWith('.ac.in') ||
                                          partner.email.endsWith('.edu.in')) ...[
                                        const SizedBox(width: 4),
                                        const Tooltip(
                                          message: 'Verified Campus Member',
                                          child: Icon(Icons.verified_rounded,
                                              size: 14, color: CampusTheme.mint),
                                        ),
                                      ],
                                    ],
                                  ),
                                  if (partner.department != null)
                                    Text(
                                      '${partner.department} · Year ${partner.year ?? 1}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CampusTheme.textMuted,
                                      ),
                                    ),
                                  if (incomingReq != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 3, bottom: 2),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: CampusTheme.mint
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: Border.all(
                                            color: CampusTheme.mint
                                                .withValues(alpha: 0.3),
                                            width: 0.8,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.mail_rounded,
                                                size: 11,
                                                color: CampusTheme.mint),
                                            SizedBox(width: 4),
                                            Text(
                                              'Sent you a request',
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color: CampusTheme.mint,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 6),
                                  // Interests
                                  if (partner.interests.isNotEmpty)
                                    Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      children: partner.interests.map((interest) {
                                        final isShared = _myProfile?.interests
                                                .contains(interest) ??
                                            false;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isShared
                                                ? CampusTheme.primaryOrange
                                                    .withValues(alpha: 0.18)
                                                : CampusTheme.darkCardLight,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: isShared
                                                ? Border.all(
                                                    color: CampusTheme
                                                        .primaryOrange
                                                        .withValues(alpha: 0.35))
                                                : null,
                                          ),
                                          child: Text(
                                            isShared ? '🔥 $interest' : interest,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: isShared
                                                  ? CampusTheme.primaryOrange
                                                  : CampusTheme.textMuted,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (isConnected)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: CampusTheme.mint
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle_rounded,
                                        size: 14, color: CampusTheme.mint),
                                    SizedBox(width: 4),
                                    Text('Connected',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: CampusTheme.mint)),
                                  ],
                                ),
                              )
                            else if (incomingReq != null)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Decline (Cross)
                                  InkWell(
                                    onTap: () => _rejectRequest(incomingReq!.id!),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: CampusTheme.coral
                                            .withValues(alpha: 0.16),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: CampusTheme.coral
                                              .withValues(alpha: 0.4),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                        size: 18,
                                        color: CampusTheme.coral,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  // Accept (Tick)
                                  InkWell(
                                    onTap: () => _acceptRequest(incomingReq!.id!),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: CampusTheme.mint,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: CampusTheme.mint
                                                .withValues(alpha: 0.35),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.check_rounded,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Accept',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else if (isPending)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: CampusTheme.amberOrange
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Pending ⏳',
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: CampusTheme.amberOrange)),
                              )
                            else
                              ElevatedButton(
                                onPressed: () => _sendRequest(partner.id!),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CampusTheme.primaryOrange,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Connect',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert,
                                  size: 18, color: CampusTheme.textMuted),
                              padding: EdgeInsets.zero,
                              color: CampusTheme.darkSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.white12),
                              ),
                              onSelected: (val) {
                                if (val == 'report') {
                                  CampusSafetyManager.showReportModal(
                                    context,
                                    currentUserId: currentProfileId!,
                                    targetType: 'student',
                                    targetId: partner.id!,
                                    targetName: partner.displayName,
                                    onReported: _loadData,
                                  );
                                } else if (val == 'block') {
                                  CampusSafetyManager.confirmAndBlockUser(
                                    context,
                                    currentUserId: currentProfileId!,
                                    targetUserId: partner.id!,
                                    targetName: partner.displayName,
                                    onBlocked: _loadData,
                                  );
                                }
                              },
                              itemBuilder: (ctx) => [
                                const PopupMenuItem(
                                  value: 'report',
                                  child: Row(
                                    children: [
                                      Icon(Icons.flag_outlined,
                                          size: 16, color: CampusTheme.coral),
                                      SizedBox(width: 8),
                                      Text('Report Student',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'block',
                                  child: Row(
                                    children: [
                                      Icon(Icons.block_rounded,
                                          size: 16, color: CampusTheme.coral),
                                      SizedBox(width: 8),
                                      Text('Block Student',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: CampusTheme.coral)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
      ],
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
      padding: const EdgeInsets.only(bottom: 24),
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
            final partnerSocials = StudentSocials.fromBio(profile?.bio);

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              color: CampusTheme.darkCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: CampusTheme.mint.withValues(alpha: 0.35),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor:
                              CampusTheme.mint.withValues(alpha: 0.2),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'S',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: CampusTheme.mint,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              if (profile?.department != null)
                                Text(
                                  '${profile!.department} · Year ${profile.year ?? 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: CampusTheme.textMuted,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: CampusTheme.mint.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  size: 13, color: CampusTheme.mint),
                              SizedBox(width: 4),
                              Text(
                                'Connected',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: CampusTheme.mint,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (conn.matchingSubjects.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        'Shared Subjects: ${conn.matchingSubjects.join(', ')}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: CampusTheme.primaryOrange,
                        ),
                      ),
                    ],
                    // Unlocked direct contacts bar
                    if (partnerSocials.hasAny) ...[
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (partnerSocials.discord != null &&
                              partnerSocials.discord!.isNotEmpty)
                            _contactChip(
                              context,
                              Icons.chat_bubble_outline_rounded,
                              'Discord',
                              partnerSocials.discord!,
                            ),
                          if (partnerSocials.linkedin != null &&
                              partnerSocials.linkedin!.isNotEmpty)
                            _contactChip(
                              context,
                              Icons.business_center_rounded,
                              'LinkedIn',
                              partnerSocials.linkedin!,
                            ),
                          if (partnerSocials.whatsapp != null &&
                              partnerSocials.whatsapp!.isNotEmpty)
                            _contactChip(
                              context,
                              Icons.phone_iphone_rounded,
                              'WhatsApp',
                              partnerSocials.whatsapp!,
                            ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),
                    // Action button: Launch Virtual Study Room
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: profile == null
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StudyRoomScreen(
                                      partner: profile,
                                      currentProfile: _myProfile,
                                      initialSubject:
                                          conn.matchingSubjects.isNotEmpty
                                              ? conn.matchingSubjects.first
                                              : null,
                                    ),
                                  ),
                                );
                              },
                        icon: const Icon(Icons.timer_outlined, size: 18),
                        label: const Text('⏱️ Launch Virtual Study Room'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CampusTheme.primaryOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _contactChip(
      BuildContext context, IconData icon, String label, String value) {
    return InkWell(
      onTap: () {
        Clipboard.setData(ClipboardData(text: value));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('📋 $label copied: $value'),
            backgroundColor: CampusTheme.mint,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: CampusTheme.darkCardLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CampusTheme.mint.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: CampusTheme.mint),
            const SizedBox(width: 6),
            Text(
              '$label: $value',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.copy_rounded, size: 12, color: CampusTheme.mint),
          ],
        ),
      ),
    );
  }
}
