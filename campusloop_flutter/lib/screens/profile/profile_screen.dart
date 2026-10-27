import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';
import '../auth/login_screen.dart';

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

      if (mounted) {
        setState(() {
          _profile = profile;
          _joinedCommunities = communities;
          _connections = connections;
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

    final nameCtrl = TextEditingController(text: _profile!.displayName);
    final deptCtrl = TextEditingController(text: _profile!.department ?? '');
    final bioCtrl = TextEditingController(text: _profile!.bio ?? '');
    final subjectsCtrl = TextEditingController(
        text: _profile!.studySubjects.join(', '));
    final interestsCtrl = TextEditingController(
        text: _profile!.interests.join(', '));
    int? year = _profile!.year;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Display Name'),
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
                  decoration: const InputDecoration(labelText: 'Bio'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subjectsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Study Subjects',
                    hintText: 'Comma-separated',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: interestsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Interests',
                    hintText: 'Comma-separated',
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
                  _profile!
                    ..displayName = nameCtrl.text.trim()
                    ..department = deptCtrl.text.trim().isNotEmpty
                        ? deptCtrl.text.trim()
                        : null
                    ..year = year
                    ..bio =
                        bioCtrl.text.trim().isNotEmpty ? bioCtrl.text.trim() : null
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

  void _logout() {
    currentProfileId = null;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
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
                          _buildProfileHeader(),
                          _buildInfoSection(),
                          _buildSubjectsSection(),
                          _buildInterestsSection(),
                          _buildCommunitiesSection(),
                          _buildConnectionsSection(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
    );
  }

  Widget _buildProfileHeader() {
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
          if (_profile!.bio != null && _profile!.bio!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              _profile!.bio!,
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
            _infoRow(Icons.school, 'Department',
                _profile!.department ?? 'Not set'),
            _infoRow(Icons.calendar_today, 'Year',
                _profile!.year != null ? 'Year ${_profile!.year}' : 'Not set'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: CampusTheme.deepTeal),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: CampusTheme.textMuted,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: CampusTheme.textLight,
            ),
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
