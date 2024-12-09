import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/fucntion/firebase.dart';
import 'package:quiz_app/screen/form.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/colors.dart';
import '../files/images.dart';
import '../files/text.dart';
import '../fucntion/const.dart';
import '../fucntion/fetch.dart';
import '../fucntion/user.model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                        const Icon(
                          Icons.light_mode_outlined,
                          color: AppColor.white,
                        ),
                        10.widthBox,
                        "GOOD MORNING"
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
                              image: NetworkImage('${userModel!.profile}'),
                              fit: BoxFit.fill),
                        )
                      ],
                    ),
                    10.heightBox,
                    Expanded(
                      child: VxBox(
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
                            SizedBox(
                              width: 170,
                              child: ElevatedButton(
                                  onPressed: () => {},
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(CupertinoIcons.heart_fill),
                                      AppText.find_friends.text.make(),
                                    ],
                                  ),),
                            )
                          ],
                        ),
                      )
                          .padding(EdgeInsets.all(30))
                          .color(Colors.white.withOpacity(0.2))
                          .rounded
                          .width(double.infinity)
                          .make(),
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
                                .orderBy('level', descending: true)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
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
                                                currentUserEmail) // Check if the user exists
                                        .get(),
                                    builder: (context, userSnapshot) {
                                      if (userSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
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
                                            Get.snackbar(
                                              "Info",
                                              "You already answered this quiz. Your score: ${userSnapshot.data!.docs.first['score']}",
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              margin: EdgeInsets.all(10)
                                            );
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
                                                          backgroundImage: const DecorationImage(
                                                              image: NetworkImage('${Images.technology}'),
                                                              fit: BoxFit.fill),
                                                        )
                                                      )
                                                          .rounded
                                                          .make(),
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
