import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:quiz_app/screen/home.dart';
import 'package:quiz_app/screen/login.dart';
import 'package:quiz_app/screen/signup.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/text.dart';
import '../fucntion/function.dart';
import 'nav.bar.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.baseColor, foregroundColor: Colors.white),
      body: Container(
        padding: EdgeInsets.all(40),
        color: AppColor.baseColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Row(
              children: [
                AppText.forgot_pass.text.size(30).white.bold.make(),
              ],
            ),
            AppText.forgot_pass_content.text.size(13).white.bold.make(),
            10.heightBox,
            SizedBox(
              height: 50,
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            15.heightBox,
            Row(
              children: [
                Spacer(),
                ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty) {
                        if (!Get.isSnackbarOpen) {
                          Get.snackbar(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            'Notice',
                            'Please input your email',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                            isDismissible:
                                false, // Make it non-dismissible until login is complete
                          );
                        }
                      } else {
                        Get.snackbar(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(10),
                          'Loading',
                          'Please wait while we process your change password link.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white,
                          colorText: AppColor.baseColor,
                          isDismissible:
                              false, // Make it non-dismissible until login is complete
                        );
                       await AuthService().forgotPass(
                            emailController.text.trim().toLowerCase());
                        emailController.clear();
                        Get.offAll(LoginPage());
                      }
                    },
                    child: AppText.forgot_pass.text.bold.make()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
