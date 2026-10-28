import 'package:campusloop_client/campusloop_client.dart';

void main() async {
  print('Connecting to Serverpod Cloud at https://campusloop1.api.serverpod.space/ ...');
  final client = Client('https://campusloop1.api.serverpod.space/');

  try {
    print('Testing live connection to cloud server...');
    final updates = await client.campusUpdate.listUpdates(limit: 5, offset: 0);
    print('Fetched ${updates.length} updates from cloud:');
    for (final u in updates) {
      print(' - [${u.category}] ${u.title}');
    }

    final events = await client.event.listEvents(limit: 5, offset: 0);
    print('\nFetched ${events.length} events from cloud:');
    for (final e in events) {
      print(' - [${e.category}] ${e.title} at ${e.venue}');
    }

    final communities = await client.community.listCommunities(limit: 5, offset: 0);
    print('\nFetched ${communities.length} communities from cloud:');
    for (final c in communities) {
      print(' - ${c.name} (${c.category})');
    }

    print('\nSUCCESS: Serverpod Cloud backend is live and answering queries perfectly!');
  } catch (e, st) {
    print('Error connecting to Serverpod Cloud: $e');
    print(st);
  } finally {
    client.close();
  }
}
