import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Endpoint for seeding development/demo data.
///
/// This endpoint creates sample records for testing purposes.
/// All seeded data is clearly marked as development sample data.
/// This endpoint should be disabled or removed in production.
class SeedEndpoint extends Endpoint {
  /// Seed development sample data.
  /// Returns a summary message.
  Future<String> seedDevelopmentData(Session session) async {
    final now = DateTime.now();

    // ── Sample Student Profiles ──
    final profiles = <StudentProfile>[];
    final profileData = [
      {
        'name': 'Aarav Sharma',
        'email': 'aarav.sharma@campus.edu',
        'dept': 'Computer Science',
        'year': 3,
        'subjects': ['Data Structures', 'Machine Learning', 'Web Development'],
        'interests': ['Coding', 'AI', 'Open Source'],
      },
      {
        'name': 'Priya Patel',
        'email': 'priya.patel@campus.edu',
        'dept': 'Electronics',
        'year': 2,
        'subjects': ['Circuit Design', 'Signal Processing', 'Machine Learning'],
        'interests': ['Robotics', 'IoT', 'Music'],
      },
      {
        'name': 'Rohan Gupta',
        'email': 'rohan.gupta@campus.edu',
        'dept': 'Computer Science',
        'year': 4,
        'subjects': ['Web Development', 'Cloud Computing', 'Databases'],
        'interests': ['Startups', 'Gaming', 'Photography'],
      },
      {
        'name': 'Ananya Singh',
        'email': 'ananya.singh@campus.edu',
        'dept': 'Data Science',
        'year': 2,
        'subjects': ['Statistics', 'Machine Learning', 'Python Programming'],
        'interests': ['Data Viz', 'Writing', 'Volunteering'],
      },
      {
        'name': 'Dev Mehta',
        'email': 'dev.mehta@campus.edu',
        'dept': 'Mechanical',
        'year': 3,
        'subjects': ['Thermodynamics', 'CAD Design', 'Robotics'],
        'interests': ['3D Printing', 'Hiking', 'Chess'],
      },
    ];

    for (final data in profileData) {
      // Skip if email already exists
      final existing = await StudentProfile.db.find(
        session,
        where: (t) => t.email.equals(data['email'] as String),
      );
      if (existing.isNotEmpty) {
        profiles.add(existing.first);
        continue;
      }

      final profile = StudentProfile(
        displayName: data['name'] as String,
        email: data['email'] as String,
        department: data['dept'] as String,
        year: data['year'] as int,
        bio: '[DEV SAMPLE] Student at Campus University',
        studySubjects: List<String>.from(data['subjects'] as List),
        interests: List<String>.from(data['interests'] as List),
        createdAt: now,
        updatedAt: now,
      );
      profiles.add(await StudentProfile.db.insertRow(session, profile));
    }

    // ── Campus Events ──
    final eventData = [
      {
        'title': 'Tech Innovation Hackathon 2026',
        'desc': 'A 48-hour hackathon to build innovative campus solutions. '
            'Teams of 2-4 students. Prizes worth ₹50,000.',
        'cat': 'Technology',
        'venue': 'Innovation Lab, Block A',
        'days': 14,
        'hours': 8,
      },
      {
        'title': 'Flutter Workshop: Build Your First App',
        'desc': 'Hands-on workshop covering Flutter basics, widgets, '
            'state management, and deploying your first app.',
        'cat': 'Workshop',
        'venue': 'CS Lab 3, Block B',
        'days': 7,
        'hours': 4,
      },
      {
        'title': 'Campus Cultural Festival — Rhythm 2026',
        'desc': 'Annual cultural festival featuring music, dance, drama, '
            'art exhibitions, and food stalls from student clubs.',
        'cat': 'Cultural',
        'venue': 'Central Amphitheatre',
        'days': 21,
        'hours': 6,
      },
      {
        'title': 'Career Fair: Meet Industry Leaders',
        'desc': 'Connect with recruiters from 30+ companies. Bring your '
            'resume and portfolio. Pre-registration required.',
        'cat': 'Career',
        'venue': 'Convention Hall',
        'days': 10,
        'hours': 3,
      },
      {
        'title': 'AI & Data Science Seminar',
        'desc': 'Expert talks on the latest in AI, LLMs, and data science '
            'applications in industry and research.',
        'cat': 'Technology',
        'venue': 'Auditorium, Block C',
        'days': 5,
        'hours': 2,
      },
    ];

    for (final data in eventData) {
      final eventDateTime = now.add(Duration(
        days: data['days'] as int,
        hours: data['hours'] as int,
      ));

      final event = CampusEvent(
        title: data['title'] as String,
        description: data['desc'] as String,
        category: data['cat'] as String,
        venue: data['venue'] as String,
        organizer: profiles.first.displayName,
        organizerProfileId: profiles.first.id!,
        dateTime: eventDateTime,
        createdAt: now,
        updatedAt: now,
      );
      await CampusEvent.db.insertRow(session, event);
    }

    // ── Sample Communities ──
    final communityData = [
      {
        'name': 'Flutter Developers Club',
        'desc': 'A community for Flutter enthusiasts to share projects, '
            'tips, and collaborate on mobile app development.',
        'cat': 'Technology',
        'interests': ['Flutter', 'Dart', 'Mobile Dev'],
      },
      {
        'name': 'AI Research Group',
        'desc': 'Discuss papers, share implementations, and collaborate '
            'on AI and machine learning projects.',
        'cat': 'Research',
        'interests': ['AI', 'Machine Learning', 'Deep Learning'],
      },
      {
        'name': 'Campus Photography Society',
        'desc': 'Share your campus shots, learn photography techniques, '
            'and participate in photo walks and contests.',
        'cat': 'Creative',
        'interests': ['Photography', 'Art', 'Design'],
      },
      {
        'name': 'Entrepreneurship Cell',
        'desc': 'For aspiring entrepreneurs — pitch ideas, find co-founders, '
            'and learn about building startups.',
        'cat': 'Business',
        'interests': ['Startups', 'Business', 'Innovation'],
      },
    ];

    for (final data in communityData) {
      // Skip if name already exists
      final existing = await Community.db.find(
        session,
        where: (t) => t.name.equals(data['name'] as String),
      );
      if (existing.isNotEmpty) continue;

      final community = Community(
        name: data['name'] as String,
        description: data['desc'] as String,
        category: data['cat'] as String,
        interests: List<String>.from(data['interests'] as List),
        creatorProfileId: profiles.first.id!,
        memberCount: 1,
        createdAt: now,
        updatedAt: now,
      );
      final created = await Community.db.insertRow(session, community);

      // Add creator as admin member
      await CommunityMembership.db.insertRow(
        session,
        CommunityMembership(
          communityId: created.id!,
          profileId: profiles.first.id!,
          role: 'admin',
          joinedAt: now,
        ),
      );
    }

    // ── Campus Updates ──
    final updateData = [
      {
        'title': 'Mid-Semester Exam Schedule Released',
        'content': 'The mid-semester examination schedule for all departments '
            'has been published. Check the academic portal for your '
            'personalized timetable. Exam dates: Nov 15-25.',
        'cat': 'Academic',
        'priority': 'high',
      },
      {
        'title': 'Library Extended Hours During Exams',
        'content': 'The central library will remain open until 11 PM '
            'during the examination period (Nov 10 - Nov 30). '
            'Student ID required for entry after 8 PM.',
        'cat': 'Facility',
        'priority': 'normal',
      },
      {
        'title': 'Summer Internship Applications Open',
        'content': 'Applications for summer 2027 internships are now open. '
            'Visit the placement cell or check the portal for '
            'participating companies and deadlines.',
        'cat': 'Opportunity',
        'priority': 'high',
      },
      {
        'title': 'Campus Wi-Fi Upgrade Notice',
        'content': 'The campus Wi-Fi network will be upgraded this weekend. '
            'Expect brief outages on Saturday between 2-6 AM. '
            'New network: CampusNet-5G.',
        'cat': 'Notice',
        'priority': 'normal',
      },
    ];

    for (final data in updateData) {
      final update = CampusUpdate(
        title: data['title'] as String,
        content: data['content'] as String,
        category: data['cat'] as String,
        authorProfileId: profiles.first.id!,
        priority: data['priority'] as String,
        isPublished: true,
        publishedAt: now,
        createdAt: now,
        updatedAt: now,
      );
      await CampusUpdate.db.insertRow(session, update);
    }

    return 'Development seed data created: '
        '${profiles.length} profiles, '
        '${eventData.length} events, '
        '${communityData.length} communities, '
        '${updateData.length} campus updates.';
  }
}
