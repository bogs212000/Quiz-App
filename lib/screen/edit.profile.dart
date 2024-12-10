import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/images.dart';
import '../files/text.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController urlController = TextEditingController(text: Get.arguments[0]);
  final TextEditingController usernameController = TextEditingController(text: Get.arguments[1]);
  String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.baseColor,
        foregroundColor: Colors.white,
      ),
      body: VxBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              VxCircle(
                radius: 100,
                backgroundImage: DecorationImage(
                  image: (url == null ||
                      url!.isEmpty) // Check for null or empty string
                      ? NetworkImage(Get.arguments[0].toString()) as ImageProvider
                      : NetworkImage(url!),
                  fit: BoxFit.fill,
                ),
              ),
              Row(
                children: [
                  AppText.edit_account.text.size(30).white.bold.make(),
                ],
              ),
              10.heightBox,
              SizedBox(
                height: 50,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      url = value;
                    });
                  },
                  controller: urlController,
                  keyboardType: TextInputType.name,
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
                    hintText: 'https://',
                    prefixIcon: const Icon(
                      Icons.link,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              20.heightBox,
              SizedBox(
                height: 50,
                child: TextField(
                  controller: usernameController,
                  keyboardType: TextInputType.name,
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
                    hintText: 'Username',
                    prefixIcon: const Icon(
                      Icons.person_sharp,
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
                      onPressed: () {
                      },
                      child: 'Save'.text.bold.make()),
                ],
              ),
            ],
          ),
        ),
      )
      .padding(EdgeInsets.only(left: 40, right: 40, top: 20))
          .color(AppColor.baseColor)
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .make(),
    );
  }
}
