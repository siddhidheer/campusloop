import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:campusloop_client/campusloop_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';
import '../auth/login_screen.dart';
import '../../models/study_collab_models.dart';
import '../../models/campus_safety_models.dart';

/// Student Profile screen — view and edit profile information.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  StudentProfile? _profile;
  List<Community> _joinedCommunities = [];
  List<StudyPartnerRequest> _connections = [];
  String _university = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final profile = await client.profile.getProfile(currentProfileId!);
      final communities =
          await client.community.getJoinedCommunities(currentProfileId!);
      final connections =
          await client.studyPartner.getConnections(currentProfileId!);

      // Load saved university / college
      String univ = '';
      try {
        final prefs = await SharedPreferences.getInstance();
        if (profile?.email != null) {
          univ = prefs.getString('university_${profile!.email}') ?? '';
        }
        if (univ.isEmpty) {
          univ = prefs.getString('current_university') ??
              prefs.getString('saved_login_university') ??
              '';
        }
      } catch (_) {}

      if (mounted) {
        setState(() {
          _profile = profile;
          _joinedCommunities = communities;
          _connections = connections;
          _university = univ;
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

  void _showEditProfileDialog() {
    if (_profile == null) return;

    final existingSocials = StudentSocials.fromBio(_profile!.bio);
    final cleanBio = StudentSocials.cleanBio(_profile!.bio);

    final nameCtrl = TextEditingController(text: _profile!.displayName);
    final univCtrl = TextEditingController(text: _university);
    final deptCtrl = TextEditingController(text: _profile!.department ?? '');
    final bioCtrl = TextEditingController(text: cleanBio);
    final subjectsCtrl = TextEditingController(
        text: _profile!.studySubjects.join(', '));
    final interestsCtrl = TextEditingController(
        text: _profile!.interests.join(', '));
    final discordCtrl =
        TextEditingController(text: existingSocials.discord ?? '');
    final linkedinCtrl =
        TextEditingController(text: existingSocials.linkedin ?? '');
    final whatsappCtrl =
        TextEditingController(text: existingSocials.whatsapp ?? '');
    int? year = _profile!.year;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Display Name'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: univCtrl,
                  decoration: const InputDecoration(
                    labelText: 'University / College Name',
                    prefixIcon: Icon(Icons.account_balance_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deptCtrl,
                  decoration: const InputDecoration(labelText: 'Department'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: year,
                  decoration: const InputDecoration(labelText: 'Year'),
                  items: [1, 2, 3, 4, 5]
                      .map((y) => DropdownMenuItem(
                            value: y,
                            child: Text('Year $y'),
                          ))
                      .toList(),
                  onChanged: (v) => setDialogState(() => year = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: bioCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Bio / Study Goals',
                    hintText: 'Tell peers about your exam prep or study habits',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subjectsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Study Subjects',
                    hintText: 'Comma-separated (e.g. DSA, OS, DBMS)',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: interestsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Interests',
                    hintText: 'Comma-separated (e.g. AI, Web Dev)',
                  ),
                ),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.lock_rounded, size: 16, color: CampusTheme.mint),
                    SizedBox(width: 6),
                    Text(
                      'Partner Contact Channels',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: CampusTheme.mint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Only revealed to your accepted study partners for coordination.',
                  style: TextStyle(fontSize: 11, color: CampusTheme.textMuted),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: discordCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Discord ID / Tag',
                    hintText: 'e.g. siddhi#1234 or @siddhi',
                    prefixIcon: Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: linkedinCtrl,
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn Profile URL / Handle',
                    hintText: 'e.g. linkedin.com/in/siddhi',
                    prefixIcon: Icon(Icons.business_center_rounded, size: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: whatsappCtrl,
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp / Phone (Optional)',
                    hintText: 'e.g. +91 9876543210',
                    prefixIcon: Icon(Icons.phone_iphone_rounded, size: 18),
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
                try {
                  final newUniv = univCtrl.text.trim();
                  final updatedSocials = StudentSocials(
                    discord: discordCtrl.text.trim().isNotEmpty
                        ? discordCtrl.text.trim()
                        : null,
                    linkedin: linkedinCtrl.text.trim().isNotEmpty
                        ? linkedinCtrl.text.trim()
                        : null,
                    whatsapp: whatsappCtrl.text.trim().isNotEmpty
                        ? whatsappCtrl.text.trim()
                        : null,
                  );

                  final rawBio = StudentSocials.embedInBio(
                    bioCtrl.text.trim(),
                    updatedSocials,
                  );

                  _profile!
                    ..displayName = nameCtrl.text.trim()
                    ..department = deptCtrl.text.trim().isNotEmpty
                        ? deptCtrl.text.trim()
                        : null
                    ..year = year
                    ..bio = rawBio.isNotEmpty ? rawBio : null
                    ..studySubjects = subjectsCtrl.text
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList()
                    ..interests = interestsCtrl.text
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList();

                  await client.profile.updateProfile(_profile!);

                  // Persist updated university and local socials
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    if (_profile?.email != null) {
                      await prefs.setString(
                          'university_${_profile!.email}', newUniv);
                      await StudentSocials.saveLocalSocials(
                          _profile!.email, updatedSocials);
                    }
                    await prefs.setString('current_university', newUniv);
                  } catch (_) {}

                  Navigator.pop(ctx);
                  _loadProfile();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated!')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout() async {
    currentProfileId = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('saved_session_token');
      await prefs.remove('saved_profile_id');
      await prefs.remove('saved_login_pwd');
      await prefs.remove('current_user_email');
      await prefs.remove('current_user_role');
      await prefs.remove('current_user_can_create_community');
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  /// Displays warning confirmation dialog before permanently deleting account
  Future<void> _confirmDeleteAccount() async {
    if (_profile == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: CampusTheme.coral.withValues(alpha: 0.35),
          ),
        ),
        backgroundColor: CampusTheme.darkSurface,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: CampusTheme.coral.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_forever_rounded,
                color: CampusTheme.coral,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Delete Account?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This action is irreversible. All your data will be permanently deleted:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: CampusTheme.coral,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 12),
            _bulletItem('Login credentials and remembered passwords'),
            _bulletItem('Student profile, bio, and university details'),
            _bulletItem('All study partner connections & requests'),
            _bulletItem('Community memberships and authored posts'),
            _bulletItem('Campus event registrations and updates'),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white10),
              ),
              child: Text(
                'Account: ${_profile!.email}',
                style: const TextStyle(
                  fontSize: 12,
                  color: CampusTheme.textMuted,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: CampusTheme.textMuted),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CampusTheme.coral,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Permanently Delete',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await _executeDeleteAccount();
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ',
              style: TextStyle(color: CampusTheme.coral, fontSize: 14)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, color: CampusTheme.textLight),
            ),
          ),
        ],
      ),
    );
  }

  /// Permanently deletes account from backend database & wipes all local credentials
  Future<void> _executeDeleteAccount() async {
    if (_profile == null) return;
    final email = _profile!.email.toLowerCase();
    final profileId = _profile!.id ?? currentProfileId;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. Call Serverpod Cloud endpoint to cascade delete all backend records
      if (profileId != null) {
        try {
          await client.profile.deleteAccount(profileId);
        } catch (e) {
          debugPrint('Backend deleteAccount error (continuing local wipe): $e');
        }
      }

      // 2. Wipe all local credentials and remembered state from SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Wipe password and user details for this email
      await prefs.remove('pwd_$email');
      await prefs.remove('name_$email');
      await prefs.remove('university_$email');

      // Remove email from local registered emails
      final localRegisteredEmails =
          prefs.getStringList('registered_emails') ?? [];
      localRegisteredEmails.remove(email);
      localRegisteredEmails.removeWhere((e) => e.toLowerCase() == email);
      await prefs.setStringList('registered_emails', localRegisteredEmails);

      // Clear remembered login session if it matches
      final savedEmail = prefs.getString('saved_login_email');
      if (savedEmail != null && savedEmail.toLowerCase() == email) {
        await prefs.remove('saved_login_email');
        await prefs.remove('saved_login_pwd');
        await prefs.remove('saved_login_university');
      }
      await prefs.remove('current_university');

      // Clear all cached request states or matching keys
      final allKeys = prefs.getKeys();
      for (final key in allKeys) {
        if (key.contains(email) ||
            (profileId != null && key.contains('$profileId')) ||
            key.startsWith('connect_') ||
            key.startsWith('request_')) {
          await prefs.remove(key);
        }
      }

      // 3. Clear global session
      currentProfileId = null;
      await prefs.remove('saved_session_token');
      await prefs.remove('saved_profile_id');
      await prefs.remove('saved_login_pwd');
      await prefs.remove('current_user_email');
      await prefs.remove('current_user_role');
      await prefs.remove('current_user_can_create_community');

      // 4. Return to login screen with confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (_) => false,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                '✓ Your account and all credentials have been permanently deleted.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.coral,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to delete account: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _showEditProfileDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const CampusLoader()
          : _error != null
              ? CampusError(message: _error!, onRetry: _loadProfile)
              : _profile == null
                  ? const CampusEmptyState(
                      icon: Icons.person_off,
                      title: 'Profile not found',
                      subtitle: 'Please log in again',
                    )
                  : RefreshIndicator(
                      onRefresh: _loadProfile,
                      child: ListView(
                        children: [
                          CampusFeatureBanner(
                            imageAsset: 'assets/images/profile_banner.jpg',
                            fallbackAsset: 'assets/images/campus_hero.jpg',
                            tag: 'Student Identity',
                            tagColor: CampusTheme.mint,
                            title: 'Academic Passport',
                            subtitle:
                                'Your verified university records, department enrollments, and peer network.',
                            actionLabel: 'Edit Profile ✏️',
                            onAction: _showEditProfileDialog,
                          ),
                          _buildProfileHeader(),
                          _buildInfoSection(),
                          _buildSocialHandlesSection(),
                          _buildSubjectsSection(),
                          _buildInterestsSection(),
                          _buildCommunitiesSection(),
                          _buildConnectionsSection(),
                          _buildCampusSafetySection(),
                          _buildDangerZoneSection(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
    );
  }

  /// Campus Trust, Safety & Moderation section featuring Guidelines, Blocked Students & Reports tracker
  Widget _buildCampusSafetySection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: CampusTheme.mint.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      color: CampusTheme.darkCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: CampusTheme.mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.security_rounded,
                    color: CampusTheme.mint,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Campus Trust & Safety',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Verified affiliation, guidelines, moderation & privacy',
                        style: TextStyle(
                          fontSize: 11,
                          color: CampusTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 1. Campus Guidelines Tile
            InkWell(
              onTap: () => CampusSafetyManager.showCommunityGuidelines(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CampusTheme.darkSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.gavel_rounded,
                        color: CampusTheme.mint, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Campus Community Guidelines',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Zero-tolerance harassment policy & safe study meetup rules',
                            style: TextStyle(
                              fontSize: 11,
                              color: CampusTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right,
                        color: CampusTheme.textMuted, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 2. Blocked Students Manager
            FutureBuilder<List<Map<String, dynamic>>>(
              future: CampusSafetyManager.getBlockedUsersWithNames(
                  currentProfileId ?? 1),
              builder: (ctx, snap) {
                final blockedList = snap.data ?? [];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CampusTheme.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.block_rounded,
                              color: CampusTheme.coral, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'Blocked Students (${blockedList.length})',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (blockedList.isEmpty) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'No students currently blocked. You can block any harassing account from their profile card.',
                          style: TextStyle(
                            fontSize: 11,
                            color: CampusTheme.textMuted,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        ...blockedList.map((item) {
                          final targetId = item['id'] as int;
                          final targetName = item['name'] as String;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                const Icon(Icons.person_off_rounded,
                                    size: 14, color: CampusTheme.coral),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    targetName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: CampusTheme.textLight,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    await CampusSafetyManager.unblockUser(
                                        currentProfileId ?? 1, targetId);
                                    setState(() {});
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content:
                                              Text('✓ $targetName unblocked.'),
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor: CampusTheme.mint,
                                        ),
                                      );
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Unblock',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: CampusTheme.mint,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // 3. Submitted Safety Reports Tracker
            FutureBuilder<List<CampusReport>>(
              future: CampusReport.loadReports(currentProfileId ?? 1),
              builder: (ctx, snap) {
                final reports = snap.data ?? [];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CampusTheme.darkSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              color: CampusTheme.softBlue, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            'My Submitted Moderation Cases (${reports.length})',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (reports.isEmpty) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'No active moderation cases filed. Violations you report are monitored here.',
                          style: TextStyle(
                            fontSize: 11,
                            color: CampusTheme.textMuted,
                          ),
                        ),
                      ] else ...[
                        const SizedBox(height: 8),
                        ...reports.take(3).map((r) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CampusTheme.darkCard,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${r.id} · ${r.reason}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Target: ${r.targetName} (${r.targetType})',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: CampusTheme.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: r.status == 'Resolved' ||
                                            r.status == 'Action Taken'
                                        ? CampusTheme.mint
                                            .withValues(alpha: 0.2)
                                        : CampusTheme.amberOrange
                                            .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    r.status,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      color: r.status == 'Resolved' ||
                                              r.status == 'Action Taken'
                                          ? CampusTheme.mint
                                          : CampusTheme.amberOrange,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDangerZoneSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: CampusTheme.coral.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      color: CampusTheme.darkCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: CampusTheme.coral,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Danger Zone',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.coral,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Permanently delete your account, login credentials, and all profile data across CampusLoop. This cannot be undone.',
              style: TextStyle(
                fontSize: 13,
                color: CampusTheme.textMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.delete_forever_rounded, size: 20),
                label: const Text(
                  'Permanently Delete Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CampusTheme.coral,
                  side: BorderSide(
                    color: CampusTheme.coral.withValues(alpha: 0.6),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _confirmDeleteAccount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final cleanBio = StudentSocials.cleanBio(_profile?.bio);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CampusTheme.deepTeal.withValues(alpha: 0.2),
            CampusTheme.darkCard,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: CampusTheme.deepTeal.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: CampusTheme.deepTeal.withValues(alpha: 0.3),
            child: Text(
              _profile!.displayName[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w700,
                color: CampusTheme.deepTeal,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _profile!.displayName,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CampusTheme.textLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _profile!.email,
            style: const TextStyle(
              fontSize: 14,
              color: CampusTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<bool>(
            future: CampusSafetyManager.isVerified(_profile!.email),
            builder: (ctx, snap) {
              final isVerified = snap.data == true;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isVerified
                      ? CampusTheme.mint.withValues(alpha: 0.15)
                      : CampusTheme.softBlue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isVerified
                        ? CampusTheme.mint.withValues(alpha: 0.4)
                        : CampusTheme.softBlue.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isVerified
                          ? Icons.verified_user_rounded
                          : Icons.shield_outlined,
                      size: 14,
                      color:
                          isVerified ? CampusTheme.mint : CampusTheme.softBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      isVerified
                          ? 'Verified Campus Student 🛡️'
                          : 'Campus Member',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isVerified
                            ? CampusTheme.mint
                            : CampusTheme.softBlue,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (cleanBio.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              cleanBio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: CampusTheme.textMuted.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _statBadge(
                  '${_joinedCommunities.length}', 'Communities', CampusTheme.mint),
              const SizedBox(width: 16),
              _statBadge(
                  '${_connections.length}', 'Connections', CampusTheme.softBlue),
              const SizedBox(width: 16),
              _statBadge(
                  '${_profile!.studySubjects.length}', 'Subjects', CampusTheme.lavender),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statBadge(String count, String label, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: CampusTheme.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Academic Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _infoRow(
              Icons.account_balance_rounded,
              'Institution',
              _university.isNotEmpty ? _university : 'Not set',
            ),
            const Divider(height: 16, thickness: 0.5, color: Colors.white12),
            _infoRow(
              Icons.school_rounded,
              'Department',
              _profile!.department ?? 'Not set',
            ),
            const Divider(height: 16, thickness: 0.5, color: Colors.white12),
            _infoRow(
              Icons.calendar_today_rounded,
              'Year',
              _profile!.year != null ? 'Year ${_profile!.year}' : 'Not set',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: CampusTheme.deepTeal),
          const SizedBox(width: 10),
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: CampusTheme.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: CampusTheme.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialHandlesSection() {
    final socials = StudentSocials.fromBio(_profile?.bio);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(Icons.hub_rounded,
                    color: CampusTheme.mint, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Direct Contact & Socials',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: CampusTheme.textLight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: CampusTheme.mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: CampusTheme.mint.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline_rounded,
                          size: 11, color: CampusTheme.mint),
                      SizedBox(width: 4),
                      Text(
                        'Connected Only',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: CampusTheme.mint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Private channels revealed only to students whose study partner requests you accept.',
              style: TextStyle(fontSize: 12, color: CampusTheme.textMuted),
            ),
            const SizedBox(height: 14),
            _socialRow(
              icon: Icons.chat_bubble_outline_rounded,
              label: 'Discord',
              value: socials.discord,
              emptyHint: 'Not set (tap Edit Profile)',
            ),
            const SizedBox(height: 10),
            _socialRow(
              icon: Icons.business_center_rounded,
              label: 'LinkedIn',
              value: socials.linkedin,
              emptyHint: 'Not set (tap Edit Profile)',
            ),
            const SizedBox(height: 10),
            _socialRow(
              icon: Icons.phone_iphone_rounded,
              label: 'WhatsApp',
              value: socials.whatsapp,
              emptyHint: 'Not set (tap Edit Profile)',
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialRow({
    required IconData icon,
    required String label,
    required String? value,
    required String emptyHint,
  }) {
    final hasVal = value != null && value.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: CampusTheme.darkCardLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: hasVal
              ? CampusTheme.mint.withValues(alpha: 0.3)
              : Colors.white10,
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: hasVal ? CampusTheme.mint : CampusTheme.textMuted),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
          Expanded(
            child: Text(
              hasVal ? value : emptyHint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: hasVal ? Colors.white : CampusTheme.textMuted,
                fontStyle: hasVal ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
          if (hasVal)
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 14),
              color: CampusTheme.textMuted,
              tooltip: 'Copy $label',
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📋 $label copied to clipboard!'),
                    backgroundColor: CampusTheme.mint,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildSubjectsSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Study Subjects',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (_profile!.studySubjects.isEmpty)
              Text(
                'No subjects added yet. Tap edit to add.',
                style: TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textMuted.withValues(alpha: 0.7),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _profile!.studySubjects
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color:
                                CampusTheme.softBlue.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CampusTheme.softBlue
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            s,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CampusTheme.softBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            if (_profile!.interests.isEmpty)
              Text(
                'No interests added yet. Tap edit to add.',
                style: TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textMuted.withValues(alpha: 0.7),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _profile!.interests
                    .map((i) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color:
                                CampusTheme.lavender.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CampusTheme.lavender
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            i,
                            style: const TextStyle(
                              fontSize: 13,
                              color: CampusTheme.lavender,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunitiesSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Communities',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_joinedCommunities.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.mint,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_joinedCommunities.isEmpty)
              const Text(
                'Not a member of any community yet.',
                style: TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textMuted,
                ),
              )
            else
              ..._joinedCommunities.map((c) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: CampusTheme.categoryColor(c.category)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.groups_2,
                        size: 18,
                        color: CampusTheme.categoryColor(c.category),
                      ),
                    ),
                    title: Text(c.name,
                        style: const TextStyle(fontSize: 14)),
                    subtitle: Text(
                      '${c.memberCount} members',
                      style: const TextStyle(fontSize: 11),
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionsSection() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Study Partners',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_connections.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: CampusTheme.softBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_connections.isEmpty)
              const Text(
                'No study partner connections yet.',
                style: TextStyle(
                  fontSize: 13,
                  color: CampusTheme.textMuted,
                ),
              )
            else
              ..._connections.map((conn) {
                final partnerId = conn.fromProfileId == currentProfileId
                    ? conn.toProfileId
                    : conn.fromProfileId;
                return FutureBuilder<StudentProfile?>(
                  future: client.profile.getProfile(partnerId),
                  builder: (ctx, snap) {
                    final name = snap.data?.displayName ?? 'Student';
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            CampusTheme.softBlue.withValues(alpha: 0.2),
                        child: Text(
                          name[0],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: CampusTheme.softBlue,
                          ),
                        ),
                      ),
                      title:
                          Text(name, style: const TextStyle(fontSize: 14)),
                      subtitle: conn.matchingSubjects.isNotEmpty
                          ? Text(
                              conn.matchingSubjects.join(', '),
                              style: const TextStyle(fontSize: 11),
                            )
                          : null,
                    );
                  },
                );
              }),
          ],
        ),
      ),
    );
  }
}
