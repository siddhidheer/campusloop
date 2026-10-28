import 'package:flutter/material.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../main.dart';
import '../../theme/campus_theme.dart';
import '../../widgets/common/campus_widgets.dart';
import '../app_shell.dart';

/// Comprehensive, modern Student Onboarding & Login Screen.
///
/// Includes all profile fields: Display Name, Campus Email, Department,
/// Year of Study, Bio, Study Subjects, and Interests with quick-toggle chips.
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

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _deptController =
      TextEditingController(text: 'Computer Science & Engineering');
  final _bioController = TextEditingController(
      text: 'CampusLoop student passionate about technology and collaboration.');
  int _selectedYear = 1;

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
    'Information Technology',
    'Electronics & Communication',
    'Electrical Engineering',
    'Mechanical Engineering',
    'Data Science & AI',
    'Business Administration',
    'Design & Architecture',
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
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _deptController.dispose();
    _bioController.dispose();
    _customSubjectCtrl.dispose();
    _customInterestCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleEnterCampus() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();
    final dept = _deptController.text.trim();
    final bio = _bioController.text.trim();

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. Try to find existing profile with this email
      StudentProfile? profile;
      try {
        profile = await client.profile.getProfileByEmail(email);
      } catch (_) {
        profile = null;
      }

      if (profile != null) {
        // Update existing student with all new onboarding fields
        profile
          ..displayName = name
          ..department = dept.isNotEmpty ? dept : null
          ..year = _selectedYear
          ..bio = bio.isNotEmpty ? bio : profile.bio
          ..studySubjects = _selectedSubjects.toList()
          ..interests = _selectedInterests.toList();

        final updated = await client.profile.updateProfile(profile);
        currentProfileId = updated.id ?? profile.id;
      } else {
        // Create new profile with all fields
        final now = DateTime.now();
        final newProfile = await client.profile.createProfile(
          StudentProfile(
            displayName: name,
            email: email,
            department: dept.isNotEmpty ? dept : 'General Studies',
            year: _selectedYear,
            bio: bio.isNotEmpty
                ? bio
                : 'CampusLoop student from $dept',
            studySubjects: _selectedSubjects.toList(),
            interests: _selectedInterests.toList(),
            createdAt: now,
            updatedAt: now,
          ),
        );
        currentProfileId = newProfile.id;
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppShell()),
        );
      }
    } catch (e) {
      // Fallback: If network glitch, still allow student entry
      setState(() {
        _isLoading = false;
        _error = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome $name! Entering campus...'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: CampusTheme.primaryOrange,
          ),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AppShell()),
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
                              style: TextStyle(color: CampusTheme.primaryOrange),
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
                              color: CampusTheme.primaryOrange.withValues(alpha: 0.15),
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
                                        CampusTheme.darkCard.withValues(alpha: 0.95),
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
                                      color: CampusTheme.primaryOrange.withValues(alpha: 0.35),
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
                                    color: Colors.black.withValues(alpha: 0.70),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: CampusTheme.primaryOrange.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.school_rounded,
                                          color: CampusTheme.primaryOrange, size: 14),
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

                      // Complete Profile Registration & Sign In Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: CampusTheme.darkCard,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: CampusTheme.primaryOrange.withValues(alpha: 0.28),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: CampusTheme.primaryOrange.withValues(alpha: 0.10),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  const Text(
                                    'Student Profile & Sign In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Fill in your profile details to unlock personalized matches, clubs, and peers.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CampusTheme.textMuted,
                                ),
                              ),
                              const SizedBox(height: 20),

                              if (_error != null) ...[
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: CampusTheme.coral.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: CampusTheme.coral),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.error_outline,
                                          color: CampusTheme.coral, size: 20),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _error!,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],

                              // 1. Display Name
                              _buildLabel('Display Name'),
                              TextFormField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white),
                                textCapitalization: TextCapitalization.words,
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

                              // 2. Campus Email
                              _buildLabel('Campus Email'),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText: 'e.g. siddhi@campus.edu',
                                  prefixIcon: Icon(Icons.alternate_email_rounded,
                                      color: CampusTheme.softBlue),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // 3. Department & Year Row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Department
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _buildLabel('Department'),
                                        TextFormField(
                                          controller: _deptController,
                                          style: const TextStyle(
                                              color: Colors.white, fontSize: 13),
                                          decoration: InputDecoration(
                                            hintText: 'Department',
                                            prefixIcon: const Icon(
                                                Icons.school_rounded,
                                                color: CampusTheme.mint),
                                            suffixIcon: PopupMenuButton<String>(
                                              icon: const Icon(
                                                  Icons.arrow_drop_down_rounded,
                                                  color: CampusTheme.textMuted),
                                              onSelected: (dept) =>
                                                  _deptController.text = dept,
                                              itemBuilder: (ctx) =>
                                                  _commonDepartments
                                                      .map((d) => PopupMenuItem(
                                                            value: d,
                                                            child: Text(d),
                                                          ))
                                                      .toList(),
                                            ),
                                          ),
                                          validator: (v) => (v == null || v.trim().isEmpty)
                                              ? 'Required'
                                              : null,
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
                                          value: _selectedYear,
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

                              // 4. Bio
                              _buildLabel('Bio (About You)'),
                              TextFormField(
                                controller: _bioController,
                                maxLines: 2,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText:
                                      'A short intro about your projects, skills, or goals...',
                                  prefixIcon: Icon(Icons.info_outline_rounded,
                                      color: CampusTheme.lavender),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // 5. Study Subjects
                              _buildLabel('Study Subjects (Tap to select or add)'),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: _suggestedSubjects.map((s) {
                                  final isSelected =
                                      _selectedSubjects.contains(s);
                                  return FilterChip(
                                    label: Text(s),
                                    selected: isSelected,
                                    selectedColor: CampusTheme.primaryOrange,
                                    checkmarkColor: Colors.white,
                                    backgroundColor: CampusTheme.darkCardLight,
                                    labelStyle: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : CampusTheme.textMuted,
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
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                      decoration: const InputDecoration(
                                        hintText: 'Add custom subject...',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filled(
                                    onPressed: () {
                                      final text =
                                          _customSubjectCtrl.text.trim();
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

                              // 6. Interests & Hobbies
                              _buildLabel('Interests & Passions (Connect with peers)'),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: _suggestedInterests.map((interest) {
                                  final isSelected =
                                      _selectedInterests.contains(interest);
                                  return FilterChip(
                                    label: Text(interest),
                                    selected: isSelected,
                                    selectedColor: CampusTheme.coral,
                                    checkmarkColor: Colors.white,
                                    backgroundColor: CampusTheme.darkCardLight,
                                    labelStyle: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? Colors.white
                                          : CampusTheme.textMuted,
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
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 13),
                                      decoration: const InputDecoration(
                                        hintText: 'Add custom interest...',
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton.filled(
                                    onPressed: () {
                                      final text =
                                          _customInterestCtrl.text.trim();
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

                              // Submit Button
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed:
                                      _isLoading ? null : _handleEnterCampus,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CampusTheme.primaryOrange,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    shadowColor: CampusTheme.primaryOrange
                                        .withValues(alpha: 0.5),
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
                                      : const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Enter CampusLoop',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 0.3,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward_rounded,
                                                size: 20),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campus Highlights Ticker
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: CampusTheme.darkCardLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildHighlightItem(
                                Icons.bolt_rounded, '500+ Active', CampusTheme.primaryOrange),
                            Container(width: 1, height: 16, color: Colors.white12),
                            _buildHighlightItem(
                                Icons.event_rounded, 'Live Events', CampusTheme.coral),
                            Container(width: 1, height: 16, color: Colors.white12),
                            _buildHighlightItem(
                                Icons.groups_rounded, 'Student Clubs', CampusTheme.mint),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Footer
                      Text(
                        'Powered by Serverpod Cloud · Verified Campus Network',
                        style: TextStyle(
                          fontSize: 11,
                          color: CampusTheme.textMuted.withValues(alpha: 0.6),
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
