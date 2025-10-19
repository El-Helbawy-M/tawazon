import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({super.key});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.networkUrl(Uri.parse('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'))
      ..initialize().then((_) {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
