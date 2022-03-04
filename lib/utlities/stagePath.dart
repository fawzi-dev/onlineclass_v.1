import 'package:flutter/material.dart';

import '../admin_screen/admin_main_screen.dart';

goToStage(BuildContext context,String collectionId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (ctx) =>  AdminMainScreen(collectionId:collectionId),
    ),
  );
}
