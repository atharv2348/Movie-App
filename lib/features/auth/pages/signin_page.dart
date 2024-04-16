import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/my_buttons.dart';
import '../../../utils/validators.dart';
import '../../movies/pages/home_page.dart';
import '../services/auth_services.dart';

final visiblePasswordProvider = StateProvider.autoDispose((ref) => true);

class SigninPage extends StatefulWidget {
  const SigninPage({super.key, required this.onTap});
  final void Function() onTap;

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn() async {
    HapticFeedback.mediumImpact();

    String status = check();

    if (status == "proceed") {
      await authService.loginUser(
          emailController.text.trim(), passwordController.text.trim());

      Navigator.pushReplacement(
          context,
          PageTransition(
              child: const HomePage(),
              type: PageTransitionType.rightToLeftWithFade));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        elevation: 10,
        backgroundColor: Colors.white,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        content: Text("Invalid $status"),
      ));
    }
  }

  String check() {
    if (emailController.text.isEmpty) {
      return "Email";
    } else if (passwordController.text.isEmpty) {
      return "Password";
    }

    return "proceed";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // logo
                  const Icon(Icons.movie_rounded, size: 120),
                  const SizedBox(height: 40),
                  // welcome  back message
                  const Text(
                    "Welcome back you\'ve been missed!",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // email textfield
                  Form(
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      validator: validateEmail,
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.grey),
                        prefixIcon: const Icon(Icons.email),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.red.shade200)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade500)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.grey.shade200)),
                        filled: true,
                        fillColor: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  Consumer(builder: (context, ref, child) {
                    return TextField(
                      obscureText: ref.watch(visiblePasswordProvider),
                      controller: passwordController,
                      decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () {
                              ref.read(visiblePasswordProvider.notifier).state =
                                  !ref
                                      .read(visiblePasswordProvider.notifier)
                                      .state;
                            },
                            icon: ref
                                    .watch(visiblePasswordProvider.notifier)
                                    .state
                                ? const Icon(Icons.visibility,
                                    color: Colors.grey)
                                : const Icon(Icons.visibility_off,
                                    color: Colors.grey),
                          ),
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade500)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade200)),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 10)),
                    );
                  }),

                  const SizedBox(height: 20),
                  // button
                  MyFilledButton(
                    text: "Sign In",
                    onTap: () => signIn(),
                  ),
                  // not a user
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a member?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                          onTap: () => widget.onTap(),
                          child: const Text(
                            "Register now",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
