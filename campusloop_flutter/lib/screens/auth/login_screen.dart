import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../app_shell.dart';

/// Login / Profile Selection screen.
///
/// DEVELOPMENT NOTE: This screen provides a simplified session mechanism
/// for development purposes. In production, this would use Serverpod's
/// JWT-based authentication with proper identity verification.
///
/// Current implementation allows selecting or creating a profile for
/// development testing. It does NOT provide production-ready authentication.
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
      begin: const Offset(0, 0.15),
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

  Future<void> _login() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Please enter your campus email.');
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
        _error = 'Could not connect to server. Is the backend running?';
        _isLoading = false;
      });
    }
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final name = _nameController.text.trim();
    final dept = _deptController.text.trim();

    if (name.isEmpty) {
      setState(() => _error = 'Please enter your name.');
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final profile = await client.profile.createProfile(
        // The generated client will use the model class from campusloop_client.
        // This constructor matches the StudentProfile model definition.
        StudentProfile(
          displayName: name,
          email: email,
          department: dept.isNotEmpty ? dept : null,
          year: null,
          bio: null,
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
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // ── Logo & Branding ──
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [CampusTheme.deepTeal, CampusTheme.darkTeal],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: CampusTheme.deepTeal.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.loop_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'CampusLoop',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: CampusTheme.textLight,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Your Campus. Your Community. One Loop.',
                    style: TextStyle(
                      fontSize: 15,
                      color: CampusTheme.textMuted.withValues(alpha: 0.8),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // ── Dev Session Notice ──
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CampusTheme.softBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CampusTheme.softBlue.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 18, color: CampusTheme.softBlue),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Development session — not production auth',
                            style: TextStyle(
                              fontSize: 12,
                              color: CampusTheme.softBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Email Field ──
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Campus Email',
                      hintText: 'you@campus.edu',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    enabled: !_isLoading && !_isRegistering,
                    onSubmitted: (_) => _login(),
                  ),
                  const SizedBox(height: 16),

                  if (_isRegistering) ...[
                    // ── Registration Fields ──
                    const Text(
                      'New here? Complete your profile:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CampusTheme.mint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Display Name',
                        hintText: 'Your name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _deptController,
                      decoration: const InputDecoration(
                        labelText: 'Department (optional)',
                        hintText: 'e.g., Computer Science',
                        prefixIcon: Icon(Icons.school_outlined),
                      ),
                      enabled: !_isLoading,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
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
                            : const Text('Create Profile & Enter'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () =>
                          setState(() => _isRegistering = false),
                      child: const Text('Back to login'),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
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
                            : const Text('Enter CampusLoop'),
                      ),
                    ),
                  ],

                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CampusTheme.coral.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: CampusTheme.coral.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              size: 18, color: CampusTheme.coral),
                          const SizedBox(width: 10),
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

                  const SizedBox(height: 40),
                  // ── Team Credit ──
                  Center(
                    child: Text(
                      'Built by HACKTIVATORS',
                      style: TextStyle(
                        fontSize: 12,
                        color: CampusTheme.textMuted.withValues(alpha: 0.5),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
