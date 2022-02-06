import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:core';

class UserVideoScreen extends StatefulWidget {
  const UserVideoScreen(
      {Key? key, required this.collection, required this.docs})
      : super(key: key);

  final String collection;
  final String docs;

  @override
  _UserVideoScreenState createState() => _UserVideoScreenState();
}

class _UserVideoScreenState extends State<UserVideoScreen> {
  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

  // getData() async {
  //   final videoLink = await _firestore
  //       .collection('Stage1')
  //       .doc('cpp')
  //       .collection('lessons')
  //       .get();
  //   for (var video in videoLink.docs) {
  //     print(video.data());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lessons'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection(widget.collection)
              .doc(widget.docs)
              .collection('lessons')
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final videoUrls = snapshot.data!.docs;
              List<VideoPlayer> videoInfo = [];
              for (var video in videoUrls) {
                final videoTitle = video.get('Name');
                final videoUrls = video.get('Link');
                final videoInformation =
                    VideoPlayer(videoTitle: videoTitle, videoUrls: videoUrls);
                videoInfo.add(videoInformation);
              }
              return Column(
                children: [
                  Flexible(
                    child: Container(
                      child: ListView(children: videoInfo),
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class VideoPlayer extends StatelessWidget {
      VideoPlayer(
      {Key? key, required this.videoTitle, required this.videoUrls})
      : super(key: key);

  final String videoTitle;
  final String videoUrls;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                YoutubePlayerIFrame(
                controller:YoutubePlayerController(
                  initialVideoId: YoutubePlayerController.convertUrlToId(videoUrls) as String,
                  params:  const YoutubePlayerParams(
                    showControls: true,
                    showFullscreenButton: true,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: darkBlue,
                child: Center(
                  child: Text(
                    videoTitle,
                    style: kAdminSub,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
