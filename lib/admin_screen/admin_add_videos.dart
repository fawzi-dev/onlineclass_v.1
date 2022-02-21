import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/utlities/colors.dart';

class AddVideoScreen extends StatefulWidget {
  AddVideoScreen({
    Key? key,
    required this.collectionId,
    required this.docsId, required this.index, required this.tapped, required this.linkToBeEdited, required this.nameToBeEdited,
  }) : super(key: key);

  final String collectionId;
  final String docsId;
  final int index;
  final String tapped;
  final String? linkToBeEdited;
  final String? nameToBeEdited;

  @override
  State<AddVideoScreen> createState() => _AddVideoScreenState();
}

class _AddVideoScreenState extends State<AddVideoScreen> {
  final regEx =
      RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");
  final _firestore = FirebaseFirestore.instance;
  List<String> ids = [];
   TextEditingController linkController = TextEditingController();
   TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    final videoLink = await _firestore.collection(widget.collectionId).doc(widget.docsId).collection('lessons').get();
    for (var video in videoLink.docs) {
      print('ID::::::: '+video.id);
      ids.add(video.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    String? videoTitle;
    String? videoUrls;

    _addVideo() {
      _firestore
          .collection(widget.collectionId)
          .doc(widget.docsId)
          .collection('lessons')
          .add({'Link': videoUrls, 'Name': videoTitle});

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Video Added',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
      );
    }

    _updatVideo() {
      _firestore
          .collection(widget.collectionId)
          .doc(widget.docsId)
          .collection('lessons').doc(ids[widget.index]).update({
        'Link':linkController.text,
        'Name':nameController.text
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Video Updated!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
      );
    }



    print("Your collection ID is " + widget.collectionId);
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Video',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: darkBlue,
              ),
            ),
            TextField(
              controller: nameController..text=widget.nameToBeEdited!,
              decoration: const InputDecoration(hintText: 'Title'),
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                nameController.text = newText;
              },
            ),
            TextField(
              controller: linkController..text = widget.linkToBeEdited!,
              decoration: const InputDecoration(hintText: 'Link'),
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                if (regEx.hasMatch(newText)) {
                  linkController.text = newText;
                  debugPrint('TEXT """"" '+linkController.text);
                }
              },
            ),
            FlatButton(
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Colors.lightBlueAccent,
              onPressed: () {
                if (linkController.text =='' || nameController.text =='') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please input data correctly!',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.black,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  if(widget.tapped=='Add'){
                     _addVideo();
                  }
                  else {
                    _updatVideo();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
