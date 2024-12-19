import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/images.dart';
import 'form.dart';

class QuestionList extends StatefulWidget {
  const QuestionList({super.key});

  @override
  State<QuestionList> createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.baseColor,
      ),
      body: VxBox(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('levels')
                .orderBy('level', descending: false)
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
                      bool currentStatus = level['status'] ?? false;

                      return GestureDetector(
                        onTap: () {
                            // Navigate to the AnswerForm
                            Get.to(() => AnswerForm(),
                                arguments: [
                                  levelId,
                                  level['level'],
                                ]);

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
                                                image: NetworkImage(
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
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .end,
                                            children: [
                                              Switch(
                                                value: currentStatus,
                                                onChanged: (newValue) async {
                                                  await FirebaseFirestore.instance
                                                      .collection('levels')
                                                      .doc(levelId)
                                                      .update({'status': newValue});
                                                },
                                                activeColor: Colors.green,
                                                inactiveThumbColor: Colors.grey,
                                              ),
                                              Icon(
                                                Icons
                                                    .remove_red_eye_outlined,
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
            })
      )
          .color(AppColor.baseColor)
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .make(),
    );
  }
}
