import 'package:flutter/material.dart';
import 'package:onlineclass/utlities/colors.dart';

import 'drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
        child: GridView.builder(
          itemCount: 10,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemBuilder: (ctx, index) => Padding(
            padding: const EdgeInsets.all(8.0),
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
    );
  }
}