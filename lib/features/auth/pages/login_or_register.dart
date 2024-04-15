import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'get_user_data.dart';
import 'signin_page.dart';

class LoginOrRegister extends StatefulWidget {
  LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  bool showSignInPage = true;

  togglePages() {
    HapticFeedback.lightImpact();
    setState(() => showSignInPage = !showSignInPage);
  }

  @override
  Widget build(BuildContext context) {
    return showSignInPage
        ? SigninPage(onTap: togglePages)
        : GetUserData(onTap: togglePages);
  }
}
