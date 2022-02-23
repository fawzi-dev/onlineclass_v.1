import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/utlities/colors.dart';

import '../utlities/snack_bar.dart';

class AddVideoScreen extends StatefulWidget {
  const AddVideoScreen({
    Key? key,
    required this.collectionId,
    required this.docsId,
    required this.index,
    required this.tapped,
    required this.linkToBeEdited,
    required this.nameToBeEdited,
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
  String linkController='';
  String nameController='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    final videoLink = await _firestore
        .collection(widget.collectionId)
        .doc(widget.docsId)
        .collection('lessons')
        .get();
    for (var video in videoLink.docs) {
      ids.add(video.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;


    _addVideo() {
      _firestore
          .collection(widget.collectionId)
          .doc(widget.docsId)
          .collection('lessons')
          .add({'Link': linkController, 'Name': nameController});

      Navigator.pop(context);
      showSnackBar(context, 'Video Added!', Colors.green);
    }

    _updatVideo() {
      _firestore
          .collection(widget.collectionId)
          .doc(widget.docsId)
          .collection('lessons')
          .doc(ids[widget.index])
          .update({'Link': linkController, 'Name': nameController});

      Navigator.pop(context);
      showSnackBar(context, 'Video Updated!', Colors.green);
    }

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
              '${widget.tapped} Video',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: darkBlue,
              ),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              textAlign: TextAlign.justify,
              autofocus: true,
              onChanged: (newText) {
                nameController = newText;
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Link'),
              textAlign: TextAlign.justify,
              autofocus: true,
              onChanged: (newText) {
                if (regEx.hasMatch(newText)) {
                  linkController = newText;
                }
              },
            ),
            ElevatedButton(
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(darkBlue),
              ),
              onPressed: () {
                if (linkController == '' || nameController == '') {
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
                  if (widget.tapped == 'Add') {
                    _addVideo();
                  } else {
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
