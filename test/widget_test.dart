import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:arvex/app.dart';
import 'package:arvex/models/playlist.dart';
import 'package:arvex/models/track.dart';
import 'package:arvex/widgets/bottom_nav.dart';

void main() {
  testWidgets('Arvex app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    await tester.pump();

    expect(find.text('Arvex'), findsOneWidget);
  });

  testWidgets('Bottom navigation contains the three main tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: BottomNav(currentIndex: 0)),
    );

    expect(find.text('Главное'), findsOneWidget);
    expect(find.text('Музыка'), findsOneWidget);
    expect(find.text('Плейлисты'), findsOneWidget);
  });

  group('Arvex library logic', () {
    test('track search matches title, artist and album', () {
      const track = Track(
        id: 't-1',
        title: 'Midnight Echo',
        artist: 'Aster Vale',
        album: 'Night Signals',
        genre: 'Electronic',
        year: 2024,
        trackNumber: 1,
        duration: Duration(minutes: 2, seconds: 45),
        dateAdded: null,
        fileHash: 'hash-1',
        path: '/music/midnight_echo.mp3',
      );

      expect(track.matchesQuery('midnight'), isTrue);
      expect(track.matchesQuery('aster'), isTrue);
      expect(track.matchesQuery('signals'), isTrue);
      expect(track.matchesQuery('unknown'), isFalse);
    });

    test('playlist adds a track only once', () {
      final playlist = const Playlist(
        id: 'playlist-1',
        name: 'Night Run',
        trackIds: ['track-1'],
        createdAt: null,
        updatedAt: null,
      );

      final added = playlist.addTrack('track-1').addTrack('track-2');

      expect(added.trackIds, ['track-1', 'track-2']);
      expect(added.removeTrack('track-1').trackIds, ['track-2']);
    });
  });
}
