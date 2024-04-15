import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavouriteServices {
  Dio dio = Dio();

  Future<void> addAllFavourites(List<String> imdbIDs) async {
    debugPrint("addAllFavourites function is called");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")!;

      Response response = await dio.patch('${auth_base_url}user/addAllFav',
          data: {"favourites": imdbIDs},
          options: Options(headers: {"Authorization": token}));

      debugPrint("Favourites movies added successfully!");
      debugPrint(
          "Response StatusCode :  ${response.statusCode} ,  Response : ${response.data}");
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  // Future<void> removeFavourite(String imdbID) async {
  //   debugPrint("removeFavourite function is called");

  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     String token = prefs.getString("token")!;

  //     Response response = await dio.patch(
  //         '${auth_base_url}user/removeFavourite',
  //         data: {"imdbID": imdbID},
  //         options: Options(headers: {"Authorization": token}));

  //     debugPrint(
  //         "Response StatusCode :  ${response.statusCode} ,  Response : ${response.data}");
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     throw Exception(e);
  //   }
  // }

  Future<List<String>> getAllFavourites() async {
    debugPrint("getAllFavourites function is called");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")!;

      Response response = await dio.get('${auth_base_url}user/favourites',
          options: Options(headers: {"Authorization": token}));

      debugPrint(
          "Response StatusCode :  ${response.statusCode} ,  Response : ${response.data}");

      List l = response.data["ids"];
      List<String> favourites = [];

      for (int i = 0; i < l.length; i++) {
        favourites.add(l[i].toString());
      }

      return favourites;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<void> removeAllFavourites() async {
    debugPrint("removeAllFavourites function is called");

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token")!;

      Response response = await dio.get('${auth_base_url}user/favourites',
          options: Options(headers: {"Authorization": token}));

      debugPrint("Response StatusCode :  ${response.statusCode}");
    } catch (e) {
      debugPrint("removeAllFavourites exception -> " + e.toString());
      throw Exception(e);
    }
  }
}
