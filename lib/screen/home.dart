import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/fucntion/app.model.dart';
import 'package:quiz_app/fucntion/firebase.dart';
import 'package:quiz_app/screen/form.dart';
import 'package:quiz_app/screen/rank.info.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/colors.dart';
import '../files/images.dart';
import '../files/text.dart';
import '../fucntion/const.dart';
import '../fucntion/fetch.dart';
import '../fucntion/function.dart';
import '../fucntion/user.model.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? userModel;
  AppData? appData;

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return "GOOD MORNING";
    } else if (hour >= 12 && hour < 18) {
      return "GOOD AFTERNOON";
    } else {
      return "GOOD EVENING";
    }
  }

  IconData getIcon() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return Icons.light_mode_outlined; // Morning icon
    } else if (hour >= 12 && hour < 18) {
      return Icons.wb_sunny_outlined; // Afternoon icon
    } else {
      return Icons.nightlight_outlined; // Evening icon
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    UserModel? fetchedUser = await fetchUserData();
    AppData? fetchedApp = await fetchAppData();
    setState(() {
      userModel = fetchedUser;
      appData = fetchedApp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.baseColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding:
                    EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          getIcon(),
                          color: AppColor.white,
                        ),
                        10.widthBox,
                        getGreeting()
                            .text
                            .fontFamily("Rubik")
                            .color(AppColor.white)
                            .bold
                            .make(),
                      ],
                    ),
                    Row(
                      children: [
                        userModel!.username.text
                            .fontFamily("Rubik")
                            .color(AppColor.white)
                            .size(25)
                            .bold
                            .make(),
                        Spacer(),
                        VxCircle(
                          radius: 50,
                          backgroundImage: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  '${userModel!.profile}'),
                              fit: BoxFit.fill),
                        )
                      ],
                    ),
                    10.heightBox,
                    Expanded(
                      child: Stack(
                        children: [
                          SpinKitSpinningLines(
                              color: Colors.white.withOpacity(0.1), size: 200),
                          VxBox(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText.feature.text.white.bold.size(15).make(),
                                AppText.play_with_friends.text.white
                                    .fontFamily('Rubik')
                                    .center
                                    .bold
                                    .size(15)
                                    .make(),
                                10.heightBox,
                                appData!.update == true ?
                                SizedBox(
                                  width: 170,
                                  child: ElevatedButton(
                                    onPressed: () => {Get.to(() => RankInfo())},
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                       Icon(Icons.cloud_circle, color: AppColor.baseColor,),
                                        AppText.update_now.text.make(),
                                      ],
                                    ),
                                  ),
                                ) :
                                SizedBox(
                                  width: 170,
                                  child: ElevatedButton(
                                    onPressed: () => {Get.to(() => RankInfo())},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SpinKitPumpingHeart(
                                          size: 20,
                                          color: AppColor.baseColor,
                                        ),
                                        AppText.find_friends.text.make(),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                              .padding(EdgeInsets.all(30))
                              .color(Colors.white.withOpacity(0.2))
                              .rounded
                              .width(double.infinity)
                              .make(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            10.heightBox,
            Expanded(
              child: VxBox(
                child: Column(
                  children: [
                    Row(
                      children: [
                        "Levels".text.size(20).extraBold.make(),
                      ],
                    ),
                    Expanded(
                      child: VxBox(
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('levels')
                                .orderBy('level', descending: false)
                                .where('status', isEqualTo: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return VxBox()
                                    .height(100)
                                    .width(double.infinity)
                                    .white
                                    .rounded
                                    .shadow
                                    .make();
                              }

                              if (snapshot.hasError) {
                                return const Center(
                                    child: Text("Error fetching data."));
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                    child: Text("No data available."));
                              }

                              final levels = snapshot.data!.docs;
                              String emailUser = FirebaseAuth
                                  .instance.currentUser!.email
                                  .toString();

                              return ListView.builder(
                                itemCount: levels.length,
                                itemBuilder: (context, index) {
                                  final level = levels[index];
                                  String levelId = level['level'].toString();

                                  return FutureBuilder<QuerySnapshot>(
                                    future: FirebaseFirestore.instance
                                        .collection('levels')
                                        .doc(levelId)
                                        .collection('who_answered')
                                        .where('userId',
                                            isEqualTo:
                                                emailUser) // Check if the user exists
                                        .get(),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: VxBox(
                                                  child: const Center(
                                                      child:
                                                          CircularProgressIndicator()))
                                              .height(100)
                                              .width(double.infinity)
                                              .white
                                              .rounded
                                              .shadow
                                              .make(),
                                        );
                                      }

                                      if (userSnapshot.hasError) {
                                        return const Center(
                                            child: Text(
                                                "Error checking user data."));
                                      }

                                      bool hasAnswered =
                                          userSnapshot.data!.docs.isNotEmpty;

                                      return GestureDetector(
                                        onTap: () {
                                          if (hasAnswered) {
                                            // If the user has already answered, show their score
                                            Get.snackbar("Info",
                                                "You already answered this quiz. Your score: ${userSnapshot.data!.docs.first['score']}",
                                                backgroundColor: Colors.green,
                                                colorText: Colors.white,
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                margin: EdgeInsets.all(10));
                                          } else {
                                            // Navigate to the AnswerForm
                                            Get.to(() => AnswerForm(),
                                                arguments: [
                                                  levelId,
                                                  level['level'],
                                                ]);
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, right: 10, left: 10),
                                          child: VxBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: VxBox(
                                                      child: VxBox(
                                                          child: VxCircle(
                                                        radius: 70,
                                                        backgroundImage:
                                                            const DecorationImage(
                                                                image: CachedNetworkImageProvider(
                                                                    '${Images.technology}'),
                                                                fit: BoxFit
                                                                    .fill),
                                                      )).rounded.make(),
                                                    )
                                                        .padding(
                                                            const EdgeInsets
                                                                .all(5))
                                                        .make(),
                                                  ),
                                                  Expanded(
                                                    child: VxBox(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              "Level ${level['level']}"
                                                                  .text
                                                                  .size(17)
                                                                  .bold
                                                                  .make(),
                                                            ],
                                                          ),
                                                          5.heightBox,
                                                          Row(
                                                            children: [
                                                              if (hasAnswered)
                                                                "Score: ${userSnapshot.data!.docs.first['score']}"
                                                                    .text
                                                                    .size(10)
                                                                    .gray700
                                                                    .fontFamily(
                                                                        "Rubik")
                                                                    .make(),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ).make(),
                                                  ),
                                                  Expanded(
                                                    child: VxBox(
                                                      child: const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .navigate_next,
                                                                size: 30,
                                                                color: Colors
                                                                    .deepPurpleAccent,
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ).make(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                              .height(100)
                                              .rounded
                                              .shadowXs
                                              .white
                                              .make(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }),
                      ).height(double.infinity).width(double.infinity).make(),
                    )
                  ],
                ),
              )
                  .customRounded(
                    const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                  )
                  .padding(EdgeInsets.only(top: 20, right: 20, left: 20))
                  .color(Colors.white)
                  .make(),
            )
          ],
        ),
      ),
    );
  }
}
