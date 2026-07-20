import 'package:flutter/material.dart';
import '../../../../core/theme/glossy_music_theme.dart';
import '../../domain/entities/sound_preset_entity.dart';

class MusicNotifier extends ChangeNotifier {
  bool _isDarkMode = true;
  bool _isPlaying = false;
  bool _isGenerating = false;
  String _currentTrackTitle = "Cosmic Reverie";
  String _currentArtist = "AI Soundscape Gen v2";
  
  List<SoundPresetEntity> _presets = [];
  final List<Map<String, String>> _aiTracks = [
    {
      "prompt": "Beat lo-fi santai untuk menemani belajar pemrograman",
      "result": "Lo-Fi Luminous (100 BPM)",
    },
    {
      "prompt": "Hujan deras dipadu dengungan synthesizer retro 80an",
      "result": "Neon Rainwave (85 BPM)",
    }
  ];

  MusicNotifier() {
    _presets = [
      const SoundPresetEntity(
        id: "rain",
        name: "Hujan Rimba",
        category: "Suara Alam",
        icon: Icons.grain_rounded,
        glowColor: GlossyMusicTheme.neonCyan,
        backgroundGradient: GlossyMusicTheme.soundscapeRain,
        volume: 0.4,
      ),
      const SoundPresetEntity(
        id: "waves",
        name: "Deburan Ombak",
        category: "Pesisir Pantai",
        icon: Icons.waves_rounded,
        glowColor: GlossyMusicTheme.neonGreen,
        backgroundGradient: GlossyMusicTheme.soundscapeWaves,
        volume: 0.1,
      ),
      const SoundPresetEntity(
        id: "wind",
        name: "Angin Gunung",
        category: "Ketinggian",
        icon: Icons.air_rounded,
        glowColor: Colors.blueAccent,
        backgroundGradient: GlossyMusicTheme.soundscapeWind,
        volume: 0.0,
      ),
      const SoundPresetEntity(
        id: "synth",
        name: "Retro Synth",
        category: "Synthwave Melodi",
        icon: Icons.album_rounded,
        glowColor: GlossyMusicTheme.neonPink,
        backgroundGradient: GlossyMusicTheme.soundscapeSynth,
        volume: 0.2,
      ),
    ];
  }

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isPlaying => _isPlaying;
  bool get isGenerating => _isGenerating;
  String get currentTrackTitle => _currentTrackTitle;
  String get currentArtist => _currentArtist;
  List<SoundPresetEntity> get presets => _presets;
  List<Map<String, String>> get aiTracks => _aiTracks;

  // Actions
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void updateVolume(String id, double volume) {
    _presets = _presets.map((preset) {
      if (preset.id == id) {
        return preset.copyWith(volume: volume);
      }
      return preset;
    }).toList();
    notifyListeners();
  }

  Future<void> generateAiMusic(String prompt) async {
    if (prompt.trim().isEmpty) return;
    
    _isGenerating = true;
    _isPlaying = false; // Stop current track during generation
    notifyListeners();

    // Simulate holographic neural audio compilation
    await Future.delayed(const Duration(milliseconds: 3000));

    final trackName = "Custom AI - ${prompt.split(' ').take(2).join(' ')} Synth";
    _currentTrackTitle = trackName;
    _currentArtist = "Kreasi AI Personal";
    
    _aiTracks.insert(0, {
      "prompt": prompt,
      "result": "$trackName (90 BPM)",
    });

    _isGenerating = false;
    _isPlaying = true; // Auto-play the generated masterpiece!
    notifyListeners();
  }

  void selectTrack(String title, String artist) {
    _currentTrackTitle = title;
    _currentArtist = artist;
    _isPlaying = true;
    notifyListeners();
  }
}
