import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/api.dart';

class MovieServicesRapidAPI {
  Dio dio = Dio();

  // Future<dynamic> getMoviesBySearch(String name) async {
  //   debugPrint("getMoviesBySearch function is called");
  //   Response response = await dio.get(
  //       "${base_url_popular}v2/search?searchTerm=${name}&type=NAME&first=20",
  //       options: Options(headers: {
  //         "X-RapidAPI-Key": "004aa3fcbemsh2201930c338c58dp1e9642jsn0affd4c3906c"
  //       }));
  //   print(response);
  //   return response.data;
  // }

  Future<dynamic> getPopularMovies() async {
    debugPrint("getPopularMovies function is called");
    Response response = await dio.get("${base_url_popular}title/v2/get-popular",
        options: Options(headers: {
          "X-RapidAPI-Key": "004aa3fcbemsh2201930c338c58dp1e9642jsn0affd4c3906c"
        }, receiveTimeout: const Duration(minutes: 5)));
    print(response);
    return response.data;
  }

  Future<dynamic> getTopRatedMovies() async {
    debugPrint("getTopRatedMovies function is called");
    Response response = await dio.get("${base_url_top_rated}",
        options: Options(
            headers: {"X-RapidAPI-Key": api_key_top_rated},
            receiveTimeout: const Duration(minutes: 5)));
    print(response);
    return response.data;
  }

  // Future<dynamic> getPopularMovies2() async {
  //   debugPrint("getPopularMovies function is called");
  //   Response response = await dio.get(
  //       "https://api.themoviedb.org/3/movie/top_rated",
  //       options: Options(
  //           headers: {
  //             "Authorization":
  //                 "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0ZWRkMzEwOTlkMWEzNjY5OTRkMmM4MzZjNmI5ZTU0MiIsInN1YiI6IjY2MTY5NDQwZGMxY2I0MDE3YzFjNDFhNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NxtnmNkOu4ipTQFsj0YIebY82nXWiQTg5iaWFCBmWN8"
  //           },
  //           receiveTimeout: const Duration(minutes: 5),
  //           sendTimeout: const Duration(minutes: 5)));
  //   debugPrint(response.data);
  //   return response.data;
  // }
}
