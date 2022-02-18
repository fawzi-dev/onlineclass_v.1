import 'package:onlineclass/admin_screen/admin_stage_screen.dart';

class Video {
  final String videoLink;
  final String videoTitle;
  final String url;


  Video( {required this.videoTitle, required this.videoLink,required this.url});

   static Video fromJson(json) =>
      Video(videoTitle: json['username'], videoLink: json['email'], url: json['urlAvatar']);
}
