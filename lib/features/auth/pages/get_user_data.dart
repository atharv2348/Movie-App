import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/auth/pages/code_sent.dart';
import 'package:movie_app/models/user_model.dart';
import 'package:page_transition/page_transition.dart';

import '../../../components/my_buttons.dart';
import '../../../components/my_text_field.dart';
import '../../../utils/validators.dart';
import 'signin_page.dart';

class GetUserData extends StatefulWidget {
  GetUserData({super.key, required this.onTap});
  final void Function() onTap;

  @override
  State<GetUserData> createState() => _GetUserDataState();
}

class _GetUserDataState extends State<GetUserData> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    debugPrint("GetUserData Build");
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text("User Details",
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 20.h),

                MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obsecureText: false,
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 15),
                MyTextField(
                  controller: phoneNumberController,
                  hintText: "Phone Number",
                  obsecureText: false,
                  keyboardType: TextInputType.number,
                  prefixIcon: const Icon(Icons.phone),
                ),
                const SizedBox(height: 15),
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
                          borderSide: BorderSide(color: Colors.grey.shade500)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey.shade200)),
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
                              ? const Icon(Icons.visibility, color: Colors.grey)
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "* fields are required",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 20),

                // Proceed Button
                MyFilledButton(
                  text: "Proceed",
                  onTap: () {
                    proceed(context);
                  },
                ),

                // not a user?
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already a member?"),
                    const SizedBox(width: 4),
                    GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          widget.onTap();
                        },
                        child: const Text(
                          "Login now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customDropDownMenu(List<String> menu, StateProvider<String> selection,
      String hinText, Icon prefixIcon) {
    return Consumer(builder: (context, ref, child) {
      return SizedBox(
        width: double.maxFinite,
        child: DropdownButtonFormField(
          style: const TextStyle(color: Colors.grey, fontFamily: "Avenir"),
          borderRadius: BorderRadius.circular(10),
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)),
          ),
          hint: Text(hinText,
              style: TextStyle(color: Colors.grey, fontSize: 15.sp)),
          items: menu
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (val) {
            ref.read(selection.notifier).state = val as String;
          },
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: Colors.grey,
          ),
          dropdownColor: Colors.grey.shade200,
        ),
      );
    });
  }

  proceed(BuildContext context) {
    HapticFeedback.mediumImpact();

    UserModel userData = UserModel(
      email: emailController.text,
      name: nameController.text,
      phone: phoneNumberController.text,
      password: passwordController.text,
    );

    String status = check(userData);

    if (status == "proceed") {
      Navigator.push(
        context,
        PageTransition(
          child: CodeSent(userData: userData),
          type: PageTransitionType.rightToLeftWithFade,
          curve: Curves.easeInOutBack,
          duration: const Duration(milliseconds: 500),
        ),
      );
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

  String check(UserModel user) {
    if (user.name!.isEmpty) {
      return "name";
    } else if (user.phone!.isEmpty && user.phone!.length != 10) {
      return "Phone Number";
    } else if (user.email!.isEmpty) {
      return "Email";
    } else if (user.password!.isEmpty) {
      return "Password";
    }

    return "proceed";
  }
}
