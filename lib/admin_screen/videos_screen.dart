import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:core';

import 'admin_add_videos.dart';

class AdminVideoScreen extends StatefulWidget {
  const AdminVideoScreen(
      {Key? key, required this.collection, required this.docs})
      : super(key: key);

  final String collection;
  final String docs;

  @override
  _AdminVideoScreenState createState() => _AdminVideoScreenState();
}

class _AdminVideoScreenState extends State<AdminVideoScreen> {
  final _firestore = FirebaseFirestore.instance;
  bool showItem = false;
  final utube =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final videoLink = await _firestore.collection('Stage1').doc('cpp').collection('lessons').get();
    for (var video in videoLink.docs) {
      print(video.data());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Videos'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                      child:Container(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: const AddTaskScreen(),
                      )
                  )
              );
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.9,
        child: StreamBuilder<QuerySnapshot>(
          stream: _firestore.collection('Stage1').doc('cpp').collection('lessons').snapshots(),
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
                print(videoInformation);
              }
              return Column(
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
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
  const VideoPlayer(
      {Key? key, required this.videoTitle, required this.videoUrls})
      : super(key: key);

  final String videoTitle;
  final String videoUrls;

  @override
  Widget build(BuildContext context) {
    print("Link"+videoUrls);
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.all(2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: YoutubePlayer.convertUrlToId(videoUrls) as String,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
              ),
            ),
            showVideoProgressIndicator: true,
            progressIndicatorColor: Colors.blue,
            progressColors: const ProgressBarColors(
                playedColor: Colors.blue, handleColor: Colors.blueAccent),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: darkBlue,
            child: Center(
              child: Text(videoTitle,style: kAdminSub,),
            ),
          ),
        ],
      ),
    );
  }
}
