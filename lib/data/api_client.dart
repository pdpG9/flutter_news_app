import 'package:dio/dio.dart';
import 'package:flutter_news_app/data/category_model.dart';
import 'package:flutter_news_app/data/post_model.dart';

class NewsClient {
  late final Dio _dio;

  NewsClient(Dio dio) {
    _dio = dio;
  }

  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(seconds: 2));
    final response =
        await _dio.get("https://www.terabayt.uz/api.php?action=categories");
      return (response.data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  Future<List<PostModel>> getPostsByCategory(int categoryId,int limit) async{
    await Future.delayed(const Duration(seconds: 2));
    final response =
        await _dio.get("https://www.terabayt.uz/api.php?action=posts&first_update=1613122152&last_update=0&category=$categoryId&limit=$limit");
    return (response.data as List).map((e) => PostModel.fromJson(e)).toList();
  }
}
