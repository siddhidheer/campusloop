import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';

/// Campus Updates screen — announcements and opportunities.
class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  List<CampusUpdate> _updates = [];
  List<String> _categories = [];
  String? _selectedCategory;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUpdates();
  }

  Future<void> _loadUpdates() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final updates = await client.campusUpdate.listUpdates(
        category: _selectedCategory,
        limit: 50,
        offset: 0,
      );
      final categories = await client.campusUpdate.getCategories();
      if (mounted) {
        setState(() {
          _updates = updates;
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

  void _showCreateUpdateDialog() {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    String category = 'Academic';
    String priority = 'normal';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Publish Update'),
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
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    'Academic',
                    'Facility',
                    'Opportunity',
                    'Notice',
                    'Event',
                    'General',
                  ]
                      .map((c) =>
                          DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) =>
                      setDialogState(() => category = v ?? category),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: priority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: ['high', 'normal', 'low']
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p[0].toUpperCase() + p.substring(1)),
                          ))
                      .toList(),
                  onChanged: (v) =>
                      setDialogState(() => priority = v ?? priority),
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
                  await client.campusUpdate.createUpdate(
                    CampusUpdate(
                      title: titleCtrl.text,
                      content: contentCtrl.text,
                      category: category,
                      authorProfileId: currentProfileId!,
                      priority: priority,
                      isPublished: true,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                  Navigator.pop(ctx);
                  _loadUpdates();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Update published!')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDetail(CampusUpdate update) {
    final catColor = CampusTheme.categoryColor(update.category);
    final priorityColor = CampusTheme.priorityColor(update.priority);

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
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    update.category,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: catColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (update.priority == 'high')
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(Icons.priority_high,
                              size: 14, color: priorityColor),
                        ),
                      Text(
                        update.priority[0].toUpperCase() +
                            update.priority.substring(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: priorityColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              cleanCampusTitle(update.title),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: CampusTheme.textLight,
              ),
            ),
            const SizedBox(height: 12),
            if (update.publishedAt != null)
              Text(
                'Published ${_formatDate(update.publishedAt!)}',
                style: const TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textMuted,
                ),
              ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              update.content,
              style: const TextStyle(
                fontSize: 15,
                color: CampusTheme.textLight,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 32),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Updates'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateUpdateDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Category filter
          if (_categories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CategoryFilterChips(
                categories: _categories,
                selected: _selectedCategory,
                onSelected: (cat) {
                  setState(() => _selectedCategory = cat);
                  _loadUpdates();
                },
              ),
            ),

          const SizedBox(height: 8),

          Expanded(
            child: _isLoading
                ? const CampusLoader()
                : _error != null
                    ? CampusError(
                        message: _error!, onRetry: _loadUpdates)
                    : _updates.isEmpty
                        ? CampusEmptyState(
                            icon: Icons.campaign_outlined,
                            title: 'No updates yet',
                            subtitle: _selectedCategory != null
                                ? 'No updates in this category'
                                : 'Campus announcements will appear here',
                          )
                        : RefreshIndicator(
                            onRefresh: _loadUpdates,
                            child: ListView.builder(
                              padding: const EdgeInsets.only(bottom: 80),
                              itemCount: _updates.length,
                              itemBuilder: (ctx, i) =>
                                  _UpdateCard(
                                    update: _updates[i],
                                    onTap: () =>
                                        _showUpdateDetail(_updates[i]),
                                  ),
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}

class _UpdateCard extends StatelessWidget {
  final CampusUpdate update;
  final VoidCallback onTap;

  const _UpdateCard({required this.update, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final catColor = CampusTheme.categoryColor(update.category);
    final priorityColor = CampusTheme.priorityColor(update.priority);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Priority indicator
              Container(
                width: 4,
                height: 50,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
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
                            update.category,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: catColor,
                            ),
                          ),
                        ),
                        if (update.priority == 'high') ...[
                          const SizedBox(width: 6),
                          Icon(Icons.priority_high,
                              size: 14, color: CampusTheme.coral),
                        ],
                        const Spacer(),
                        if (update.publishedAt != null)
                          Text(
                            _formatDate(update.publishedAt!),
                            style: TextStyle(
                              fontSize: 11,
                              color: CampusTheme.textMuted
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cleanCampusTitle(update.title),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: CampusTheme.textLight,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      update.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CampusTheme.textMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: CampusTheme.textMuted, size: 20),
            ],
          ),
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
