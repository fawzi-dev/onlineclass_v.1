import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/user_screen/user_videos_screen.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/drawer.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({Key? key, this.collectionId}) : super(key: key);

  final String? collectionId;

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> img = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    final videoLink = await _firestore.collection(widget.collectionId as String).get();
    for (var video in videoLink.docs) {
      final theLink = video.get('imgUrl');
      img.add(theLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(),
      backgroundColor: colorBack1,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: colorBack1,
      ),
      body: SizedBox(
        child: FutureBuilder<QuerySnapshot>(
            future: _firestore.collection(widget.collectionId as String).get(),
            builder: (ctx, snapshots) {
              final data = snapshots.data?.docs;
              List<String> docId = [];
              switch (snapshots.connectionState) {
                case ConnectionState.waiting:
                  return const Center(child: CircularProgressIndicator());
                case ConnectionState.none:
                  const Center(
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
                  break;
                case ConnectionState.active:
                  const Center(
                    child: ListTile(
                      leading: Icon(
                        Icons.error_outline,
                        size: 55,
                      ),
                      title: Text('You are connected'),
                      subtitle: Text(
                          'Usually, this is because of internet connection \nor there is no uploaded video yet in the server.'),
                    ),
                  );
                  break;
                case ConnectionState.done:
                  for (var titles in data!) {
                    docId.add(titles.id);
                  }
                  break;
              }

              return GridView.builder(
                itemCount: docId.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (ctx, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => UserVideoScreen(
                              collection: widget.collectionId as String,
                              docs: docId[index]),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // image: const DecorationImage(
                        //     image: NetworkImage('https://import.viva64.com/docx/blog/0329_CppPopularity/image1.png'), fit: BoxFit.cover),
                      ),
                      child: GridTile(
                        child: Image.network(img[index],fit: BoxFit.cover,),
                        footer: Container(
                          alignment: Alignment.center,
                          color: grey1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(docId[index]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
