import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayerScreen extends StatefulWidget {
  LocalVideoPlayerScreen({required this.height});

  final double height;

  @override
  _LocalVideoPlayerScreenState createState() => _LocalVideoPlayerScreenState();
}

class _LocalVideoPlayerScreenState extends State<LocalVideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the local asset path
    _controller = VideoPlayerController.asset('lib/assets/homevideo.mp4');

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized

      // setState(() {});
      _controller.setVolume(0);
      _controller.setLooping(true);
      _controller.play();
    });
  }

  @override
  void dispose() {
    // Ensure the controller is disposed of to free up resources
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the VideoPlayerController has finished initialization, use
          // the data it provides to limit the aspect ratio of the video.
          return Container(
            height:
                widget.height, // 1. FIX HEIGHT: Set your desired height here
            width: double.infinity, // 2. FILL WIDTH: Takes all available width
            color: Colors.red,
            child: FittedBox(
              // fit: BoxFit.fill, // Use this if you want to STRETCH the video (distorts image)
              fit: BoxFit
                  .cover, // Use this if you want to ZOOM/CROP to fill the space (keeps aspect ratio)
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        } else {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
