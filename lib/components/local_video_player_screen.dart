import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayerScreen extends StatefulWidget {
  LocalVideoPlayerScreen({required this.height});

  final double height;

  @override
  _LocalVideoPlayerScreenState createState() => _LocalVideoPlayerScreenState();
}

// 1. Add WidgetsBindingObserver mixin
class _LocalVideoPlayerScreenState extends State<LocalVideoPlayerScreen>
    with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    // 2. Register the observer
    WidgetsBinding.instance.addObserver(this);

    _controller = VideoPlayerController.asset('lib/assets/homevideo.mp4');

    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      _controller.setVolume(0);
      _controller.setLooping(true);
      _controller.play();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    // 3. Remove the observer to avoid memory leaks
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  // 4. Handle App Lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App malli focus loki vachinappudu (Permission dialog tarvatha)
      if (_controller.value.isInitialized) {
        _controller.play();
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // Optional: App background ki vellinappudu pause cheyali ante ikkada rayochu
      // _controller.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Container(
            height: widget.height,
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
