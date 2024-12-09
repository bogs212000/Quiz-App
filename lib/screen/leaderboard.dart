import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:quiz_app/files/text.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/images.dart';
import '../fucntion/const.dart';
import 'form.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'Leaderboard'.text.fontFamily('Rubik').make(),
        foregroundColor: Colors.white,
        backgroundColor: AppColor.baseColor,
      ),
      body: VxBox(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: VxBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: VxBox(
                              child: Center(
                                  child: "#$rank"
                                      .text
                                      .size(20)
                                      .bold
                                      .white
                                      .center
                                      .make()))
                          .rounded
                          .color(AppColor.yellow_orange_dark)
                          .height(60)
                          .width(60)
                          .make(),
                    ),
                    Expanded(
                      child: VxBox(
                        child: AppText.doing_better.text.white.bold
                            .size(15)
                            .make(),
                      ).padding(EdgeInsets.all(20)).make(),
                    ),
                  ],
                ),
              )
                  .color(AppColor.yellow_orange)
                  .width(double.infinity)
                  .rounded
                  .make(),
            ),
            Expanded(
              child: VxBox(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .orderBy('score', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                  child: Text("Error fetching data."));
                            }

                            if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(child: Text("No data available."));
                            }
                            // Extract data
                            final users = snapshot.data!.docs;

                            // Get current user's UID
                            final currentUserEMAIL = FirebaseAuth.instance.currentUser?.email;

                            for (int i = 0; i < users.length; i++) {
                              if (users[i].id == currentUserEMAIL) {
                                rank = i + 1; // Rank is index + 1
                                break;
                              }
                            }
                            return ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                final user = users[index];
                                final username = user['username'];
                                final score = user['score'];
                                final profileImageUrl = user['profile'];

                                return GestureDetector(
                                  onTap: () {
                                    // Handle onTap if needed
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 10, right: 10, left: 10),
                                    child: VxBox(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            VxCircle(
                                              radius: 60,
                                              backgroundImage: DecorationImage(
                                                image: NetworkImage(
                                                    profileImageUrl),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            10.widthBox,
                                            Expanded(
                                              child: VxBox(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        '$username'
                                                            .text
                                                            .bold
                                                            .size(15)
                                                            .make(),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        "$score Scores"
                                                            .text
                                                            .bold
                                                            .fontFamily('Rubik')
                                                            .size(12)
                                                            .gray500
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
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        if (score > 100)
                                                          Image.asset(
                                                            RankBadges.rank_1,
                                                            height: 80,
                                                            width: 80,
                                                          )
                                                        else if (score > 80)
                                                          Image.asset(
                                                            RankBadges.rank_2,
                                                            height: 70,
                                                            width: 70,
                                                          )
                                                        else if (score > 40)
                                                          Image.asset(
                                                            RankBadges.rank_3,
                                                            height: 60,
                                                            width: 60,
                                                          )
                                                        else if (score > 20)
                                                          Image.asset(
                                                            RankBadges.rank,
                                                            height: 50,
                                                            width: 50,
                                                          )
                                                        else
                                                          SizedBox(),
                                                        // No badge for scores <= 10
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ).make(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ).height(100).rounded.shadowXs.white.make(),
                                  ),
                                );
                              },
                            );
                          }))
                  .white
                  .padding(EdgeInsets.only(top: 20, right: 10, left: 10))
                  .customRounded(
                    const BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                    ),
                  )
                  .make(),
            )
          ],
        ),
      )
          .color(AppColor.baseColor)
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .make(),
    );
  }
}
