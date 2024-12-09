import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:quiz_app/screen/nav.bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

import '../files/images.dart';
import '../fucntion/firebase.dart';

class AnswerForm extends StatefulWidget {
  const AnswerForm({super.key});

  @override
  State<AnswerForm> createState() => _AnswerFormState();
}

class _AnswerFormState extends State<AnswerForm> {
  Map<String, String> userAnswers = {}; // Store user answers
  int score = 0; // Track score
  bool isQuizCompleted = false; // Check if the quiz is already completed
  String? userEmail = currentUserEmail; // Replace with actual user ID logic
  @override
  void initState() {
    super.initState();
    _checkQuizCompletion();
  }

  void _checkQuizCompletion() async {
    final quizId = Get.arguments[1];
    final doc = await FirebaseFirestore.instance
        .collection('user_scores')
        .doc('$userEmail-$quizId') // Unique ID for user and quiz
        .get();

    if (doc.exists) {
      // If the quiz is already completed
      setState(() {
        isQuizCompleted = true;
        score = doc['score'];
      });
    }
  }

  Future<void> _submitAnswers(List<QueryDocumentSnapshot> questions) async {
    final quizId = Get.arguments[1];
    // Validate all questions have an answer
    if (userAnswers.length != questions.length) {
      // Show error if not all questions are answered
      Get.snackbar(
        'Notice',
        'Please answer all questions before submitting.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 50),
        padding: EdgeInsets.all(10),
        duration: Duration(seconds: 2),
      );
      return;
    }

    // Calculate score
    score = 0;
    for (var question in questions) {
      String questionId = question.id;
      if (userAnswers[questionId] == question['answer']) {
        score++;
      }
    }

    try {
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userEmail);

      // Save score to Firestore
      await FirebaseFirestore.instance
          .collection('levels')
          .doc('$quizId')
          .collection('who_answered')
          .doc(userEmail) // Unique ID for user and quiz
          .set({
        'userId': userEmail,
        'quizId': quizId,
        'score': score,
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Update the user's score
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        if (!userDoc.exists) {
          throw Exception("User does not exist!");
        }

        final currentScore =
            userDoc['score'] ?? 0; // Default to 0 if not present
        transaction.update(userRef, {
          'score': currentScore + score, // Increment total score
        });
      });
    } catch (e) {
      print(e);
    }
    Get.snackbar(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      'Hooray!',
      'You got $score/${questions.length}, Score has been added.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      isDismissible:
      false, // Make it non-dismissible until login is complete
    );
    Get.offAll(()=> NavBar());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'Level ${Get.arguments[1]}'.text.bold.make(),
        backgroundColor: AppColor.baseColor,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppColor.baseColor,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                VxCircle(
                  radius: 70,
                  backgroundImage: const DecorationImage(
                      image: NetworkImage('${Images.technology}'),
                      fit: BoxFit.fill),
                ),
                Image.asset(Images.anime_chibi, height: 100),
              ],
            ),
            Expanded(
              child: VxBox(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('levels')
                      .doc(Get.arguments[1].toString())
                      .collection('questions')
                      .orderBy('no', descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("Error fetching data."));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No data available."));
                    }

                    final questions = snapshot.data!.docs;

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: questions.length,
                            itemBuilder: (context, index) {
                              final question = questions[index];
                              String questionId =
                                  question.id; // Store question ID
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: VxBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        '${question['question']}'
                                            .text
                                            .bold
                                            .size(20)
                                            .make(),
                                        ListTile(
                                          title: '${question['a']}'
                                              .text
                                              .size(15)
                                              .bold
                                              .make(),
                                          leading: Radio<String>(
                                            value: 'a',
                                            groupValue: userAnswers[questionId],
                                            onChanged: (value) {
                                              setState(() {
                                                userAnswers[questionId] =
                                                    value!;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: '${question['b']}'
                                              .text
                                              .size(15)
                                              .bold
                                              .make(),
                                          leading: Radio<String>(
                                            value: 'b',
                                            groupValue: userAnswers[questionId],
                                            onChanged: (value) {
                                              setState(() {
                                                userAnswers[questionId] =
                                                    value!;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: '${question['c']}'
                                              .text
                                              .size(15)
                                              .bold
                                              .make(),
                                          leading: Radio<String>(
                                            value: 'c',
                                            groupValue: userAnswers[questionId],
                                            onChanged: (value) {
                                              setState(() {
                                                userAnswers[questionId] =
                                                    value!;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: '${question['d']}'
                                              .text
                                              .size(15)
                                              .bold
                                              .make(),
                                          leading: Radio<String>(
                                            value: 'd',
                                            groupValue: userAnswers[questionId],
                                            onChanged: (value) {
                                              setState(() {
                                                userAnswers[questionId] =
                                                    value!;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ).white.make(),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {
                              // Calculate score and show result
                              _submitAnswers(questions);
                            },
                            child: const Text("Submit Answers"),
                          ),
                        ),
                        10.heightBox,
                      ],
                    );
                  },
                ),
              )
                  .padding(const EdgeInsets.only(top: 20))
                  .color(Colors.white)
                  .customRounded(const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)))
                  .make(),
            ),
          ],
        ),
      ),
    );
  }
}
