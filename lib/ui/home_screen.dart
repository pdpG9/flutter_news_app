import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/data/api_client.dart';
import 'package:flutter_news_app/navigation/directions.dart';
import 'package:flutter_news_app/ui/di/di.dart';

import '../data/category_model.dart';
import '../data/item_slider.dart';
import '../data/post_model.dart';
import '../utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _controller;
  final newsClient = getIt.get<NewsClient>();
  var latestPosts = <PostModel>[];
  var categories = <CategoryModel>[];
  var selectedCategoryId = 0;
  var mainPosts = <PostModel>[];
  var error = false;
  var loading = true;

  @override
  void initState() {
    loadCategory();
    loadLatestPosts();
    loadPosts(0, 30);
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        slivers: [
          ///[[[[[---------   BU QIDIRISH APIDA YO"Q ----------------]]]]]]]

          // SliverToBoxAdapter(
          //   child: Container(
          //     margin: const EdgeInsets.all(16),
          //     decoration: BoxDecoration(
          //         color: backgroundColor,
          //         borderRadius: BorderRadius.circular(16),
          //         border: Border.all(color: backgroundColor, width: 1)),
          //     padding: const EdgeInsets.symmetric(horizontal: 10),
          //     child: const TextField(
          //       maxLines: 1,
          //       decoration: InputDecoration(
          //         border: InputBorder.none,
          //         hintText: "Search from Category",
          //         hintStyle: TextStyle(
          //             fontFamily: 'Nunito',
          //             fontSize: 12,
          //             fontWeight: FontWeight.w600,
          //             color: lightGrey),
          //         prefixIcon: Icon(Icons.search),
          //       ),
          //     ),
          //   ),
          // ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text(
                    "Latest News",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'New York',
                        color: Colors.black),
                  ),
                  const Expanded(flex: 1, child: SizedBox()),
                  GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Row(
                      children: const [
                        Text(
                          "See All",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'New York',
                              color: secondaryColor),
                        ),
                        SizedBox(width: 16),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: secondaryColor,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Builder(builder: (context) {
              if (loading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox(
                width: double.infinity,
                height: 240,
                child: CarouselSlider(
                  options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true),
                  items: getPostSlider(latestPosts), //news
                ),
              );
            }),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        selectedCategoryId = categories[index].id;
                        loadPosts(categories[index].id, 30);
                        setState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: categories[index].id == selectedCategoryId
                                ? primaryColor
                                : Colors.white),
                        child: Center(
                          child: Text(
                            categories[index].name,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Nunito',
                                color:
                                    categories[index].id == selectedCategoryId
                                        ? Colors.white
                                        : primaryTextColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Builder(builder: (context) {
            if (error) {
              return SliverToBoxAdapter(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://media.tenor.com/Wv6zVQPZFtcAAAAd/error.gif",
                ),
              );
            }
            if (loading) {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: (){ toInfoScreen(context, mainPosts[index]); },
                      child: Container(
                          margin:
                              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                          decoration:
                              BoxDecoration(borderRadius: BorderRadius.circular(8)),
                          child: Stack(
                            children: [
                              Image.network(mainPosts[index].image, fit: BoxFit.fill),
                              Positioned(
                                bottom: 1,
                                child: Container(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  transformAlignment: Alignment.bottomCenter,
                                  width: 400,
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    mainPosts[index].title,
                                    style: const TextStyle(
                                        backgroundColor: Colors.black87,
                                        color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                            ],
                          )),
                    );
                  }
                );
              }, childCount: mainPosts.length),
            );
          }),
        ],
      ),
    ));
  }

  Future<void> loadCategory() async {
    loading = true;
    var result = await newsClient.getCategories();
    print(result.isFailure);
    error = result.isFailure;
    if (result.isSuccess) {
      categories = result.success;
      loading = false;
    } else {
      error = true;
    }

    setState(() {});
  }

  Future<void> loadPosts(int categoryId, int limit) async {
    loading = true;
    var result = await newsClient.getPostsByCategory(categoryId, limit);

    error = result.isFailure;
    if (result.isSuccess) {
      mainPosts = result.success;
      loading = false;
    } else {
      error = true;
    }
    setState(() {});
  }

  Future<void> loadLatestPosts() async {
    var result = await newsClient.getPostsByCategory(0, 10);

    error = result.isFailure;
    if (result.isSuccess) {
      latestPosts = result.success;
    } else {
      error = true;
    }
    setState(() {});
  }
}
/*
  child: Stack(
                children: [
                  Image.network(mainPosts[index].image, fit: BoxFit.fill),
                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Text(
                            mainPosts[index].title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'New York',
                            ),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16),
                        child: Row(
                          children: [
                            Text(
                              mainPosts[index].categoryName,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                              maxLines: 1,
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              mainPosts[index].postModified,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Nunito',
                              ),
                              maxLines: 1,
                            )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
 */
