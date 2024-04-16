import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/api.dart';

class MovieServicesRapidAPI {
  Dio dio = Dio();

  /// get popular movies
  Future<dynamic> getPopularMovies() async {
    debugPrint("getPopularMovies function is called");
    Response response = await dio.get("${base_url_popular}title/v2/get-popular",
        options: Options(headers: {
          "X-RapidAPI-Key": "004aa3fcbemsh2201930c338c58dp1e9642jsn0affd4c3906c"
        }, receiveTimeout: const Duration(minutes: 5)));
    print(response);
    return response.data;
  }

  /// get top rated movies
  Future<dynamic> getTopRatedMovies() async {
    debugPrint("getTopRatedMovies function is called");
    Response response = await dio.get("${base_url_top_rated}",
        options: Options(
            headers: {"X-RapidAPI-Key": api_key_top_rated},
            receiveTimeout: const Duration(minutes: 5)));
    print(response);
    return response.data;
  }
}
