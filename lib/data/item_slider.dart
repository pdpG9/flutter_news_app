import 'package:flutter/material.dart';
import 'package:flutter_news_app/data/post_model.dart';
import 'package:flutter_news_app/navigation/directions.dart';

class PostSliderItem extends StatelessWidget {
  final PostModel postModel;

  const PostSliderItem(this.postModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        toInfoScreen(context, postModel);
      },
      child: Expanded(
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Image.network(
                postModel.image,
                fit: BoxFit.fill,
                height: double.infinity,
              ),
              Positioned(
                top: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 31),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black26, Colors.black45,],
                    ),
                  ),
                  child: SizedBox(
                    width: 250,
                    child: Text(
                      postModel.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      maxLines: 4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
