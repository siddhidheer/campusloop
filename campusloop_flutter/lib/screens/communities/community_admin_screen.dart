import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';

/// Screen for platform administrators to manage community creation access,
/// search registered students by verified email, view audit logs,
/// and manage spam moderation rules and incident logs.
class CommunityAdminScreen extends StatefulWidget {
  final VoidCallback? onPermissionsChanged;

  const CommunityAdminScreen({super.key, this.onPermissionsChanged});

  @override
  State<CommunityAdminScreen> createState() => _CommunityAdminScreenState();
}

class _CommunityAdminScreenState extends State<CommunityAdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Search state
  final _searchEmailController = TextEditingController();
  StudentProfile? _searchedUser;
  bool _isSearching = false;
  String? _searchError;

  // Authorized users state
  List<StudentProfile> _authorizedUsers = [];
  bool _isLoadingAuthorized = false;

  // Audit logs state
  List<PermissionAuditLog> _auditLogs = [];
  bool _isLoadingAuditLogs = false;

  // Spam moderation rules state
  List<SpamKeywordRule> _spamRules = [];
  List<ModerationLog> _moderationLogs = [];
  bool _isLoadingModeration = false;
  final _newRuleController = TextEditingController();
  String _newRuleCategory = 'commercial_promotion';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) _loadAuthorizedUsers();
        if (_tabController.index == 1) _loadAuditLogs();
        if (_tabController.index == 2) _loadModerationData();
      }
    });

    _loadAuthorizedUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchEmailController.dispose();
    _newRuleController.dispose();
    super.dispose();
  }

  Future<void> _loadAuthorizedUsers() async {
    if (currentProfileId == null) return;
    setState(() => _isLoadingAuthorized = true);
    try {
      final list = await client.communityAdmin.listAuthorizedUsers(
        currentProfileId!,
      );
      if (mounted) {
        setState(() {
          _authorizedUsers = list;
          _isLoadingAuthorized = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAuthorized = false);
      }
    }
  }

  Future<void> _loadAuditLogs() async {
    if (currentProfileId == null) return;
    setState(() => _isLoadingAuditLogs = true);
    try {
      final logs = await client.communityAdmin.getAuditLogs(
        currentProfileId!,
        limit: 50,
      );
      if (mounted) {
        setState(() {
          _auditLogs = logs;
          _isLoadingAuditLogs = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingAuditLogs = false);
      }
    }
  }

  Future<void> _loadModerationData() async {
    if (currentProfileId == null) return;
    setState(() => _isLoadingModeration = true);
    try {
      final rules = await client.communityAdmin.getSpamRules(
        currentProfileId!,
      );
      final logs = await client.communityAdmin.getModerationLogs(
        currentProfileId!,
        limit: 50,
        offset: 0,
      );
      if (mounted) {
        setState(() {
          _spamRules = rules;
          _moderationLogs = logs;
          _isLoadingModeration = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingModeration = false);
      }
    }
  }

  Future<void> _searchUser() async {
    final query = _searchEmailController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _searchError = null;
      _searchedUser = null;
    });

    try {
      final user = await client.communityAdmin.searchUserByEmail(
        currentProfileId!,
        query,
      );

      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchedUser = user;
          if (user == null) {
            _searchError = 'No registered student found with email "$query".';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
          _searchError = e.toString().replaceAll('Exception: ', '');
        });
      }
    }
  }

  Future<void> _grantPermission(String email) async {
    try {
      final success = await client.communityAdmin.grantPermission(
        currentProfileId!,
        email,
        reason: 'Authorized via Administrator Portal',
      );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Community creation permission granted to $email'),
            backgroundColor: CampusTheme.mint,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _searchUser();
        _loadAuthorizedUsers();
        widget.onPermissionsChanged?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: CampusTheme.coral,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _revokePermission(String email) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: CampusTheme.darkCard,
        title: const Text('Revoke Community Creation?'),
        content: Text(
          'Are you sure you want to revoke community creation access from $email? They will no longer be able to create new communities.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: CampusTheme.coral),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Revoke'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final success = await client.communityAdmin.revokePermission(
        currentProfileId!,
        email,
        reason: 'Revoked via Administrator Portal',
      );
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Community creation permission revoked from $email'),
            backgroundColor: CampusTheme.mint,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _searchUser();
        _loadAuthorizedUsers();
        widget.onPermissionsChanged?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: CampusTheme.coral,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _addSpamRule() async {
    final pattern = _newRuleController.text.trim().toLowerCase();
    if (pattern.isEmpty) return;

    try {
      await client.communityAdmin.addSpamRule(
        currentProfileId!,
        pattern,
        _newRuleCategory,
      );
      _newRuleController.clear();
      _loadModerationData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✓ Added spam filter pattern: "$pattern"'),
            backgroundColor: CampusTheme.mint,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: CampusTheme.coral,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _toggleSpamRule(int ruleId, bool isEnabled) async {
    try {
      await client.communityAdmin.toggleSpamRule(
        currentProfileId!,
        ruleId,
        isEnabled,
      );
      _loadModerationData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CampusTheme.darkSurface,
      appBar: AppBar(
        title: const Text('Admin Access & Moderation'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: CampusTheme.primaryOrange,
          tabs: const [
            Tab(icon: Icon(Icons.security_rounded), text: 'Delegation'),
            Tab(icon: Icon(Icons.history_rounded), text: 'Audit Trail'),
            Tab(icon: Icon(Icons.filter_alt_rounded), text: 'Spam Filters'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDelegationTab(),
          _buildAuditLogsTab(),
          _buildModerationTab(),
        ],
      ),
    );
  }

  Widget _buildDelegationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CampusTheme.deepTeal.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: CampusTheme.deepTeal.withValues(alpha: 0.3),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.shield_outlined, color: CampusTheme.mint, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'As a platform administrator, you can search registered Gmail users and grant or revoke community creation privileges with immediate effect.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Search Card
          Text(
            'Search Registered Student by Email',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchEmailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter student @gmail.com...',
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: CampusTheme.textMuted),
                    filled: true,
                    fillColor: CampusTheme.darkCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _searchUser(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isSearching ? null : _searchUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: CampusTheme.primaryOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSearching
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ],
          ),

          if (_searchError != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CampusTheme.coral.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: CampusTheme.coral, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _searchError!,
                      style: const TextStyle(
                        color: CampusTheme.coral,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (_searchedUser != null) ...[
            const SizedBox(height: 16),
            _buildSearchedUserCard(_searchedUser!),
          ],

          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Authorized Community Creators',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: CampusTheme.textMuted),
                onPressed: _loadAuthorizedUsers,
                tooltip: 'Refresh list',
              ),
            ],
          ),
          const SizedBox(height: 10),

          if (_isLoadingAuthorized)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_authorizedUsers.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: CampusTheme.darkCard,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(
                child: Text(
                  'No authorized creators found.',
                  style: TextStyle(color: CampusTheme.textMuted),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _authorizedUsers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (ctx, idx) {
                final user = _authorizedUsers[idx];
                final isAdmin = user.role == 'admin';
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: CampusTheme.darkCard,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isAdmin
                          ? CampusTheme.mint.withValues(alpha: 0.3)
                          : Colors.white10,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: isAdmin
                            ? CampusTheme.mint.withValues(alpha: 0.2)
                            : CampusTheme.primaryOrange.withValues(alpha: 0.2),
                        child: Icon(
                          isAdmin
                              ? Icons.admin_panel_settings_rounded
                              : Icons.person_rounded,
                          color: isAdmin
                              ? CampusTheme.mint
                              : CampusTheme.primaryOrange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.displayName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              user.email,
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
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAdmin
                              ? CampusTheme.mint.withValues(alpha: 0.15)
                              : CampusTheme.primaryOrange
                                  .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          isAdmin ? 'Platform Admin' : 'Authorized Creator',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isAdmin
                                ? CampusTheme.mint
                                : CampusTheme.primaryOrange,
                          ),
                        ),
                      ),
                      if (!isAdmin) ...[
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: CampusTheme.coral, size: 20),
                          tooltip: 'Revoke Permission',
                          onPressed: () => _revokePermission(user.email),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSearchedUserCard(StudentProfile user) {
    final hasPermission =
        user.canCreateCommunity == true || user.role == 'admin';
    final isAdmin = user.role == 'admin';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CampusTheme.darkCardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasPermission ? CampusTheme.mint : Colors.white24,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: CampusTheme.deepTeal,
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CampusTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: hasPermission
                      ? CampusTheme.mint.withValues(alpha: 0.2)
                      : Colors.white12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  hasPermission ? 'Can Create' : 'Standard Member',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: hasPermission ? CampusTheme.mint : Colors.white70,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Department: ${user.department ?? 'General Studies'} • Year ${user.year ?? 1}',
            style: const TextStyle(fontSize: 12, color: CampusTheme.textMuted),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!hasPermission)
                ElevatedButton.icon(
                  onPressed: () => _grantPermission(user.email),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CampusTheme.mint,
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.check_circle_rounded, size: 18),
                  label: const Text('Grant Creation Access'),
                )
              else if (!isAdmin)
                ElevatedButton.icon(
                  onPressed: () => _revokePermission(user.email),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CampusTheme.coral,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.cancel_rounded, size: 18),
                  label: const Text('Revoke Creation Access'),
                )
              else
                const Text(
                  'Initial Administrator (Permanent Access)',
                  style: TextStyle(fontSize: 12, color: CampusTheme.mint),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAuditLogsTab() {
    if (_isLoadingAuditLogs) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_auditLogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history_toggle_off_rounded,
                size: 48, color: CampusTheme.textMuted),
            const SizedBox(height: 12),
            const Text(
              'No audit records logged yet.',
              style: TextStyle(color: CampusTheme.textMuted),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadAuditLogs,
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _auditLogs.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, idx) {
        final log = _auditLogs[idx];
        final isGrant = log.action == 'GRANT';
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: CampusTheme.darkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isGrant
                  ? CampusTheme.mint.withValues(alpha: 0.3)
                  : CampusTheme.coral.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isGrant
                          ? CampusTheme.mint.withValues(alpha: 0.2)
                          : CampusTheme.coral.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      log.action,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isGrant ? CampusTheme.mint : CampusTheme.coral,
                      ),
                    ),
                  ),
                  Text(
                    log.timestamp.toLocal().toString().substring(0, 16),
                    style: const TextStyle(
                      fontSize: 11,
                      color: CampusTheme.textMuted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Target: ${log.targetEmail}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Text(
                'By Administrator: ${log.adminEmail}',
                style: const TextStyle(
                  fontSize: 12,
                  color: CampusTheme.textMuted,
                ),
              ),
              if (log.reason != null && log.reason!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Reason: ${log.reason}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildModerationTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add rule card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CampusTheme.darkCard,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Spam Keyword / Pattern Rule',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _newRuleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'e.g., promo code, cheap essay, bit.ly/',
                    filled: true,
                    fillColor: CampusTheme.darkCardLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _newRuleCategory,
                        dropdownColor: CampusTheme.darkCard,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: CampusTheme.darkCardLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'commercial_promotion',
                            child: Text('Commercial Promotion',
                                style: TextStyle(color: Colors.white)),
                          ),
                          DropdownMenuItem(
                            value: 'referral_affiliate',
                            child: Text('Referral / Affiliate',
                                style: TextStyle(color: Colors.white)),
                          ),
                          DropdownMenuItem(
                            value: 'unsolicited_links',
                            child: Text('Suspicious Link Redirect',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _newRuleCategory = v);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _addSpamRule,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CampusTheme.primaryOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                      child: const Text('Add Rule'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Active rules
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Active Moderation Filter Rules (${_spamRules.length})',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded,
                    color: CampusTheme.textMuted),
                onPressed: _loadModerationData,
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (_isLoadingModeration)
            const Center(child: CircularProgressIndicator())
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _spamRules.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (ctx, idx) {
                final rule = _spamRules[idx];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: CampusTheme.darkCard,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rule.pattern,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: rule.isEnabled
                                    ? Colors.white
                                    : CampusTheme.textMuted,
                              ),
                            ),
                            Text(
                              rule.category,
                              style: const TextStyle(
                                fontSize: 11,
                                color: CampusTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: rule.isEnabled,
                        activeColor: CampusTheme.mint,
                        onChanged: (v) => _toggleSpamRule(rule.id!, v),
                      ),
                    ],
                  ),
                );
              },
            ),

          const SizedBox(height: 24),
          const Text(
            'Recent Moderation Incident Logs',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          if (_moderationLogs.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CampusTheme.darkCard,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'No spam messages blocked yet. Discussions are clean!',
                  style: TextStyle(color: CampusTheme.textMuted, fontSize: 13),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _moderationLogs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, idx) {
                final m = _moderationLogs[idx];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CampusTheme.coral.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CampusTheme.coral.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'BLOCKED SPAM ATTEMPT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: CampusTheme.coral,
                            ),
                          ),
                          Text(
                            m.timestamp.toLocal().toString().substring(0, 16),
                            style: const TextStyle(
                              fontSize: 10,
                              color: CampusTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sender: ${m.authorEmail}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      Text(
                        'Reason: ${m.reason}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Snippet: "${m.contentSnippet}"',
                        style: const TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: CampusTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
