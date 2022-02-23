import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'dart:core';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

String videoPlay = '';

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

  @override
  Widget build(BuildContext context) {
    debugPrint(videoPlay);
    return Scaffold(
      appBar:MediaQuery.of(context).orientation==Orientation.portrait? AppBar(
        title: Text(widget.docs + ' Lessons'),
      ):null,
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection(widget.collection)
                .doc(widget.docs)
                .collection('lessons')
                .snapshots(),
            builder: (ctx, snapshot) {
              final videoData = snapshot.data?.docs;
              List<String> listVideoTitle = [];
              List<String> listVideoLinks = [];
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError || videoData!.isEmpty) {
                    return const Center(
                      child: ListTile(
                        leading: Icon(
                          Icons.error_outline,
                          size: 55,
                        ),
                        title: Text('Some error occurred!'),
                        subtitle: Text(
                            'Usually, this is because of internet connection \nor there is no uploaded video yet in the server.'),
                      ),
                    );
                  } else {
                    for (var video in videoData) {
                      final videoTitle = video.get('Name');
                      final videoUrls = video.get('Link');
                      listVideoTitle.add(videoTitle);
                      listVideoLinks.add(videoUrls);
                    }
                    return VideoPlaylist(
                      videosList: listVideoTitle,
                      videoUrl: listVideoLinks,
                    );
                  }
              }
            },
          )),
    );
  }
}

class VideoPlaylist extends StatefulWidget {
  const VideoPlaylist(
      {Key? key, required this.videosList, required this.videoUrl})
      : super(key: key);

  final List<String> videosList;
  final List<String> videoUrl;

  @override
  _VideoPlaylistState createState() => _VideoPlaylistState();
}

class _VideoPlaylistState extends State<VideoPlaylist> {
  late YoutubePlayerController _controller;
  List<String> videoShortId = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideo();
  }

  void getVideo() {
    setState(() {
      _controller = YoutubePlayerController(
        initialVideoId:
            YoutubePlayer.convertUrlToId(widget.videoUrl.elementAt(0))
                as String,

      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:WillPopScope(
        onWillPop: () async {
          if (MediaQuery.of(context).orientation == Orientation.landscape) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
          } else {
            Navigator.pop(context);
          }
          return false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height:
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? MediaQuery.of(context).size.height * 0.95
                    : MediaQuery.of(context).size.height * 0.35,
                child: YoutubePlayer(
                  aspectRatio: 16 / 9,
                  controller: _controller,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.55,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: widget.videosList.length,
                  itemBuilder: (ctx, index) => InkWell(
                    onTap: () {
                      setState(
                            () {
                          final videoIndex = widget.videoUrl.elementAt(index);
                          debugPrint(videoIndex);
                          _controller.load(
                              YoutubePlayer.convertUrlToId(videoIndex) as String);
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 5.0),
                      child: SizedBox(
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Container(
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle_fill,
                                      size: 35,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                            YoutubePlayer.getThumbnail(
                                                videoId:
                                                YoutubePlayer.convertUrlToId(
                                                  widget.videoUrl[index],
                                                ) as String),
                                          ),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(5.0)),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.videosList[index],
                                        style: videoTitleTextStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.play_circle_fill,
                                color: Colors.amber,
                                size: MediaQuery.of(context).size.height * 0.05,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: darkBlue,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
