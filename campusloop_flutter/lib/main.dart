import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:campusloop_client/campusloop_client.dart';
import 'screens/app_shell.dart';
import 'screens/auth/login_screen.dart';
import 'theme/campus_theme.dart';

/// Global Serverpod client instance.
/// Configure the host to point to your running Serverpod backend.
late Client client;

/// Currently logged-in profile ID (development session).
/// In production, this would come from Serverpod's auth session.
int? currentProfileId;

void main() {
  // Production Serverpod Cloud backend URL with development override support.
  // Defaults to production Serverpod Cloud: https://api.campusloop.serverpod.cloud/
  const serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'https://api.campusloop.serverpod.cloud/',
  );

  client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(const CampusLoopApp());
}

/// Root CampusLoop application widget.
class CampusLoopApp extends StatelessWidget {
  const CampusLoopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusLoop',
      debugShowCheckedModeBanner: false,
      theme: CampusTheme.lightTheme,
      darkTheme: CampusTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const LoginScreen(),
    );
  }
}
