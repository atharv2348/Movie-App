import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieServiceOmdbapi {
  Dio dio = Dio();

  /// This function will return the movie details by it's name
  Future<dynamic> getMoviesBySearch(String movieName) async {
    debugPrint("getMoviesBySearch function is called!");

    Response response = await dio.get("$omdb_base_url&s=$movieName");

    return response.data["Search"];
  }

  /// This function will return the movie details by it's IMDBid
  Future<dynamic> getMoviesByIMDBid(String IMDBid) async {
    debugPrint("getMoviesByIMDBid function is called!");

    Response response = await dio.get("$omdb_base_url&i=$IMDBid");

    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favourites') ?? [];
    bool isfav = favoriteList.contains(IMDBid);
    return [response.data, isfav];
  }
}
