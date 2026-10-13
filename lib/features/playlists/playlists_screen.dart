import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/database_service.dart';
import '../../models/playlist.dart';
import '../../widgets/bottom_nav.dart';
import 'widgets/playlist_card.dart';

class PlaylistsScreen extends StatefulWidget {
  const PlaylistsScreen({super.key});

  @override
  State<PlaylistsScreen> createState() => _PlaylistsScreenState();
}

class _PlaylistsScreenState extends State<PlaylistsScreen> {
  final DatabaseService _database = DatabaseService();
  List<Playlist> _playlists = const <Playlist>[];

  @override
  void initState() {
    super.initState();
    _loadPlaylists();
  }

  Future<void> _loadPlaylists() async {
    await _database.initialize();
    final playlists = await _database.getPlaylists();
    if (!mounted) {
      return;
    }
    setState(() => _playlists = playlists);
  }

  Future<void> _createPlaylist() async {
    final nameController = TextEditingController();
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Новый плейлист',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Название плейлиста',
                  hintStyle: const TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.panel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(nameController.text),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Создать'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    final trimmed = result?.trim() ?? '';
    if (trimmed.isEmpty) {
      return;
    }

    final playlist = Playlist(
      id: 'playlist-${DateTime.now().millisecondsSinceEpoch}',
      name: trimmed,
      trackIds: const <String>[],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _database.savePlaylist(playlist);
    await _loadPlaylists();
  }

  Future<void> _deletePlaylist(Playlist playlist) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text(
          'Удалить плейлист?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Плейлист "${playlist.name}" будет удалён.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _database.deletePlaylist(playlist.id);
      await _loadPlaylists();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Плейлисты',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _createPlaylist,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Создать'),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Expanded(
                child: _playlists.isEmpty
                    ? const Center(
                        child: Text(
                          'Плейлисты появятся здесь после создания',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        itemCount: _playlists.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final playlist = _playlists[index];
                          return GestureDetector(
                            onLongPress: () => _deletePlaylist(playlist),
                            child: PlaylistCard(
                              name: playlist.name,
                              count: playlist.trackIds.length,
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 2),
    );
  }
}
