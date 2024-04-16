import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/auth/pages/login_or_register.dart';
import 'package:movie_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/movies/pages/home_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  /// This function will fetch the token from local storage if it is present
  /// else it will return false 
  Future<bool> fetchToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get("token").toString();

    if (token.isEmpty) {
      return false;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    UserModel user = UserModel(
      email: decodedToken["email"],
      name: decodedToken["name"],
      phone: decodedToken["phone"],
    );

    sharedPreferences.setString("userInfo", jsonEncode(user));

    return true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ScreenUtilInit(
      designSize: Size(width, height),
      builder: (_, context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Avenir', brightness: Brightness.dark),
          home: FutureBuilder(
            future: fetchToken(),
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return const HomePage();
              } else {
                return LoginOrRegister();
              }
            },
          ),
        );
      },
    );
  }
}
