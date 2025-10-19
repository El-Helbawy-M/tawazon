import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHandler {
  // Private audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Flag to track if player is initialized
  bool _isInitialized = true;

  AudioPlayerHandler() {
    _initializePlayer();
  }

  // Initialize player with error handling
  void _initializePlayer() {
    try {
      _audioPlayer.setReleaseMode(ReleaseMode.stop);
    } catch (e) {
      _isInitialized = false;
      log('Failed to initialize audio player: $e');
    }
  }

  // Function to play sound from path with comprehensive error handling
  void playSound(String soundPath) async {
    // Validate input
    log("Helbawy : clicked");

    if (soundPath.isEmpty) {
      log('Error: Sound path cannot be empty');
      return;
    }

    if (!_isInitialized) {
      log('Error: Audio player is not initialized');
      return;
    }

    try {

      // Stop any currently playing sound
      await _audioPlayer.stop();

      // Play the sound from assets
      await _audioPlayer.play(AssetSource(soundPath));

      log('Playing sound: $soundPath');

    } on AudioPlayerException catch (e) {
      // Handle audio player specific errors
      log('PlayerException: ${e.cause}');
    } on FormatException catch (e) {
      // Handle format/parsing errors
      log('FormatException: Invalid audio format - $e');
    } catch (e, stackTrace) {
      // Handle any other unexpected errors
      log('Unexpected error playing sound: $e');
      log('Stack trace: $stackTrace');
    }
  }

  // Optional: Method to play sound from different sources
  void playSoundFromSource(String soundPath, SourceType sourceType) async {
    if (soundPath.isEmpty) {
      log('Error: Sound path cannot be empty');
      return;
    }

    if (!_isInitialized) {
      log('Error: Audio player is not initialized');
      return;
    }

    try {
      await _audioPlayer.stop();

      switch (sourceType) {
        case SourceType.asset:
          await _audioPlayer.play(AssetSource(soundPath));
          break;
        case SourceType.url:
          await _audioPlayer.play(UrlSource(soundPath));
          break;
        case SourceType.device:
          await _audioPlayer.play(DeviceFileSource(soundPath));
          break;
      }

      log('Playing sound from $sourceType: $soundPath');

    } on AudioPlayerException catch (e) {
      log('PlayerException: ${e.cause}');
    } catch (e, stackTrace) {
      log('Error playing sound from $sourceType: $e');
      log('Stack trace: $stackTrace');
    }
  }

  // Dispose method to clean up resources
  void dispose() {
    try {
      _audioPlayer.dispose();
      log('Audio player disposed successfully');
    } catch (e) {
      log('Error disposing audio player: $e');
    }
  }

  // Optional: Pause current sound
  void pause() async {
    try {
      await _audioPlayer.pause();
    } catch (e) {
      log('Error pausing sound: $e');
    }
  }

  // Optional: Resume paused sound
  void resume() async {
    try {
      await _audioPlayer.resume();
    } catch (e) {
      log('Error resuming sound: $e');
    }
  }

  // Optional: Stop current sound
  void stop() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      log('Error stopping sound: $e');
    }
  }

  // Optional: Set volume (0.0 to 1.0)
  void setVolume(double volume) async {
    try {
      if (volume < 0.0 || volume > 1.0) {
        log('Error: Volume must be between 0.0 and 1.0');
        return;
      }
      await _audioPlayer.setVolume(volume);
    } catch (e) {
      log('Error setting volume: $e');
    }
  }
}

enum SourceType { asset, url, device }