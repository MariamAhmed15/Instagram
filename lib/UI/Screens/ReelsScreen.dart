import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ReelsScreen extends StatefulWidget {
  @override
  ReelsScreenState createState() => ReelsScreenState();
}

class ReelsScreenState extends State<ReelsScreen> {
  final List<String> videoUrls = [
    'https://www.instagram.com/reel/DJrOrloRJWS/',
    'https://www.instagram.com/reel/DIjbqOGqjse/?hl=en',
    'https://samplelib.com/lib/preview/mp4/sample-15s.mp4',
  ];

  List<VideoPlayerController> controllers = [];

  @override
  void initState() {
    super.initState();
    for (var url in videoUrls) {
      final controller = VideoPlayerController.network(url)
        ..initialize().then((_) => setState(() {}))
        ..setLooping(true)
        ..play();
      controllers.add(controller);
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videoUrls.length,
      itemBuilder: (context, index) {
        final controller = controllers[index];
        return controller.value.isInitialized
            ? Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "@user$index",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This is a cool reel 🎬🔥",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 16,
              bottom: 100,
              child: Column(
                children: [
                  Icon(Icons.favorite_border, color: Colors.white, size: 32),
                  SizedBox(height: 16),
                  Icon(Icons.comment, color: Colors.white, size: 32),
                  SizedBox(height: 16),
                  Icon(Icons.send, color: Colors.white, size: 32),
                ],
              ),
            ),
          ],
        )
            : Center(child: CircularProgressIndicator());
      },
    );
  }
}
