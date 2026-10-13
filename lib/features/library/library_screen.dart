import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/providers/player_providers.dart';
import '../../core/router/app_router.dart';
import '../../core/services/import_service.dart';
import '../../core/services/permission_service.dart';
import '../../features/player/mini_player.dart';
import '../../models/track.dart';
import '../../widgets/bottom_nav.dart';
import 'widgets/genre_filter.dart';
import 'widgets/search_bar.dart';
import 'widgets/track_tile.dart';

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  String _query = '';
  String _selectedGenre = 'Все';

  @override
  Widget build(BuildContext context) {
    final tracks = ref.watch(libraryTracksProvider);
    final genres = ['Все', ...tracks.map((e) => e.genre).toSet()];
    final filteredTracks = tracks.where((track) {
      final matchesQuery =
          track.title.toLowerCase().contains(_query.toLowerCase()) ||
          track.artist.toLowerCase().contains(_query.toLowerCase()) ||
          track.album.toLowerCase().contains(_query.toLowerCase());
      final matchesGenre =
          _selectedGenre == 'Все' || track.genre == _selectedGenre;
      return matchesQuery && matchesGenre;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Музыка',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final granted = await const PermissionService()
                          .requestAudioPermissions();
                      if (!granted) {
                        return;
                      }

                      final importService = const ImportService();
                      var paths = await importService.pickAudioFiles();

                      if (paths.isEmpty && Platform.isAndroid) {
                        final musicDirectory = '/storage/emulated/0/Music';
                        paths = await importService.scanDirectory(
                          musicDirectory,
                        );
                      }

                      if (paths.isEmpty) {
                        return;
                      }

                      final tracks = paths.map((path) {
                        final fileName = path
                            .split(Platform.pathSeparator)
                            .last;
                        final title = fileName.replaceAll(
                          RegExp(r'\.[^.]+$'),
                          '',
                        );
                        return Track(
                          id: path,
                          title: title,
                          artist: 'Local library',
                          album: 'Imported',
                          genre: 'Local',
                          year: DateTime.now().year,
                          trackNumber: 1,
                          duration: const Duration(minutes: 3),
                          dateAdded: DateTime.now(),
                          fileHash: path,
                          path: path,
                        );
                      }).toList();

                      await ref
                          .read(libraryTracksProvider.notifier)
                          .addTracks(tracks);

                      final library = ref.read(libraryTracksProvider);
                      if (library.isNotEmpty) {
                        await ref
                            .read(playerControllerProvider.notifier)
                            .playTrack(library.first, library);
                      }
                    },
                    icon: const Icon(
                      Icons.file_upload_outlined,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ArvexSearchBar(
                hintText: 'Поиск по названию, артисту, альбому',
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 16),
              GenreFilter(
                genres: genres,
                selected: _selectedGenre,
                onSelected: (value) => setState(() => _selectedGenre = value),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filteredTracks.isEmpty
                    ? const Center(
                        child: Text(
                          'Ничего не найдено',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredTracks.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final track = filteredTracks[index];
                          return GestureDetector(
                            onTap: () async {
                              await ref
                                  .read(playerControllerProvider.notifier)
                                  .playTrack(track, filteredTracks);
                              if (context.mounted) {
                                context.push(AppRoutes.player);
                              }
                            },
                            child: TrackTile(track: track),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (ref.watch(playerControllerProvider).currentTrack != null)
            const MiniPlayer(),
          const BottomNav(currentIndex: 1),
        ],
      ),
    );
  }
}
