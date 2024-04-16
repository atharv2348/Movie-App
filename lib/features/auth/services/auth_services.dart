import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/user_model.dart';
import 'package:movie_app/utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Dio dio = Dio();

  /// login user

  Future<void> loginUser(String email, String password) async {
    debugPrint("Login function is called");
    try {
      Response response = await dio.post("${auth_base_url}auth/login", data: {
        "email": email,
        "password": password,
      });

      print(response.data);

      String token = response.data["token"];
      print("Token : $token");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", token);
    } on DioException catch (e) {
      debugPrint("Login Exception -->  $e");
      throw Exception(e);
    }
  }

  /// send OTP

  Future<void> sendOTP(String email) async {
    debugPrint("Send OTP function is called");

    try {
      debugPrint("Sending OTP...");
      Response response = await dio
          .post("${auth_base_url}auth/sendOTP", data: {"email": email});
      debugPrint("OTP sent successfully");
      debugPrint(
          "Send OTP API response : StatusCode :  ${response.statusCode}  Response :  ${response.data} ");
    } on DioException catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  /// verify OTP

  Future<bool> verifyOTP(String email, String otp) async {
    debugPrint("Verify OTP function is called");

    debugPrint("Verifying the OTP for email : $email and  otp : $otp");

    try {
      Response response = await dio.post("${auth_base_url}auth/verifyOTP",
          data: {"email": email, "otp": otp});
      debugPrint("OTP verified successfully");
      debugPrint("Response Status Code -> ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      if (e is DioException) {
        if (e.response!.statusCode == 400) {
          debugPrint("Error Response Status Code -> ${e.response!.statusCode}");
          return false;
        }
      }
    }
    return false;
  }

  /// register - creater new user

  Future<int> createNewUser(UserModel user) async {
    debugPrint("CreateNewUser function is called");
    Response response;
    try {
      List<String> l = ["Asd", "asd"];
      response = await dio.post("${auth_base_url}auth/createNewUser", data: {
        "list": l,
        "name": user.name,
        "phone": user.phone,
        "email": user.email,
        "password": user.password,
      });

      debugPrint("Response StatusCode :  ${response.statusCode}");
      print("Response :  ${response.data}");
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
    return response.statusCode!;
  }
}
