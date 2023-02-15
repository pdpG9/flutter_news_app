import 'package:dio/dio.dart';
import 'package:flutter_news_app/data/category_model.dart';
import 'package:flutter_news_app/data/post_model.dart';
import 'package:result_type/result_type.dart';

class NewsClient {
  late final Dio _dio;

  NewsClient(Dio dio) {
    _dio = dio;
  }

  Future<Result<List<CategoryModel>, NetworkError>> getCategories() async {
    try {
      final response =
          await _dio.get("https://www.terabayt.uz/api.php?action=categories");
      final list = (response.data as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();
      return Success(list);
    } catch (error) {
      return Failure(NetworkError.badRequest);
    }
  }

  Future<Result<List<PostModel>, NetworkError>> getPostsByCategory(int categoryId, int limit) async {
    try{
      final response = await _dio.get(
          "https://www.terabayt.uz/api.php?action=posts&first_update=1613122152&last_update=0&category=$categoryId&limit=$limit");
      var list = (response.data as List).map((e) => PostModel.fromJson(e)).toList();
      return Success(list);
    }catch (error) {
      return Failure(NetworkError.badRequest);
    }
  }
}

enum NetworkError implements Comparable<NetworkError> {
  badResponse(500, "Bad response"),
  badRequest(400, 'Bad request'),
  notFound(404, 'Not found');

  final int code;
  final String description;

  const NetworkError(this.code, this.description);

  @override
  String toString() => 'NetworkError(code: $code, description: $description)';

  @override
  int compareTo(NetworkError other) => code - other.code;
}
