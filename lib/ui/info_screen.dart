import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_news_app/data/post_model.dart';

class InfoScreen extends StatelessWidget {

  final PostModel model;

  const InfoScreen(this.model, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Info Screen"),),
      body: Html(data: model.content),
    );
  }


}