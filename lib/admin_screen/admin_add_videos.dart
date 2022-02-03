import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _firestore = FirebaseFirestore.instance;
    String? videoTitle;
    String? videoUrls;

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
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
                videoUrls = newText;
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
                _firestore.collection('Stage1').doc('cpp').collection('lessons').add({
                  'Link': videoUrls,
                  'Name': videoTitle,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}