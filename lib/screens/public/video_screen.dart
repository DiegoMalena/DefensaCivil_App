import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final List<Map<String, String>> _videos = [
    {
      'id': 'UenHxG_089g',
      'title': '¿Qué hace la Defensa Civil? - Defensa Civil',
    },
    {
      'id': 'SsbzITT67RA',
      'title': 'Ángeles Naranja - Defensa Civil',
    },
    {
      'id': 'fDZs5ETdaSg',
      'title': 'Donación de Japón - Defensa Civil',
    },
  ];

  late List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = _videos.map((video) {
      return YoutubePlayerController(
        initialVideoId: video['id']!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Videos de Defensa Civil')),
      body: ListView.builder(
        itemCount: _videos.length,
        itemBuilder: (context, index) {
          final video = _videos[index];
          return ExpansionTile(
            title: Text(video['title']!),
            leading: Icon(Icons.video_library),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: YoutubePlayer(
                  controller: _controllers[index],
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.redAccent,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
