

import 'package:dio/dio.dart';
import 'package:flutter_news_app/data/api_client.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;
Future<void> setup()async{
getIt.registerLazySingleton(() => Dio());
getIt.registerLazySingleton(() => NewsClient(Dio()));
}