import 'package:flutter/material.dart';
import 'package:progress_bar_marked/marked_player_progressbar.dart';
import 'package:video_player/video_player.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        _controller.setVolume(0);
        // _controller.play();
        setState(() {});
      });

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          Text(_controller.value.duration.toString()),
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ProgressBarMarked(
              activeColor: Colors.orange,
              markColor: Colors.red,
              thumbColor: Colors.orangeAccent,
              strokeHeight: 10,
              duration: _controller.value.duration,
              position: _controller.value.position,
              markers: [
                Duration(seconds: 1),
                Duration(seconds: 2),
                Duration(seconds: 15),
              ],
              onUpdate: (duration) {
                _controller.seekTo(duration);
                setState(() {});
              },
              onUpdateStart: () {},
              onUpdateEnd: () {},
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_controller.value.isPlaying) {
            _controller.pause();
          } else {
            _controller.play();
          }
          setState(() {});
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}
