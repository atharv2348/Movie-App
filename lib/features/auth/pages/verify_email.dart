import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_app/features/auth/pages/login_or_register.dart';
import 'package:movie_app/models/user_model.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

import '../../../components/my_buttons.dart';
import '../services/auth_services.dart';

final myOTPProvider = StateProvider.autoDispose<String>((ref) => "");
final loadingProvider = StateProvider.autoDispose<bool>((ref) => false);

class VerifyEmail extends ConsumerWidget {
  VerifyEmail({super.key, required this.userData});
  AuthService authService = AuthService();

  UserModel userData;
  final defaultPinTheme = PinTheme(
    width: 50.w,
    height: 60.h,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade400)),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 120.h),
              Text(
                "Verify Email",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  "Please enter the 6 digits code sent to you email",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.h, color: Colors.grey),
                ),
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Pinput(
                    keyboardType: TextInputType.number,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.grey.shade600),
                      ),
                    ),
                    onCompleted: (pin) {
                      ref.read(myOTPProvider.notifier).state = pin;
                    },
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              Consumer(builder: (context, ref, child) {
                return ref.watch(myOTPProvider).length == 6
                    ? FilledButton(
                        onPressed: () async {
                          HapticFeedback.mediumImpact();
                          ref.read(loadingProvider.notifier).state = true;
                          String otp = ref.read(myOTPProvider);
                          print("otp -> $otp");
                          bool isCorrect =
                              await authService.verifyOTP(userData.email!, otp);
                          if (isCorrect) {
                            await authService.createNewUser(userData);
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                child: LoginOrRegister(),
                                type: PageTransitionType.rightToLeftWithFade,
                                curve: Curves.easeInOutBack,
                                duration: const Duration(milliseconds: 500),
                              ),
                            );
                          } else {
                            ref.read(loadingProvider.notifier).state = false;
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              elevation: 10,
                              backgroundColor: Colors.white,
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              content: Text("Wrong OTP entered"),
                            ));
                          }
                        },
                        style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Center(
                          child: Consumer(builder: (context, ref, child) {
                            bool loading = ref.watch(loadingProvider);
                            return loading
                                ? const CircularProgressIndicator()
                                : const Text("Verify",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold));
                          }),
                        ),
                      )
                    : const MyFilledButton(
                        text: "Verify",
                      );
              }),
              SizedBox(height: 20.h),
              Text(
                "Didn't get a code?",
                style: TextStyle(fontSize: 16.h, color: Colors.grey),
              ),
              SizedBox(height: 5.h),
              GestureDetector(onTap: () {}, child: const Text("Resend Code")),
            ],
          ),
        ),
      ),
    );
  }
}
