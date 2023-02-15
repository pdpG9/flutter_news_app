import 'package:flutter/material.dart';
import 'package:flutter_news_app/data/post_model.dart';

import '../ui/info_screen.dart';

void toInfoScreen(BuildContext context, PostModel postModel){
  Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(postModel)));
}