import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../models/study_collab_models.dart';
import '../../models/campus_safety_models.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';
import '../app_shell.dart';
import 'email_otp_dialog.dart';

/// Comprehensive Student Authentication & Onboarding Screen.
///
/// Supports two modes:
/// 1. New User: Full profile onboarding + password creation with duplicate email protection
///    and automatic validation feedback / auto-scroll.
/// 2. Existing User: Quick sign-in with email & password, credential persistence ("Remember Me"),
///    and responsive non-spilling buttons.
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
  final _scrollController = ScrollController();

  // Mode Selection: true = New User (Register), false = Existing User (Sign In)
  bool _isNewUser = true;

  // ── New User Form State ──
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _universityController = TextEditingController();
  final _deptController =
      TextEditingController(text: 'Computer Science & Engineering');
  final _bioController = TextEditingController(
      text: 'CampusLoop student passionate about technology and collaboration.');
  final _discordController = TextEditingController();
  final _linkedinController = TextEditingController();
  final _whatsappController = TextEditingController();
  int _selectedYear = 1;
  bool _obscurePassword = true;

  final Set<String> _selectedSubjects = {
    'Computer Science',
    'AI & Data Science',
  };
  final Set<String> _selectedInterests = {
    'Coding',
    'Hackathons',
    'AI',
  };

  final List<String> _commonDepartments = const [
    'Computer Science & Engineering',
    'Information Technology (IT)',
    'Artificial Intelligence & Data Science',
    'Electronics & Communication (ECE)',
    'Electrical & Electronics (EEE)',
    'Mechanical Engineering',
    'Civil Engineering',
    'Chemical Engineering',
    'Aerospace & Aeronautical Engineering',
    'Biotechnology & Biomedical Engineering',
    'Robotics & Automation',
    'Cybersecurity & Cloud Computing',
    'Business Administration (BBA / MBA)',
    'Commerce & Accounting',
    'Economics & Financial Studies',
    'Design, UI/UX & Media Arts',
    'Architecture & Urban Planning',
    'Law & Legal Studies',
    'Humanities & Social Sciences',
    'Mathematics & Computing',
    'Physics & Applied Sciences',
    'Chemistry & Materials Science',
    'Medicine, Pharmacy & Health Sciences',
    'Journalism & Mass Media',
    'Environmental Science & Ecology',
  ];

  final List<String> _suggestedSubjects = const [
    'Computer Science',
    'AI & Data Science',
    'Data Structures',
    'Web Development',
    'Cloud Computing',
    'Algorithms',
    'Mobile Dev (Flutter)',
    'Cybersecurity',
    'Calculus',
  ];

  final List<String> _suggestedInterests = const [
    'Coding',
    'Hackathons',
    'AI',
    'Robotics',
    'Gaming',
    'Open Source',
    'Startups',
    'Music',
    'Photography',
    'Design',
  ];

  final _customSubjectCtrl = TextEditingController();
  final _customInterestCtrl = TextEditingController();

  // ── Existing User Form State ──
  final _signInFormKey = GlobalKey<FormState>();
  final _signInEmailController = TextEditingController();
  final _signInPasswordController = TextEditingController();
  bool _obscureSignInPassword = true;
  bool _rememberMe = true;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();

    _loadSavedCredentials();
  }

  /// Strict Gmail validation regex & anti-disposable rules
  bool _isValidGmail(String email) {
    final trimmed = email.trim().toLowerCase();
    if (trimmed.isEmpty) return false;
    if (!trimmed.endsWith('@gmail.com')) return false;
    if (trimmed.contains('+') ||
        trimmed.contains('trash') ||
        trimmed.contains('temp') ||
        trimmed.contains('fake')) {
      return false;
    }
    final regex = RegExp(
      r'^[a-zA-Z0-9](?!.*\.\.)[a-zA-Z0-9.]{4,28}[a-zA-Z0-9]@gmail\.com$',
      caseSensitive: false,
    );
    return regex.hasMatch(trimmed);
  }

  /// Automatically load saved email & password from persistent storage
  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_login_email') ?? '';
      final savedPwd = prefs.getString('saved_login_pwd') ?? '';
      final savedUniv = prefs.getString('saved_login_university') ?? '';
      final savedProfileId = prefs.getInt('saved_profile_id');

      if (savedProfileId != null) {
        currentProfileId = savedProfileId;
      }
      if (savedUniv.isNotEmpty && mounted) {
        _universityController.text = savedUniv;
      }
      if (savedEmail.isNotEmpty && mounted) {
        setState(() {
          _signInEmailController.text = savedEmail;
          _signInPasswordController.text = savedPwd;
          // Default to Existing User tab when saved credentials exist
          _isNewUser = false;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _animController.dispose();
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _universityController.dispose();
    _deptController.dispose();
    _bioController.dispose();
    _discordController.dispose();
    _linkedinController.dispose();
    _whatsappController.dispose();
    _customSubjectCtrl.dispose();
    _customInterestCtrl.dispose();
    _signInEmailController.dispose();
    _signInPasswordController.dispose();
    super.dispose();
  }

  /// Interactive bottom sheet for selecting from 25+ departments
  void _showDepartmentPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: CampusTheme.darkCard,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final filtered = _commonDepartments
                .where((d) =>
                    d.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.school_rounded,
                              color: CampusTheme.mint, size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Select Department',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            color: CampusTheme.textMuted),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search department (e.g. Computer, Business)...',
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: CampusTheme.textMuted),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      filled: true,
                      fillColor: CampusTheme.darkCardLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (q) =>
                        setSheetState(() => searchQuery = q.trim()),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1, thickness: 0.5, color: Colors.white10),
                      itemBuilder: (ctx, idx) {
                        final dept = filtered[idx];
                        final isSelected =
                            _deptController.text.trim() == dept;
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          title: Text(
                            dept,
                            style: TextStyle(
                              color: isSelected
                                  ? CampusTheme.primaryOrange
                                  : Colors.white,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle_rounded,
                                  color: CampusTheme.primaryOrange, size: 20)
                              : null,
                          onTap: () {
                            setState(() {
                              _deptController.text = dept;
                              if (_error != null) _error = null;
                            });
                            ScaffoldMessenger.of(context).clearSnackBars();
                            Navigator.pop(ctx);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  /// Register a brand new student profile with Gmail OTP verification
  Future<void> _handleRegisterNewUser() async {
    // 1. Validate all form fields
    if (!_formKey.currentState!.validate()) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              '⚠️ Please fill in all required fields with a valid @gmail.com address'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: CampusTheme.coral,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final university = _universityController.text.trim();
    final password = _passwordController.text;
    final dept = _deptController.text.trim();
    final bio = _bioController.text.trim();

    if (!_isValidGmail(email)) {
      setState(() {
        _error =
            'Only genuine Google-created Gmail accounts (@gmail.com) are allowed to register.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });
    ScaffoldMessenger.of(context).clearSnackBars();

    try {
      // Step 1: Request 6-digit OTP from Serverpod backend
      final otpRes = await client.auth.requestRegistrationOtp(email);
      if (!otpRes.success) {
        setState(() {
          _isLoading = false;
          _error = otpRes.message;
        });
        return;
      }

      setState(() => _isLoading = false);

      // Step 2: Show secure OTP verification dialog
      if (!mounted) return;
      final verified = await EmailOtpDialog.show(
        context,
        email: email,
        onVerify: (otp) async {
          final socials = StudentSocials(
            discord: _discordController.text.trim().isNotEmpty
                ? _discordController.text.trim()
                : null,
            linkedin: _linkedinController.text.trim().isNotEmpty
                ? _linkedinController.text.trim()
                : null,
            whatsapp: _whatsappController.text.trim().isNotEmpty
                ? _whatsappController.text.trim()
                : null,
          );
          final rawBio = StudentSocials.embedInBio(bio, socials);


          final authRes = await client.auth.completeRegistration(
            displayName: name,
            email: email,
            password: password,
            otp: otp,
            department: dept.isNotEmpty ? dept : 'General Studies',
            year: _selectedYear,
            bio: rawBio.isNotEmpty ? rawBio : 'CampusLoop student from $dept',
            studySubjects: _selectedSubjects.toList(),
            interests: _selectedInterests.toList(),
          );

          if (!authRes.success) {
            throw Exception(authRes.message);
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('saved_login_email', email);
          await prefs.setString('saved_login_pwd', password);
          await prefs.setString('saved_session_token', 'session_${email}_${DateTime.now().millisecondsSinceEpoch}');
          await prefs.setString('current_user_email', email);
          await prefs.setString('current_user_role', authRes.profile?.role ?? 'student');
          await prefs.setBool('current_user_can_create_community', authRes.profile?.canCreateCommunity ?? false);
          if (authRes.profile?.id != null) {
            await prefs.setInt('saved_profile_id', authRes.profile!.id!);
            currentProfileId = authRes.profile!.id!;
          }

          if (university.isNotEmpty) {
            await prefs.setString('university_$email', university);
            await prefs.setString('current_university', university);
            await prefs.setString('saved_login_university', university);
          }
          await StudentSocials.saveLocalSocials(email, socials);
          await CampusSafetyManager.setVerified(email, true);
        },
        onResend: () async {
          final res = await client.auth.requestRegistrationOtp(email);
          return res.message;
        },
      );

      if (verified == true && mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎉 Email verified successfully! Welcome to CampusLoop.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.mint,
            duration: Duration(seconds: 4),
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  /// Sign in an existing student with credentials validation & feedback
  Future<void> _handleExistingUserSignIn() async {
    if (!_signInFormKey.currentState!.validate()) {
      _scrollController.animateTo(0,
          duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please enter your registered Gmail address and password'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: CampusTheme.coral,
        ),
      );
      return;
    }

    final email = _signInEmailController.text.trim().toLowerCase();
    final password = _signInPasswordController.text;

    if (!_isValidGmail(email)) {
      setState(() {
        _error = 'Please enter a valid @gmail.com address.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authRes = await client.auth.login(email, password);

      if (!authRes.success) {
        setState(() => _isLoading = false);

        // If user account is unverified, prompt email verification OTP immediately
        if (authRes.requiresOtp == true) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authRes.message),
              backgroundColor: CampusTheme.amberOrange,
              duration: const Duration(seconds: 4),
            ),
          );

          final verified = await EmailOtpDialog.show(
            context,
            email: email,
            onVerify: (otp) async {
              final vRes = await client.auth.verifyOtp(email, otp);
              if (!vRes.success) {
                throw Exception(vRes.message);
              }
              // Retry login with verified status
              final retryRes = await client.auth.login(email, password);
              if (!retryRes.success) {
                throw Exception(retryRes.message);
              }
              final prefs = await SharedPreferences.getInstance();
              if (_rememberMe) {
                await prefs.setString('saved_login_email', email);
                await prefs.setString('saved_login_pwd', password);
              }
              await prefs.setString('saved_session_token', 'session_${email}_${DateTime.now().millisecondsSinceEpoch}');
              await prefs.setString('current_user_email', email);
              await prefs.setString('current_user_role', retryRes.profile?.role ?? 'student');
              await prefs.setBool('current_user_can_create_community', retryRes.profile?.canCreateCommunity ?? false);
              if (retryRes.profile?.id != null) {
                await prefs.setInt('saved_profile_id', retryRes.profile!.id!);
                currentProfileId = retryRes.profile!.id!;
              }
              await CampusSafetyManager.setVerified(email, true);
            },
            onResend: () async {
              final res = await client.auth.requestRegistrationOtp(email);
              return res.message;
            },
          );

          if (verified == true && mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AppShell()),
            );
          }
          return;
        }

        // Incorrect credentials or rejection
        setState(() {
          _error = authRes.message;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(authRes.message),
              behavior: SnackBarBehavior.floating,
              backgroundColor: CampusTheme.coral,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        return;
      }

      // Login successful!
      final prefs = await SharedPreferences.getInstance();
      if (_rememberMe) {
        await prefs.setString('saved_login_email', email);
        await prefs.setString('saved_login_pwd', password);
      } else {
        await prefs.remove('saved_login_email');
        await prefs.remove('saved_login_pwd');
      }

      await prefs.setString('saved_session_token', 'session_${email}_${DateTime.now().millisecondsSinceEpoch}');
      await prefs.setString('current_user_email', email);
      await prefs.setString('current_user_role', authRes.profile?.role ?? 'student');
      await prefs.setBool('current_user_can_create_community', authRes.profile?.canCreateCommunity ?? false);
      if (authRes.profile?.id != null) {
        await prefs.setInt('saved_profile_id', authRes.profile!.id!);
        currentProfileId = authRes.profile!.id!;
      }

      final savedUniv = prefs.getString('university_$email');
      if (savedUniv != null && savedUniv.isNotEmpty) {
        await prefs.setString('current_university', savedUniv);
      }
      await CampusSafetyManager.setVerified(email, true);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Connection error: ${e.toString().replaceAll('Exception: ', '')}';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_error!),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.coral,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      backgroundColor: CampusTheme.darkSurface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isWide ? 520 : double.infinity,
                  ),
                  child: Column(
                    children: [
                      // Header Logo & Branding
                      const OrangeInfinityLogo(size: 68),
                      const SizedBox(height: 16),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.8,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(text: 'Campus'),
                            TextSpan(
                              text: 'Loop',
                              style:
                                  TextStyle(color: CampusTheme.primaryOrange),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Your Campus. Your Community. One Loop.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: CampusTheme.textMuted.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Vibrant Campus Hero Banner Image
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: CampusTheme.primaryOrange
                                  .withValues(alpha: 0.15),
                              blurRadius: 24,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Stack(
                            children: [
                              Image.asset(
                                'assets/images/login_hero.jpg',
                                height: 175,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (ctx, err, stack) => Image.asset(
                                  'assets/images/campus_hero.jpg',
                                  height: 175,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Cinematic dark gradient overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.black.withValues(alpha: 0.15),
                                        Colors.black.withValues(alpha: 0.55),
                                        CampusTheme.darkCard
                                            .withValues(alpha: 0.95),
                                      ],
                                      stops: const [0.0, 0.6, 1.0],
                                    ),
                                  ),
                                ),
                              ),
                              // Border outline matching app aesthetics
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(
                                      color: CampusTheme.primaryOrange
                                          .withValues(alpha: 0.35),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                              // Top badge pill
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                        Colors.black.withValues(alpha: 0.70),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: CampusTheme.primaryOrange
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.school_rounded,
                                          color: CampusTheme.primaryOrange,
                                          size: 14),
                                      SizedBox(width: 6),
                                      Text(
                                        'Campus Community',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Bottom caption overlay
                              Positioned(
                                bottom: 12,
                                left: 14,
                                right: 14,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: CampusTheme.primaryOrange
                                            .withValues(alpha: 0.25),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: CampusTheme.primaryOrange
                                              .withValues(alpha: 0.5),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.hub_rounded,
                                        color: CampusTheme.primaryOrange,
                                        size: 15,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Connect with classmates · Clubs · Events',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 6,
                                              color: Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── NEW USER vs EXISTING USER SELECTOR TABS ──
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: CampusTheme.darkCardLight,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: CampusTheme.divider.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            // New User Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isNewUser = true;
                                    _error = null;
                                  });
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _isNewUser
                                        ? CampusTheme.primaryOrange
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: _isNewUser
                                        ? [
                                            BoxShadow(
                                              color: CampusTheme.primaryOrange
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_add_rounded,
                                        size: 17,
                                        color: _isNewUser
                                            ? Colors.white
                                            : CampusTheme.textMuted,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'New User',
                                        style: TextStyle(
                                          color: _isNewUser
                                              ? Colors.white
                                              : CampusTheme.textMuted,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Existing User Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isNewUser = false;
                                    _error = null;
                                  });
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !_isNewUser
                                        ? CampusTheme.primaryOrange
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: !_isNewUser
                                        ? [
                                            BoxShadow(
                                              color: CampusTheme.primaryOrange
                                                  .withValues(alpha: 0.4),
                                              blurRadius: 10,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.login_rounded,
                                        size: 17,
                                        color: !_isNewUser
                                            ? Colors.white
                                            : CampusTheme.textMuted,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Existing User',
                                        style: TextStyle(
                                          color: !_isNewUser
                                              ? Colors.white
                                              : CampusTheme.textMuted,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card Containing Selected Mode's Form
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: CampusTheme.darkCard,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: CampusTheme.primaryOrange
                                .withValues(alpha: 0.28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: CampusTheme.primaryOrange
                                  .withValues(alpha: 0.10),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header of Form
                            Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: CampusTheme.primaryOrange,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isNewUser
                                      ? 'New Student Registration'
                                      : 'Existing User Sign In',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _isNewUser
                                  ? 'Create your profile and password to join your campus loop.'
                                  : 'Enter your registered campus email and password to sign in.',
                              style: const TextStyle(
                                fontSize: 13,
                                color: CampusTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Error Message Banner (e.g. Email already registered) with 1-tap dismiss
                            if (_error != null) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color:
                                      CampusTheme.coral.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: CampusTheme.coral
                                        .withValues(alpha: 0.4),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline_rounded,
                                        color: CampusTheme.coral, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _error!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close_rounded,
                                          color: Colors.white70, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () {
                                        setState(() => _error = null);
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // FORM BODY: Switched between New User and Existing User
                            if (_isNewUser)
                              _buildNewUserForm()
                            else
                              _buildExistingUserForm(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campus Highlights Ticker
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: CampusTheme.darkCardLight
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildHighlightItem(Icons.bolt_rounded,
                                '500+ Active', CampusTheme.primaryOrange),
                            Container(
                                width: 1, height: 16, color: Colors.white12),
                            _buildHighlightItem(Icons.event_rounded,
                                'Live Events', CampusTheme.coral),
                            Container(
                                width: 1, height: 16, color: Colors.white12),
                            _buildHighlightItem(Icons.groups_rounded,
                                'Student Clubs', CampusTheme.mint),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Footer
                      Text(
                        'Powered by Serverpod Cloud · Verified Campus Network',
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              CampusTheme.textMuted.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // ── NEW USER REGISTRATION FORM ──
  // ══════════════════════════════════════════════════════
  Widget _buildNewUserForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Display Name
          _buildLabel('Display Name'),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization.words,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            decoration: const InputDecoration(
              hintText: 'e.g. Siddhi Dheer',
              prefixIcon: Icon(Icons.person_rounded,
                  color: CampusTheme.primaryOrange),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 2. Campus Email (Strict Genuine Gmail Only)
          _buildLabel('Gmail Address (Google Account)'),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            decoration: const InputDecoration(
              hintText: 'e.g. siddhi1@gmail.com',
              prefixIcon: Icon(Icons.alternate_email_rounded,
                  color: CampusTheme.softBlue),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your Gmail address';
              }
              if (!_isValidGmail(value.trim())) {
                return 'Only genuine Gmail accounts (@gmail.com) are allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: CampusTheme.mint.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: CampusTheme.mint.withValues(alpha: 0.3),
                width: 0.9,
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.mark_email_read_rounded,
                  size: 16,
                  color: CampusTheme.mint,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Verification code (OTP) will be sent to your Gmail upon registration',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: CampusTheme.mint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. University / College Name
          _buildLabel('University / College Name'),
          TextFormField(
            controller: _universityController,
            style: const TextStyle(color: Colors.white),
            textCapitalization: TextCapitalization.words,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            decoration: const InputDecoration(
              hintText: 'e.g. Stanford University / Tech Campus',
              prefixIcon: Icon(Icons.account_balance_rounded,
                  color: CampusTheme.amberOrange),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your university or college name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 4. Create Password
          _buildLabel('Create Password'),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            decoration: InputDecoration(
              hintText: 'At least 6 characters...',
              prefixIcon: const Icon(Icons.lock_outline_rounded,
                  color: CampusTheme.amberOrange),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: CampusTheme.textMuted,
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please create a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // 5. Department & Year Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Department with bottom sheet picker and custom typing
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Department'),
                    TextFormField(
                      controller: _deptController,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      onChanged: (_) {
                        if (_error != null) setState(() => _error = null);
                        ScaffoldMessenger.of(context).clearSnackBars();
                      },
                      decoration: InputDecoration(
                        hintText: 'Select or type department',
                        prefixIcon: const Icon(Icons.school_rounded,
                            color: CampusTheme.mint),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.arrow_drop_down_circle_outlined,
                              color: CampusTheme.mint, size: 20),
                          tooltip: 'Choose from 25+ departments',
                          onPressed: _showDepartmentPicker,
                        ),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Year
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Year'),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedYear,
                      dropdownColor: CampusTheme.darkCard,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 14),
                      ),
                      items: [1, 2, 3, 4, 5]
                          .map((y) => DropdownMenuItem(
                                value: y,
                                child: Text('Year $y'),
                              ))
                          .toList(),
                      onChanged: (y) {
                        if (y != null) {
                          setState(() => _selectedYear = y);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 6. Bio
          _buildLabel('Bio (About You)'),
          TextFormField(
            controller: _bioController,
            maxLines: 2,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            decoration: const InputDecoration(
              hintText:
                  'A short intro about your projects, skills, or goals...',
              prefixIcon: Icon(Icons.info_outline_rounded,
                  color: CampusTheme.lavender),
            ),
          ),
          const SizedBox(height: 18),

          // 7. Study Partner Direct Channels (Optional - Revealed Only to Connected Peers)
          _buildLabel('Partner Contact Channels (Optional)'),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CampusTheme.darkCardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: CampusTheme.mint.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        size: 16, color: CampusTheme.mint),
                    SizedBox(width: 6),
                    Text(
                      'Private & Safe (Connected Peers Only)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: CampusTheme.mint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'These handles remain hidden and will ONLY be revealed to students whose study partner request you accept.',
                  style: TextStyle(fontSize: 11, color: CampusTheme.textMuted),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _discordController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'Discord ID / Tag',
                    hintText: 'e.g. siddhi#1234 or @siddhi',
                    prefixIcon:
                        Icon(Icons.chat_bubble_outline_rounded, size: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _linkedinController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'LinkedIn Profile URL / Handle',
                    hintText: 'e.g. linkedin.com/in/siddhi',
                    prefixIcon: Icon(Icons.business_center_rounded, size: 18),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _whatsappController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    labelText: 'WhatsApp / Phone (Optional)',
                    hintText: 'e.g. +91 9876543210',
                    prefixIcon: Icon(Icons.phone_iphone_rounded, size: 18),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // 8. Study Subjects
          _buildLabel('Study Subjects (Tap to select or add)'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _suggestedSubjects.map((s) {
              final isSelected = _selectedSubjects.contains(s);
              return FilterChip(
                label: Text(s),
                selected: isSelected,
                selectedColor: CampusTheme.primaryOrange,
                checkmarkColor: Colors.white,
                backgroundColor: CampusTheme.darkCardLight,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : CampusTheme.textMuted,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedSubjects.add(s);
                    } else {
                      _selectedSubjects.remove(s);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customSubjectCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Add custom subject...',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  final text = _customSubjectCtrl.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _selectedSubjects.add(text);
                      _customSubjectCtrl.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: CampusTheme.primaryOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // 7. Interests & Hobbies
          _buildLabel('Interests & Passions (Connect with peers)'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _suggestedInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                selectedColor: CampusTheme.coral,
                checkmarkColor: Colors.white,
                backgroundColor: CampusTheme.darkCardLight,
                labelStyle: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : CampusTheme.textMuted,
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customInterestCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: const InputDecoration(
                    hintText: 'Add custom interest...',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: () {
                  final text = _customInterestCtrl.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      _selectedInterests.add(text);
                      _customInterestCtrl.clear();
                    });
                  }
                },
                icon: const Icon(Icons.add, size: 18),
                style: IconButton.styleFrom(
                  backgroundColor: CampusTheme.coral,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Submit Button: Register & Enter (FittedBox ensures text never spills out)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegisterNewUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: CampusTheme.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor:
                    CampusTheme.primaryOrange.withValues(alpha: 0.5),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register & Enter CampusLoop',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Switcher to Existing User
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isNewUser = false;
                  _error = null;
                });
                ScaffoldMessenger.of(context).clearSnackBars();
              },
              child: RichText(
                text: const TextSpan(
                  style:
                      TextStyle(fontSize: 13, color: CampusTheme.textMuted),
                  children: [
                    TextSpan(text: 'Already registered? '),
                    TextSpan(
                      text: 'Sign In as Existing User',
                      style: TextStyle(
                        color: CampusTheme.primaryOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════
  // ── EXISTING USER SIGN IN FORM ──
  // ══════════════════════════════════════════════════════
  Widget _buildExistingUserForm() {
    return Form(
      key: _signInFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Campus Email (Verified Gmail)
          _buildLabel('Registered Gmail Address'),
          TextFormField(
            controller: _signInEmailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            decoration: const InputDecoration(
              hintText: 'e.g. siddhi1@gmail.com',
              prefixIcon: Icon(Icons.alternate_email_rounded,
                  color: CampusTheme.softBlue),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your Gmail address';
              }
              if (!_isValidGmail(value.trim())) {
                return 'Please enter a valid @gmail.com address';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),

          // 2. Password
          _buildLabel('Password'),
          TextFormField(
            controller: _signInPasswordController,
            obscureText: _obscureSignInPassword,
            style: const TextStyle(color: Colors.white),
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
              ScaffoldMessenger.of(context).clearSnackBars();
            },
            decoration: InputDecoration(
              hintText: 'Enter your password...',
              prefixIcon: const Icon(Icons.lock_outline_rounded,
                  color: CampusTheme.amberOrange),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureSignInPassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: CampusTheme.textMuted,
                  size: 20,
                ),
                onPressed: () => setState(
                    () => _obscureSignInPassword = !_obscureSignInPassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 14),

          // 3. Remember Me Checkbox
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                activeColor: CampusTheme.primaryOrange,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (val) {
                  if (val != null) setState(() => _rememberMe = val);
                },
              ),
              GestureDetector(
                onTap: () => setState(() => _rememberMe = !_rememberMe),
                child: const Text(
                  'Remember my email & password',
                  style: TextStyle(
                    color: CampusTheme.textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Submit Button: Sign In (FittedBox ensures text never spills out)
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleExistingUserSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: CampusTheme.primaryOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor:
                    CampusTheme.primaryOrange.withValues(alpha: 0.5),
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In to CampusLoop',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.login_rounded, size: 18),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Switcher to New User
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isNewUser = true;
                  _error = null;
                });
                ScaffoldMessenger.of(context).clearSnackBars();
              },
              child: RichText(
                text: const TextSpan(
                  style:
                      TextStyle(fontSize: 13, color: CampusTheme.textMuted),
                  children: [
                    TextSpan(text: 'New student? '),
                    TextSpan(
                      text: 'Create a New Account',
                      style: TextStyle(
                        color: CampusTheme.primaryOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: CampusTheme.textLight,
        ),
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: CampusTheme.textLight.withValues(alpha: 0.85),
          ),
        ),
      ],
    );
  }
}
