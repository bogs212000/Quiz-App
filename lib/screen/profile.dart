import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/images.dart';
import '../fucntion/const.dart';
import '../fucntion/fetch.dart';
import '../fucntion/function.dart';
import '../fucntion/user.model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    UserModel? fetchedUser = await fetchUserData();
    setState(() {
      userModel = fetchedUser;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColor.baseColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: GestureDetector(
                onTap: () {
                  Get.snackbar(
                    'Notice',
                    'Continue to sign out?',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white,
                    colorText: Colors.black,
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 70),
                    padding: EdgeInsets.all(10),
                    duration: Duration(seconds: 3),
                    mainButton: TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        AuthService().signOut();
                        Get.back(); // Dismiss the snackbar
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Confirm',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  );

                }, child: Icon(CupertinoIcons.escape)),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(CupertinoIcons.settings),
          )
        ],
      ),
      body: VxBox(
        child: Column(
          children: [
            VxCircle(
              radius: 100,
              backgroundImage: DecorationImage(
                  image: NetworkImage('${userModel!.profile}'), fit: BoxFit.fill),
            ),
            10.heightBox,
            Expanded(
              child: VxBox(
                child: Column(
                  children: [
                    userModel!.username
                        .text
                        .fontFamily("Rubik")
                        .color(Colors.black)
                        .size(25)
                        .bold
                        .make(),
                    10.heightBox,
                    VxBox(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Icon(
                                  CupertinoIcons.star,
                                  color: Colors.white,
                                ),
                                'Scores'.text.color(Colors.white54).make(),
                                '${userModel!.score}'
                                    .text
                                    .color(Colors.white)
                                    .size(20)
                                    .extraBold
                                    .make(),
                              ],
                            ),
                          ),
                          if (userModel!.score > 100)
                            Image.asset(
                              RankBadges.rank_1,
                              height: 80,
                              width: 80,
                            )
                          else if (userModel!.score > 70)
                            Image.asset(
                              RankBadges.rank_2,
                              height: 70,
                              width: 70,
                            )
                          else if (userModel!.score > 40)
                              Image.asset(
                                RankBadges.rank_3,
                                height: 60,
                                width: 60,
                              )
                            else if (userModel!.score > 10)
                                Image.asset(
                                  RankBadges.rank,
                                  height: 50,
                                  width: 50,
                                )
                              else
                                SizedBox(),
                          Expanded(
                            child: Column(
                              children: [
                                const Icon(
                                  CupertinoIcons.globe,
                                  color: Colors.white,
                                ),
                                'Rank'.text.color(Colors.white54).make(),
                                '$rank'
                                    .text
                                    .color(Colors.white)
                                    .size(20)
                                    .extraBold
                                    .make(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                        .width(double.infinity)
                        .rounded
                        .padding(EdgeInsets.all(20))
                        .color(AppColor.baseColor)
                        .make()
                  ],
                ),
              )
                  .color(Colors.white)
                  .customRounded(
                    const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  )
                  .padding(EdgeInsets.all(20))
                  .width(double.infinity)
                  .make(),
            )
          ],
        ),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .color(AppColor.baseColor)
          .make(),
    );
  }
}
