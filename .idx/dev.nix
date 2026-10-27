# Project IDX environment configuration for CampusLoop
# Flutter + Serverpod + PostgreSQL — zero local installation required
{ pkgs, ... }: {
  channel = "stable-24.11";

  packages = [
    pkgs.flutter
    pkgs.dart
    pkgs.postgresql_15
    pkgs.coreutils
    pkgs.procps
  ];

  env = {};

  idx = {
    extensions = [
      "Dart-Code.flutter"
      "Dart-Code.dart-code"
    ];

    workspace = {
      onCreate = {
        install-serverpod = ''
          dart pub global activate serverpod_cli
        '';
        postgres-init = ''
          if [ ! -d "$HOME/.postgres" ]; then
            echo "Initializing PostgreSQL database..."
            initdb -D "$HOME/.postgres"
            echo "listen_addresses = '127.0.0.1'" >> "$HOME/.postgres/postgresql.conf"
            echo "port = 5432" >> "$HOME/.postgres/postgresql.conf"
          fi
        '';
        install-deps = ''
          cd campusloop_server && dart pub get
          cd ../campusloop_client && dart pub get
          cd ../campusloop_flutter && flutter pub get
        '';
      };

      onStart = {
        start-postgres = ''
          pg_ctl -D "$HOME/.postgres" -l "$HOME/.postgres/postgres.log" start || true
          sleep 2
          createdb -h localhost -p 5432 campusloop 2>/dev/null || true
          createuser -h localhost -p 5432 postgres 2>/dev/null || true
          psql -h localhost -p 5432 -c "ALTER USER postgres PASSWORD 'campusloop_dev_password';" 2>/dev/null || true
        '';
      };
    };

    previews = {
      enable = true;
      previews = {
        web = {
          command = [
            "flutter"
            "run"
            "--machine"
            "-d"
            "web-server"
            "--web-hostname"
            "0.0.0.0"
            "--web-port"
            "$PORT"
          ];
          manager = "web";
          cwd = "campusloop_flutter";
        };
      };
    };
  };
}
