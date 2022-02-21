import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:better_player/better_player.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoBlur extends StatefulWidget {
  const VideoBlur({Key? key}) : super(key: key);

  @override
  _VideoBlurState createState() => _VideoBlurState();
}

class _VideoBlurState extends State<VideoBlur> {
  late BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ByteData>(
      future: rootBundle.load('assets/glider.mp4'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          return _buildView(snapshot);
        }
      },
    );
  }

  Center _buildView(AsyncSnapshot<ByteData> snapshot) {
    final ByteData _bytes = snapshot.data!;
    var dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.memory, "",
        bytes: Uint8List.view(_bytes.buffer), videoExtension: 'mp4');

    var _betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(
            looping: true,
            aspectRatio: 704 / 1080,
            autoPlay: true,
            controlsConfiguration: BetterPlayerControlsConfiguration(
                showControls: false, enablePlayPause: false)),
        betterPlayerDataSource: dataSource);

    _betterPlayerController.setVolume(0);

    return Center(
      child: Container(
          height: 1080,
          width: 704,
          child: Stack(
            children: [
              Image.asset("assets/arnitopter.jpeg", fit: BoxFit.fill),
              Container(
                  height: 400,
                  width: 250,
                  child: BetterPlayer(
                    controller: _betterPlayerController,
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(100, 100, 0, 0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10.0,
                          sigmaY: 10.0,
                          tileMode: TileMode.repeated,
                        ),
                        child: Container(
                          padding: EdgeInsets.all(24),
                          color: Colors.white.withOpacity(0.0),
                          child: Text(
                            "Where is the blur on the video?:)",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ))),
              )
            ],
          )),
    );
  }
}
