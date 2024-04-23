// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:micro_mitti/widget/myWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeView extends StatefulWidget {
  final String title;
  final String url;
  const YoutubeView({super.key, required this.url, required this.title});

  @override
  State<YoutubeView> createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  late YoutubePlayerController controller;
  String? videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayer.convertUrlToId(widget.url);
    controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          appbar(
            header: widget.title,
            iconData2: null,
            onPressed1: () {
              Navigator.of(context).pop();
            },
            onPressed2: () {},
            iconData1: Icons.arrow_back_ios_new,
            fontSize: 18,
          ),
          Center(
            child: YoutubePlayer(controller: controller, ),
          )
        ],
      ),
    );
  }
}
