import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yoyo_player/yoyo_player.dart';

class WatchStream extends StatefulWidget {

  final String playbackID ;

  WatchStream({this.playbackID});

  @override
  _MyAppState createState() => _MyAppState(roomID : playbackID );
}

class _MyAppState extends State<WatchStream> {

  String roomID ;

  _MyAppState({this.roomID});

  bool fullscreen = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: Scaffold(
        appBar: fullscreen == false
            ? AppBar(
                backgroundColor: Colors.blue,
                title: Image(
                  image: AssetImage('image/yoyo_logo.png'),
                  fit: BoxFit.fitHeight,
                  height: 50,
                ),
                centerTitle: true,
              )
            : null,
        body: Column(
          children: [
            YoYoPlayer(
              aspectRatio: 16 / 9,
              url:
                    "https://stream.mux.com/$roomID.m3u8",
              videoStyle: VideoStyle(),
              videoLoadingStyle: VideoLoadingStyle(
                loading: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('image/yoyo_logo.png'),
                        fit: BoxFit.fitHeight,
                        height: 50,
                      ),
                      Text("Loading video"),
                    ],
                  ),
                ),
              ),
              onfullscreen: (t) {
                setState(() {
                  fullscreen = t;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
