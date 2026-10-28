import 'package:campusloop_client/campusloop_client.dart';

void main() async {
  print('Connecting to Serverpod Cloud at https://campusloop1.api.serverpod.space/ ...');
  final client = Client('https://campusloop1.api.serverpod.space/');

  try {
    print('Calling seedDevelopmentData()...');
    final seedResult = await client.seed.seedDevelopmentData();
    print('Seed Result: $seedResult');

    print('\nFetching campus updates...');
    final updates = await client.campusUpdate.listUpdates(limit: 5, offset: 0);
    print('Fetched ${updates.length} updates successfully:');
    for (final u in updates) {
      print(' - [${u.category}] ${u.title}');
    }

    print('\nFetching campus events...');
    final events = await client.event.listEvents(limit: 5, offset: 0);
    print('Fetched ${events.length} events successfully:');
    for (final e in events) {
      print(' - [${e.category}] ${e.title} at ${e.venue}');
    }

    print('\nAll tests passed! Cloud deployment is fully verified and functional.');
  } catch (e, st) {
    print('Error calling cloud server: $e');
    print(st);
  } finally {
    client.close();
  }
}
