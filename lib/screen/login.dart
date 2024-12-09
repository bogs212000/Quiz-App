import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:quiz_app/screen/home.dart';
import 'package:quiz_app/screen/signup.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/text.dart';
import '../fucntion/function.dart';
import 'nav.bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        color: AppColor.baseColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                AppText.welcome.text.size(30).white.bold.make(),
              ],
            ),
            Row(
              children: [
                AppText.welcome_content.text.size(13).white.bold.make(),
              ],
            ),
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
            20.heightBox,
            SizedBox(
              height: 50,
              child: TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !_isPasswordVisible,
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
                  hintText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white),
                ),
              ),
            ),
            15.heightBox,
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => SignUpPage());
                  },
                  child: AppText.sign_up.text.white.bold.size(13).make(),
                ),
                Spacer(),
                ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        if(!Get.isSnackbarOpen){
                          Get.snackbar(
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(10),
                            'Notice',
                            'Please input your email and password.',
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
                          'Please wait while we process your login.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white,
                          colorText: AppColor.baseColor,
                          isDismissible:
                              false, // Make it non-dismissible until login is complete
                        );
                        AuthService().signIn(
                            emailController.text.trim().toLowerCase(),
                            passwordController.text.trim());
                      }
                    },
                    child: AppText.login.text.bold.make()),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                  child: AppText.forgot_pass.text.white.bold.size(12).make(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
