import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../app_shell.dart';

/// Modern, visually stunning Login & Onboarding Screen for CampusLoop.
/// Features a responsive split-screen layout, rich hero artwork,
/// glassmorphism cards, and quick demo profile selectors.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _deptController = TextEditingController();
  bool _isLoading = false;
  bool _isRegistering = false;
  String? _error;

  // Demo accounts for 1-click test login
  final List<Map<String, String>> _demoProfiles = const [
    {
      'name': 'Aarav Sharma',
      'email': 'aarav.sharma@campus.edu',
      'dept': 'Computer Science',
      'initials': 'AS',
      'color': '0xFF64B5F6',
    },
    {
      'name': 'Priya Patel',
      'email': 'priya.patel@campus.edu',
      'dept': 'Electronics',
      'initials': 'PP',
      'color': '0xFF69F0AE',
    },
    {
      'name': 'Rohan Gupta',
      'email': 'rohan.gupta@campus.edu',
      'dept': 'Computer Science',
      'initials': 'RG',
      'color': '0xFFFFB74D',
    },
    {
      'name': 'Ananya Singh',
      'email': 'ananya.singh@campus.edu',
      'dept': 'Data Science',
      'initials': 'AS',
      'color': '0xFFBA68C8',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _deptController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail(String email) async {
    _emailController.text = email;
    await _login();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Please enter your campus email address.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await client.profile.getProfileByEmail(email);
      if (profile != null) {
        currentProfileId = profile.id;
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AppShell()),
          );
        }
      } else {
        setState(() {
          _isRegistering = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Connection failed. Please check backend status: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final dept = _deptController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = 'Please enter your full name.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await client.profile.createProfile(
        StudentProfile(
          displayName: name,
          email: email,
          department: dept.isNotEmpty ? dept : null,
          year: null,
          bio: 'CampusLoop student',
          studySubjects: [],
          interests: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      currentProfileId = profile.id;
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      }
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1118),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return isWide ? _buildSplitScreen() : _buildMobileScreen();
        },
      ),
    );
  }

  /// Split screen for Desktop and Web browsers
  Widget _buildSplitScreen() {
    return Row(
      children: [
        // Left Column: Visual Hero Art Banner
        Expanded(
          flex: 6,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/campus_hero.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: CampusTheme.darkTeal,
                  child: const Center(
                    child: Icon(Icons.school, size: 80, color: Colors.white24),
                  ),
                ),
              ),
              // Gradient Shade
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0A1118).withValues(alpha: 0.1),
                      const Color(0xFF0A1118).withValues(alpha: 0.85),
                      const Color(0xFF0A1118),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              // Hero Content Overlay
              Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Tag
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: CampusTheme.softBlue.withValues(alpha: 0.4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.hub_rounded,
                                  size: 16, color: CampusTheme.softBlue),
                              SizedBox(width: 8),
                              Text(
                                'Official Campus Network',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Bottom Hero Pitch & Stats
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Experience University Life,\nAll in One Loop.',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Connect with study buddies, discover campus events, participate in communities, and get instant faculty updates.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Mini Stat Badges
                        Row(
                          children: [
                            _buildStatItem('500+', 'Active Students'),
                            const SizedBox(width: 24),
                            _buildStatItem('25+', 'Clubs & Groups'),
                            const SizedBox(width: 24),
                            _buildStatItem('100%', 'Real-Time Serverpod'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Right Column: Auth Form with Glass Effect
        Expanded(
          flex: 5,
          child: Container(
            color: const Color(0xFF0F1923),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 48),
                      child: _buildFormCard(isWide: true),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Compact layout for mobile and small screens
  Widget _buildMobileScreen() {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Hero Artwork Banner with curved bottom
              Stack(
                children: [
                  SizedBox(
                    height: 240,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/campus_hero.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: CampusTheme.darkTeal,
                      ),
                    ),
                  ),
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          const Color(0xFF0A1118).withValues(alpha: 0.7),
                          const Color(0xFF0A1118),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 24,
                    right: 24,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/campus_logo.jpg',
                            width: 52,
                            height: 52,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.loop_rounded,
                                    size: 44, color: CampusTheme.mint),
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CampusLoop',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Text(
                              'Your Campus. One Loop.',
                              style: TextStyle(
                                fontSize: 13,
                                color: CampusTheme.softBlue,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: _buildFormCard(isWide: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Interactive Form Card used in both split and mobile view
  Widget _buildFormCard({required bool isWide}) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF14202C).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isWide) ...[
            // Logo & Title for Wide Screens
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/campus_logo.jpg',
                    width: 54,
                    height: 54,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [CampusTheme.deepTeal, CampusTheme.softBlue],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.loop_rounded,
                          size: 32, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CampusLoop',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Text(
                      'Student Portal & Community',
                      style: TextStyle(
                        fontSize: 13,
                        color: CampusTheme.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Quick Login Profile Chips Header
          Row(
            children: [
              const Icon(Icons.bolt_rounded, size: 18, color: CampusTheme.mint),
              const SizedBox(width: 6),
              Text(
                'Quick 1-Click Demo Profiles',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: CampusTheme.mint.withValues(alpha: 0.9),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Demo Profile Avatars Grid
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _demoProfiles.map((p) {
              final color = Color(int.parse(p['color']!));
              return InkWell(
                onTap: _isLoading ? null : () => _loginWithEmail(p['email']!),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B2A38),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: color.withValues(alpha: 0.2),
                        child: Text(
                          p['initials']!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['name']!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            p['dept']!,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'OR USE EMAIL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.4),
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Email Input Field
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Campus Email',
              labelStyle:
                  TextStyle(color: Colors.white.withValues(alpha: 0.7)),
              hintText: 'you@campus.edu',
              hintStyle:
                  TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              prefixIcon:
                  const Icon(Icons.email_outlined, color: CampusTheme.softBlue),
              filled: true,
              fillColor: const Color(0xFF1B2A38),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                    color: CampusTheme.mint, width: 1.5),
              ),
            ),
            enabled: !_isLoading && !_isRegistering,
            onSubmitted: (_) => _login(),
          ),
          const SizedBox(height: 16),

          if (_isRegistering) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CampusTheme.mint.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CampusTheme.mint.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                children: [
                  Icon(Icons.person_add_alt_1_rounded,
                      size: 18, color: CampusTheme.mint),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Welcome! Complete your profile to enter:',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: CampusTheme.mint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Full Name',
                labelStyle:
                    TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                hintText: 'e.g. Alex Morgan',
                prefixIcon: const Icon(Icons.person_outline,
                    color: CampusTheme.softBlue),
                filled: true,
                fillColor: const Color(0xFF1B2A38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _deptController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Department (optional)',
                labelStyle:
                    TextStyle(color: Colors.white.withValues(alpha: 0.7)),
                hintText: 'e.g. Computer Science',
                prefixIcon: const Icon(Icons.school_outlined,
                    color: CampusTheme.softBlue),
                filled: true,
                fillColor: const Color(0xFF1B2A38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              enabled: !_isLoading,
            ),
            const SizedBox(height: 20),
            Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [CampusTheme.deepTeal, Color(0xFF00BFA5)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: CampusTheme.deepTeal.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Text(
                        'Create Profile & Enter',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => setState(() => _isRegistering = false),
              child: Text(
                'Back to quick login',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ),
          ] else ...[
            Container(
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [CampusTheme.deepTeal, Color(0xFF00BFA5)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: CampusTheme.deepTeal.withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enter CampusLoop',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded,
                              size: 18, color: Colors.white),
                        ],
                      ),
              ),
            ),
          ],

          if (_error != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: CampusTheme.coral.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CampusTheme.coral.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 18, color: CampusTheme.coral),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: CampusTheme.coral,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Security / Cloud Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: CampusTheme.mint,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Connected to Serverpod Cloud Production',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: CampusTheme.mint,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
