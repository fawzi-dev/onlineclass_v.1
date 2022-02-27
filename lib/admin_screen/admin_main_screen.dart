import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/admin_screen/admin_videos_screen.dart';
import 'package:onlineclass/user_screen/user_videos_screen.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/drawer.dart';
import 'package:onlineclass/utlities/getStoredString.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({
    Key? key, required  this.collectionId,
  }) : super(key: key);

  final String collectionId;

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> img = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final videoLink = await _firestore.collection(widget.collectionId).get();
    for (var video in videoLink.docs) {
      final theLink = video.get('imgUrl');
      img.add(theLink);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      backgroundColor: colorBack1,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: colorBack1,
      ),
      body: SizedBox(
        child: FutureBuilder<QuerySnapshot>(
            future: _firestore.collection(widget.collectionId).get(),
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
                physics: const BouncingScrollPhysics(),
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
                          builder: (ctx) => AdminVideoScreen(
                              collection: widget.collectionId, docs: docId[index]),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: GridTile(
                        child:Image.network(
                                    img[index],
                                    fit: BoxFit.cover,
                                  ),
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
