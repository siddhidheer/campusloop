import 'package:flutter/material.dart';
import '../../models/campus_notification.dart';
import '../../theme/campus_theme.dart';
import '../common/campus_widgets.dart';

class NotificationsSheet extends StatefulWidget {
  final List<CampusNotification> notifications;
  final VoidCallback onMarkAllRead;
  final Function(CampusNotification) onNotificationTap;
  final Function(CampusNotification) onAcceptRequest;
  final Function(CampusNotification) onDeclineRequest;

  const NotificationsSheet({
    super.key,
    required this.notifications,
    required this.onMarkAllRead,
    required this.onNotificationTap,
    required this.onAcceptRequest,
    required this.onDeclineRequest,
  });

  @override
  State<NotificationsSheet> createState() => _NotificationsSheetState();
}

class _NotificationsSheetState extends State<NotificationsSheet> {
  String _selectedFilter = 'All';

  String _formatTimeAgo(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}';
  }

  List<CampusNotification> get _filteredNotifications {
    if (_selectedFilter == 'Requests') {
      return widget.notifications
          .where((n) => n.category == NotificationCategory.connectionRequest)
          .toList();
    } else if (_selectedFilter == 'Updates') {
      return widget.notifications
          .where((n) => n.category == NotificationCategory.campusUpdate)
          .toList();
    } else if (_selectedFilter == 'Clubs') {
      return widget.notifications
          .where((n) => n.category == NotificationCategory.clubActivity)
          .toList();
    } else if (_selectedFilter == 'Events') {
      return widget.notifications
          .where((n) => n.category == NotificationCategory.event)
          .toList();
    }
    return widget.notifications;
  }

  int _countForCategory(NotificationCategory cat) {
    return widget.notifications.where((n) => n.category == cat).length;
  }

  @override
  Widget build(BuildContext context) {
    final unreadCount = widget.notifications.where((n) => !n.isRead).length;
    final filtered = _filteredNotifications;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: CampusTheme.darkSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 10, bottom: 8),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 12, 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: CampusTheme.primaryOrange.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: CampusTheme.primaryOrange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: CampusTheme.coral,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$unreadCount new',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                if (unreadCount > 0)
                  TextButton.icon(
                    onPressed: () {
                      widget.onMarkAllRead();
                      setState(() {});
                    },
                    icon: const Icon(Icons.done_all_rounded, size: 16),
                    label: const Text(
                      'Mark read',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: CampusTheme.primaryOrange,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20, color: CampusTheme.textMuted),
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close',
                ),
              ],
            ),
          ),

          // Category Filter Chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildFilterChip('All', widget.notifications.length),
                _buildFilterChip('Requests', _countForCategory(NotificationCategory.connectionRequest)),
                _buildFilterChip('Updates', _countForCategory(NotificationCategory.campusUpdate)),
                _buildFilterChip('Clubs', _countForCategory(NotificationCategory.clubActivity)),
                _buildFilterChip('Events', _countForCategory(NotificationCategory.event)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          const Divider(height: 1, thickness: 0.5, color: Colors.white12),

          // Notifications List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: CampusEmptyState(
                      icon: Icons.notifications_none_rounded,
                      title: 'No notifications',
                      subtitle: _selectedFilter == 'All'
                          ? 'You are all caught up with campus events, updates, and requests!'
                          : 'No notifications found under $_selectedFilter.',
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: filtered.length,
                    itemBuilder: (ctx, i) {
                      final item = filtered[i];
                      return _buildNotificationCard(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int count) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text('$label ($count)'),
        selected: isSelected,
        selectedColor: CampusTheme.primaryOrange,
        backgroundColor: CampusTheme.darkCard,
        labelStyle: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? Colors.white : CampusTheme.textMuted,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: isSelected
                ? CampusTheme.primaryOrange
                : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        onSelected: (val) {
          if (val) setState(() => _selectedFilter = label);
        },
      ),
    );
  }

  Widget _buildNotificationCard(CampusNotification item) {
    Color themeColor;
    IconData icon;
    String tagLabel;

    switch (item.category) {
      case NotificationCategory.connectionRequest:
        themeColor = CampusTheme.softBlue;
        icon = Icons.person_add_alt_1_rounded;
        tagLabel = 'CONNECTION REQUEST';
        break;
      case NotificationCategory.campusUpdate:
        themeColor = CampusTheme.lavender;
        icon = Icons.campaign_rounded;
        tagLabel = 'CAMPUS UPDATE';
        break;
      case NotificationCategory.clubActivity:
        themeColor = CampusTheme.mint;
        icon = Icons.groups_rounded;
        tagLabel = 'CLUB ACTIVITY';
        break;
      case NotificationCategory.event:
        themeColor = CampusTheme.primaryOrange;
        icon = Icons.event_available_rounded;
        tagLabel = 'EVENT';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: item.isRead ? CampusTheme.darkCard : CampusTheme.darkCardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isRead
              ? Colors.white.withValues(alpha: 0.08)
              : themeColor.withValues(alpha: 0.4),
          width: item.isRead ? 0.8 : 1.2,
        ),
        boxShadow: item.isRead
            ? []
            : [
                BoxShadow(
                  color: themeColor.withValues(alpha: 0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            widget.onNotificationTap(item);
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category icon circle
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: themeColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: themeColor, size: 20),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag + Time + Unread dot
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: themeColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              tagLabel,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: themeColor,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _formatTimeAgo(item.timestamp),
                            style: const TextStyle(
                              fontSize: 11,
                              color: CampusTheme.textMuted,
                            ),
                          ),
                          if (!item.isRead) ...[
                            const SizedBox(width: 6),
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: themeColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Title
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),

                      // Message
                      Text(
                        item.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CampusTheme.textLight,
                          height: 1.35,
                        ),
                      ),

                      // Connection Request Action Buttons
                      if (item.category == NotificationCategory.connectionRequest &&
                          item.requestPayload != null) ...[
                        const SizedBox(height: 10),
                        if (item.requestStatus == 'pending')
                          Row(
                            children: [
                              OutlinedButton.icon(
                                icon: const Icon(Icons.close_rounded, size: 14),
                                label: const Text('Decline', style: TextStyle(fontSize: 11)),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: CampusTheme.coral,
                                  side: BorderSide(color: CampusTheme.coral.withValues(alpha: 0.5)),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  widget.onDeclineRequest(item);
                                  setState(() {
                                    item.requestStatus = 'rejected';
                                    item.isRead = true;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                icon: const Icon(Icons.check_rounded, size: 14),
                                label: const Text('Accept', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CampusTheme.mint,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () {
                                  widget.onAcceptRequest(item);
                                  setState(() {
                                    item.requestStatus = 'accepted';
                                    item.isRead = true;
                                  });
                                },
                              ),
                            ],
                          )
                        else if (item.requestStatus == 'accepted')
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: CampusTheme.mint.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, size: 13, color: CampusTheme.mint),
                                SizedBox(width: 4),
                                Text(
                                  'Connected',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: CampusTheme.mint,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else if (item.requestStatus == 'rejected')
                          const Text(
                            'Request declined',
                            style: TextStyle(fontSize: 11, color: CampusTheme.textMuted),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
