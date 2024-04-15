import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MovieServiceOmdbapi {
  Dio dio = Dio();

  Future<dynamic> getMoviesBySearch(String s) async {
    debugPrint("getMoviesBySearch function is called!");

    Response response = await dio.get("$omdb_base_url&s=$s");

    debugPrint("Response : ${response.data}");

    return response.data["Search"];
  }

  Future<dynamic> getMoviesByIMDBid(String IMDBid) async {
    debugPrint("getMoviesByIMDBid function is called!");

    Response response = await dio.get("$omdb_base_url&i=$IMDBid");

    debugPrint("Response : ${response.data}");
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favourites') ?? [];
    bool isfav = favoriteList.contains(IMDBid);

    return [response.data, isfav];
  }
}
