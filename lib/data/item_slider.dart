
import 'package:flutter/material.dart';
import 'package:flutter_news_app/data/post_model.dart';
import 'package:flutter_news_app/navigation/directions.dart';

List<Widget> getPostSlider(List<PostModel> posts) {
  final List<Widget> postSliders = posts
      .map((item) =>
      Builder(
        builder: (context) {
          return Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                child: Stack(children:[Image.network(item.image, fit: BoxFit.cover, width: double.infinity),

                GestureDetector(
                  onTap: (){ toInfoScreen(context, item);},
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 31),
                      child: Text(item.title,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Colors.white),)),
                )
                ]
                )),
          );
        }
      ))
      .toList();
  return postSliders;
}