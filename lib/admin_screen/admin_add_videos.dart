import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddVideoScreen extends StatelessWidget {
   AddVideoScreen({Key? key, required this.collectionId, required this.docsId}) : super(key: key);

  final String collectionId;
  final String docsId;
  final regEx = RegExp(r"^(https?\:\/\/)?((www\.)?youtube\.com|youtu\.?be)\/.+$");


  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;
    String? videoTitle;
    String? videoUrls;

    print("Your collection ID is " + collectionId);
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
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.lightBlueAccent,
              ),
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Title'),
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                videoTitle = newText;
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: 'Link'),
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                if(regEx.hasMatch(newText)){
                  videoUrls = newText;
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
               if(videoTitle == null || videoUrls==null){
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
               }
               else{
                 _firestore
                     .collection(collectionId)
                     .doc(docsId)
                     .collection('lessons')
                     .add({
                   'Link': videoUrls,
                   'Name': videoTitle,
                 });
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
              },
            ),
          ],
        ),
      ),
    );
  }
}
