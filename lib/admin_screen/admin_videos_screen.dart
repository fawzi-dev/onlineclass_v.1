import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/snack_bar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:core';
import 'admin_add_videos.dart';

final _firestore = FirebaseFirestore.instance;

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
      appBar: MediaQuery.of(context).orientation == Orientation.portrait
          ? AppBar(
              title: const Text('Videos'),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: AddVideoScreen(
                            collectionId: widget.collection,
                            docsId: widget.docs,
                            index: 0,
                            tapped: 'Add',
                            linkToBeEdited: '',
                            nameToBeEdited: '',
                          ),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add,color:Colors.amber),
                )
              ],
              backgroundColor: colorBack1,
            )
          : null,
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
                      collectionId: widget.collection,
                      docuId: widget.docs,
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
      {Key? key,
      required this.videosList,
      required this.videoUrl,
      required this.collectionId,
      required this.docuId})
      : super(key: key);

  final List<String> videosList;
  final List<String> videoUrl;
  final String collectionId;
  final String docuId;

  @override
  _VideoPlaylistState createState() => _VideoPlaylistState();
}

class _VideoPlaylistState extends State<VideoPlaylist> {
  late YoutubePlayerController _controller;
  List<String> videoShortId = [];
  List<String> ids = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVideo();
    getData();
  }

  void getVideo() {
    _controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(widget.videoUrl.elementAt(0)) as String,
    );
  }

  getData() async {
    final videoLink = await _firestore
        .collection(widget.collectionId)
        .doc(widget.docuId)
        .collection('lessons')
        .get();
    for (var video in videoLink.docs) {
      ids.add(video.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
                        height:  MediaQuery.of(context).orientation == Orientation.landscape? MediaQuery.of(context).size.height * 0.15:MediaQuery.of(context).size.height * 0.1,
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
                                  children: [
                                    Text(
                                      widget.videosList[index],
                                      style: videoTitleTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) => SingleChildScrollView(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom),
                                      child: AddVideoScreen(
                                        collectionId: widget.collectionId,
                                        docsId: widget.docuId,
                                        index: index,
                                        tapped: 'Update',
                                        nameToBeEdited:
                                            widget.videosList[index],
                                        linkToBeEdited: widget.videoUrl[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: const Icon(
                                Icons.edit,
                                color: Colors.amber,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
                            InkWell(
                              onTap: () {
                                    _firestore
                                    .collection(widget.collectionId)
                                    .doc(widget.docuId)
                                    .collection('lessons')
                                    .doc(ids[index])
                                    .delete();
                                    showSnackBar(context, 'Video Deleted!',
                                    Colors.redAccent);
                                    ids.removeAt(index);
                              },
                              child:  Icon(Icons.delete,color: Colors.red.shade400,),
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
        ),
      ),
    );
  }
}
