import 'package:flutter/material.dart';
import 'package:onlineclass/admin_screen/videos_screen.dart';
import 'package:onlineclass/utlities/colors.dart';

import 'package:onlineclass/drawer.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({Key? key, required this.collection}) : super(key: key);

  final String collection;

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  List<String> docs = [
    'cpp',
    'cpp',
    'cpp',
    'cpp',
    'cpp',
    'cpp',
    'cpp',
    'cpp',
    'cpp',
    'cpp',
  ];

  @override
  Widget build(BuildContext context) {
    print(widget.collection);
    return Scaffold(
      drawer: const Drawers(),
      backgroundColor: colorBack1,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: colorBack1,
      ),
      body: SizedBox(
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (ctx, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) =>  AdminVideoScreen(docs: docs[index].toString(), collection: widget.collection,),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.primaries[index % Colors.primaries.length],
                ),
                child: GridTile(
                  child: Center(
                    child: Text('Pic $index'),
                  ),
                  footer: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$index'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
