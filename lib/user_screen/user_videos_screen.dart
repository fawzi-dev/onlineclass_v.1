import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:core';

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
      appBar: AppBar(
        title: Text(widget.docs + ' Lessons'),
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
            YoutubePlayerController.convertUrlToId(widget.videoUrl.elementAt(0))
                as String,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          autoPlay: true,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        YoutubePlayerIFrame(
          controller: _controller,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Flexible(
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
                        YoutubePlayerController.convertUrlToId(videoIndex)
                            as String);
                    _controller.hideTopMenu();
                  },
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
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
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                      YoutubePlayerController.getThumbnail(
                                          videoId: YoutubePlayerController
                                              .convertUrlToId(
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
                          Icons.play_circle_filled_outlined,
                          color: Colors.amber,
                          size: MediaQuery.of(context).size.height * 0.05,
                        )
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
    );
  }
}
