import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:campusloop_server/server.dart';

/// CampusLoop backend server entry point.
/// Run with: dart bin/main.dart --apply-migrations
void main(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  // Initialize authentication services using Serverpod's built-in
  // JWT-based auth — no external auth providers.
  pod.initializeAuthServices(
    tokenManagerBuilders: [
      JwtConfig(
        refreshTokenHashPepper:
            pod.getPassword('jwtRefreshTokenHashPepper') ??
                'dev-pepper-fallback',
        algorithm: JwtAlgorithm.hmacSha512(
          SecretKey(
            pod.getPassword('jwtHmacSha512PrivateKey') ??
                'dev-hmac-key-fallback',
          ),
        ),
      ),
    ],
  );

  await pod.start();
}
