import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:campusloop_client/campusloop_client.dart';
import '../../models/study_collab_models.dart';
import '../../theme/campus_theme.dart';
import '../../main.dart';

/// Full-featured Virtual Study Room and Session Scheduler.
/// Supports Pomodoro Focus Timer, Google Meet/Zoom video rooms, and scheduled study sessions.
class StudyRoomScreen extends StatefulWidget {
  final StudentProfile partner;
  final StudentProfile? currentProfile;
  final String? initialSubject;

  const StudyRoomScreen({
    super.key,
    required this.partner,
    this.currentProfile,
    this.initialSubject,
  });

  @override
  State<StudyRoomScreen> createState() => _StudyRoomScreenState();
}

class _StudyRoomScreenState extends State<StudyRoomScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // -------------------------------------------------------------
  // ⏱️ Pomodoro Timer State
  // -------------------------------------------------------------
  static const int _focusSeconds = 25 * 60;
  static const int _shortBreakSeconds = 5 * 60;
  static const int _longBreakSeconds = 15 * 60;

  int _selectedDuration = _focusSeconds;
  int _secondsRemaining = _focusSeconds;
  bool _isRunning = false;
  Timer? _timer;
  int _completedPomodoros = 0;
  String _timerMode = 'Focus'; // 'Focus', 'Short Break', 'Long Break'

  // -------------------------------------------------------------
  // 📹 Meeting Room State
  // -------------------------------------------------------------
  final TextEditingController _meetingLinkController = TextEditingController();

  // -------------------------------------------------------------
  // 📅 Schedule State
  // -------------------------------------------------------------
  List<ScheduledStudySession> _scheduledSessions = [];
  bool _isLoadingSessions = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _meetingLinkController.text =
        'https://meet.google.com/new'; // Instant Google Meet creation URL
    _loadScheduledSessions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    _meetingLinkController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------
  // Timer Methods
  // -------------------------------------------------------------
  void _setTimerMode(String mode, int totalSeconds) {
    _timer?.cancel();
    setState(() {
      _timerMode = mode;
      _selectedDuration = totalSeconds;
      _secondsRemaining = totalSeconds;
      _isRunning = false;
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (_secondsRemaining > 0) {
          setState(() => _secondsRemaining--);
        } else {
          _timer?.cancel();
          setState(() {
            _isRunning = false;
            if (_timerMode == 'Focus') {
              _completedPomodoros++;
              _setTimerMode('Short Break', _shortBreakSeconds);
            } else {
              _setTimerMode('Focus', _focusSeconds);
            }
          });
          HapticFeedback.vibrate();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                _timerMode == 'Short Break'
                    ? '🎉 Focus sprint completed! Enjoy a 5-minute break.'
                    : '⚡ Break over! Ready for another study sprint?',
              ),
              backgroundColor: CampusTheme.mint,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      });
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = _selectedDuration;
      _isRunning = false;
    });
  }

  String _formatTime(int totalSeconds) {
    final m = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // -------------------------------------------------------------
  // Sessions Management
  // -------------------------------------------------------------
  Future<void> _loadScheduledSessions() async {
    final userId = currentProfileId ?? 0;
    final list = await ScheduledStudySession.loadSessions(userId);
    if (mounted) {
      setState(() {
        _scheduledSessions = list;
        _isLoadingSessions = false;
      });
    }
  }

  void _showScheduleDialog() {
    final topicCtrl = TextEditingController(
      text: widget.initialSubject != null
          ? '${widget.initialSubject} Prep'
          : 'Exam Revision',
    );
    final subjectCtrl = TextEditingController(
      text: widget.initialSubject ??
          (widget.partner.studySubjects.isNotEmpty
              ? widget.partner.studySubjects.first
              : 'General Study'),
    );
    final linkCtrl = TextEditingController(text: _meetingLinkController.text);
    DateTime selectedDate = DateTime.now().add(const Duration(hours: 2));
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);
    int duration = 60;
    bool isOnline = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: CampusTheme.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Schedule Study Session',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Invite ${widget.partner.displayName} to study together',
                  style: const TextStyle(
                      fontSize: 13, color: CampusTheme.textMuted),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: topicCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Session Topic / Goal',
                    prefixIcon: Icon(Icons.menu_book_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Subject / Course',
                    prefixIcon: Icon(Icons.school_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 60)),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = DateTime(
                                  picked.year,
                                  picked.month,
                                  picked.day,
                                  selectedTime.hour,
                                  selectedTime.minute,
                                ));
                          }
                        },
                        icon: const Icon(Icons.calendar_today_rounded,
                            size: 16),
                        label: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTime,
                          );
                          if (picked != null) {
                            setModalState(() {
                              selectedTime = picked;
                              selectedDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                picked.hour,
                                picked.minute,
                              );
                            });
                          }
                        },
                        icon: const Icon(Icons.access_time_rounded, size: 16),
                        label: Text(selectedTime.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Text('Duration:',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: duration,
                      dropdownColor: CampusTheme.darkCardLight,
                      items: [30, 45, 60, 90, 120]
                          .map((d) => DropdownMenuItem(
                                value: d,
                                child: Text('$d mins',
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) setModalState(() => duration = v);
                      },
                    ),
                    const Spacer(),
                    ChoiceChip(
                      label: const Text('Online'),
                      selected: isOnline,
                      onSelected: (v) => setModalState(() => isOnline = true),
                    ),
                    const SizedBox(width: 6),
                    ChoiceChip(
                      label: const Text('In-Person'),
                      selected: !isOnline,
                      onSelected: (v) => setModalState(() => isOnline = false),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: linkCtrl,
                  decoration: InputDecoration(
                    labelText: isOnline
                        ? 'Meeting Link (Google Meet / Zoom)'
                        : 'Campus Location (e.g. Central Library 2nd Floor)',
                    prefixIcon: Icon(
                      isOnline ? Icons.video_call_rounded : Icons.place_rounded,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (topicCtrl.text.trim().isEmpty) return;
                      final newSession = ScheduledStudySession(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: topicCtrl.text.trim(),
                        subject: subjectCtrl.text.trim(),
                        partnerId: widget.partner.id ?? 0,
                        partnerName: widget.partner.displayName,
                        scheduledAt: selectedDate,
                        durationMinutes: duration,
                        meetingLink: linkCtrl.text.trim(),
                        isOnline: isOnline,
                      );
                      final userId = currentProfileId ?? 0;
                      await ScheduledStudySession.saveSession(
                          userId, newSession);
                      Navigator.pop(ctx);
                      _loadScheduledSessions();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '📅 Session scheduled with ${widget.partner.displayName}!',
                            ),
                            backgroundColor: CampusTheme.mint,
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text('Confirm Schedule'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------------
  // UI Build
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CampusTheme.darkSurface,
      appBar: AppBar(
        backgroundColor: CampusTheme.darkSurface,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Virtual Study Room',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Text(
              'Collab Space with ${widget.partner.displayName}',
              style: const TextStyle(fontSize: 12, color: CampusTheme.mint),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: CampusTheme.primaryOrange,
          indicatorWeight: 3,
          labelColor: CampusTheme.primaryOrange,
          unselectedLabelColor: CampusTheme.textMuted,
          tabs: const [
            Tab(icon: Icon(Icons.timer_rounded), text: 'Pomodoro'),
            Tab(icon: Icon(Icons.video_camera_front_rounded), text: 'Meet Link'),
            Tab(icon: Icon(Icons.calendar_month_rounded), text: 'Schedule'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPomodoroTab(),
          _buildMeetingLinkTab(),
          _buildScheduleTab(),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 1. Pomodoro Tab
  // -------------------------------------------------------------
  Widget _buildPomodoroTab() {
    final progress = _secondsRemaining / _selectedDuration;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          // Partner Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: CampusTheme.darkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: CampusTheme.primaryOrange.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      CampusTheme.primaryOrange.withValues(alpha: 0.2),
                  child: Text(
                    widget.partner.displayName.isNotEmpty
                        ? widget.partner.displayName[0].toUpperCase()
                        : 'S',
                    style: const TextStyle(
                      color: CampusTheme.primaryOrange,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Studying with ${widget.partner.displayName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.initialSubject != null
                            ? 'Target: ${widget.initialSubject}'
                            : (widget.partner.studySubjects.isNotEmpty
                                ? 'Target: ${widget.partner.studySubjects.join(', ')}'
                                : 'Co-study Focus Session'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CampusTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: CampusTheme.mint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.headphones_rounded,
                          size: 13, color: CampusTheme.mint),
                      SizedBox(width: 4),
                      Text(
                        'Live',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: CampusTheme.mint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Mode Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _modeButton('Focus', _focusSeconds),
              const SizedBox(width: 8),
              _modeButton('Short Break', _shortBreakSeconds),
              const SizedBox(width: 8),
              _modeButton('Long Break', _longBreakSeconds),
            ],
          ),
          const SizedBox(height: 36),

          // Circular Timer Display
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: CampusTheme.darkCardLight,
                  color: _timerMode == 'Focus'
                      ? CampusTheme.primaryOrange
                      : CampusTheme.mint,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatTime(_secondsRemaining),
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _timerMode.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: _timerMode == 'Focus'
                          ? CampusTheme.primaryOrange
                          : CampusTheme.mint,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 36),

          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Reset
              IconButton.filledTonal(
                onPressed: _resetTimer,
                icon: const Icon(Icons.replay_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: CampusTheme.darkCardLight,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(width: 20),
              // Play / Pause
              ElevatedButton.icon(
                onPressed: _toggleTimer,
                icon: Icon(
                  _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 28,
                ),
                label: Text(
                  _isRunning ? 'Pause' : 'Start Focus',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _timerMode == 'Focus'
                      ? CampusTheme.primaryOrange
                      : CampusTheme.mint,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Streak Counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: CampusTheme.darkCard,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_fire_department_rounded,
                    color: CampusTheme.amberOrange, size: 20),
                const SizedBox(width: 8),
                Text(
                  '$_completedPomodoros Pomodoros completed today',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(String mode, int seconds) {
    final isSelected = _timerMode == mode;
    return ChoiceChip(
      label: Text(mode),
      selected: isSelected,
      selectedColor: mode == 'Focus'
          ? CampusTheme.primaryOrange.withValues(alpha: 0.25)
          : CampusTheme.mint.withValues(alpha: 0.25),
      labelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: isSelected
            ? (mode == 'Focus' ? CampusTheme.primaryOrange : CampusTheme.mint)
            : CampusTheme.textMuted,
      ),
      side: BorderSide(
        color: isSelected
            ? (mode == 'Focus' ? CampusTheme.primaryOrange : CampusTheme.mint)
            : Colors.transparent,
      ),
      backgroundColor: CampusTheme.darkCard,
      onSelected: (_) => _setTimerMode(mode, seconds),
    );
  }

  // -------------------------------------------------------------
  // 2. Meet Link Tab
  // -------------------------------------------------------------
  Widget _buildMeetingLinkTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CampusTheme.primaryOrange.withValues(alpha: 0.2),
                  CampusTheme.darkCard,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: CampusTheme.primaryOrange.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.video_call_rounded,
                        color: CampusTheme.primaryOrange, size: 26),
                    SizedBox(width: 10),
                    Text(
                      'Live Video & Audio Room',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Quickly generate or paste a Google Meet, Zoom, or Discord link to jump into a call with ${widget.partner.displayName}.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Meeting Link URL',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          TextField(
            controller: _meetingLinkController,
            decoration: InputDecoration(
              hintText: 'https://meet.google.com/...',
              prefixIcon:
                  const Icon(Icons.link_rounded, color: CampusTheme.mint),
              suffixIcon: IconButton(
                icon: const Icon(Icons.copy_rounded, size: 18),
                tooltip: 'Copy Link',
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(text: _meetingLinkController.text.trim()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('📋 Meeting link copied to clipboard!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Preset Quick Buttons
          const Text(
            'Quick Room Launchers',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: CampusTheme.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _meetingLinkController.text =
                          'https://meet.google.com/new';
                    });
                    Clipboard.setData(
                      const ClipboardData(text: 'https://meet.google.com/new'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            '📋 Google Meet URL set & copied! Open in browser.'),
                        backgroundColor: CampusTheme.mint,
                      ),
                    );
                  },
                  icon: const Icon(Icons.video_camera_back_rounded, size: 16),
                  label: const Text('Google Meet'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    final customCode =
                        'campusloop-${widget.partner.id ?? 1}-${DateTime.now().minute}';
                    final jitsiUrl = 'https://meet.jit.si/$customCode';
                    setState(() {
                      _meetingLinkController.text = jitsiUrl;
                    });
                    Clipboard.setData(ClipboardData(text: jitsiUrl));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('📋 Instant Room Link copied: $jitsiUrl'),
                        backgroundColor: CampusTheme.mint,
                      ),
                    );
                  },
                  icon: const Icon(Icons.groups_rounded, size: 16),
                  label: const Text('Instant Room'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // One-tap Action Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: CampusTheme.darkCard,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.tips_and_updates_rounded,
                        color: CampusTheme.amberOrange, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Study Room Pro-Tips',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Share screen to review code, formulas, or lecture slides.\n'
                  '• Keep cameras on for accountability during Pomodoro sprints.\n'
                  '• Take 5-minute verbal debriefs at the end of each session.',
                  style: TextStyle(
                    fontSize: 12,
                    color: CampusTheme.textMuted,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------
  // 3. Schedule Tab
  // -------------------------------------------------------------
  Widget _buildScheduleTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Sessions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showScheduleDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Schedule'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CampusTheme.primaryOrange,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoadingSessions
              ? const Center(child: CircularProgressIndicator())
              : _scheduledSessions.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_available_rounded,
                              size: 48,
                              color: CampusTheme.textMuted.withValues(alpha: 0.5)),
                          const SizedBox(height: 12),
                          const Text(
                            'No study sessions scheduled yet.',
                            style: TextStyle(
                                fontSize: 14, color: CampusTheme.textMuted),
                          ),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: _showScheduleDialog,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Plan a session now'),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _scheduledSessions.length,
                      itemBuilder: (ctx, i) {
                        final session = _scheduledSessions[i];
                        final isUpcoming =
                            session.scheduledAt.isAfter(DateTime.now());

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          color: CampusTheme.darkCard,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: isUpcoming
                                  ? CampusTheme.mint.withValues(alpha: 0.3)
                                  : Colors.white10,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isUpcoming
                                            ? CampusTheme.mint
                                                .withValues(alpha: 0.15)
                                            : Colors.white10,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        session.subject,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isUpcoming
                                              ? CampusTheme.mint
                                              : CampusTheme.textMuted,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                          Icons.delete_outline_rounded,
                                          size: 18,
                                          color: CampusTheme.coral),
                                      onPressed: () async {
                                        final userId = currentProfileId ?? 0;
                                        await ScheduledStudySession
                                            .deleteSession(userId, session.id);
                                        _loadScheduledSessions();
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  session.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time_rounded,
                                        size: 14, color: CampusTheme.textMuted),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${session.scheduledAt.day}/${session.scheduledAt.month} at ${session.scheduledAt.hour.toString().padLeft(2, '0')}:${session.scheduledAt.minute.toString().padLeft(2, '0')} (${session.durationMinutes}m)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CampusTheme.textMuted,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Icon(
                                      session.isOnline
                                          ? Icons.video_call_rounded
                                          : Icons.place_rounded,
                                      size: 14,
                                      color: CampusTheme.amberOrange,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      session.isOnline ? 'Online' : 'In-Person',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: CampusTheme.amberOrange,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                if (session.meetingLink.isNotEmpty) ...[
                                  const SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: session.meetingLink));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '📋 Copied: ${session.meetingLink}',
                                          ),
                                          backgroundColor: CampusTheme.mint,
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: CampusTheme.darkCardLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.link_rounded,
                                              size: 14, color: CampusTheme.mint),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              session.meetingLink,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white70,
                                              ),
                                            ),
                                          ),
                                          const Icon(Icons.copy_rounded,
                                              size: 13,
                                              color: CampusTheme.textMuted),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
