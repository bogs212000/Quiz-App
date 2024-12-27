import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:quickalert/quickalert.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:quiz_app/files/sounds.dart';
import 'package:quiz_app/screen/admin.nav.bar.dart';
import 'package:quiz_app/screen/home.dart';
import 'package:quiz_app/screen/nav.bar.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:get/get.dart';

import '../files/images.dart';
import '../fucntion/firebase.dart';
import '../fucntion/user.model.dart';

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
  late AudioPlayer player = AudioPlayer();
  UserModel? userModel;

  void _playSound() {
    player.play(AssetSource('sounds/success.mp3'));
  }

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
      Get.back();
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

    // Calculate score and collect incorrect answers
    score = 0;
    List<Map<String, String>> wrongAnswers = [];

    for (var question in questions) {
      String questionId = question.id;
      String correctAnswer =
          question['answer']; // Correct answer key (e.g., 'a', 'b')
      String correctAnswerText = question[correctAnswer]; // Correct answer text
      String? userAnswer = userAnswers[questionId]; // User's selected key
      String userAnswerText = userAnswer != null
          ? question[userAnswer]
          : "No answer"; // User's answer text

      if (userAnswer == correctAnswer) {
        score++;
      } else {
        // Collect wrong answers
        wrongAnswers.add({
          "question": question['question'],
          "userAnswer":
              userAnswer != null ? "$userAnswer: $userAnswerText" : "No answer",
          "correctAnswer": "$correctAnswer: $correctAnswerText",
        });
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
    Get.back();
    _playSound();
    Get.snackbar(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        'Hooray!',
        'You got $score/${questions.length}, Score has been added.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        isDismissible: false,
        // Make it non-dismissible until login is complete
        duration: Duration(seconds: 5));
    // Show results with wrong answers
    // Show results
    if (wrongAnswers.isEmpty) {
      // All answers are correct
      Get.back();
      Get.dialog(
        AlertDialog(
          title: Text('Hooray!'),
          content: 'You answered all questions correctly! 🎉'
              .text
              .bold
              .size(20)
              .make(),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAll(() => NavBar());
              },
              child: Text("Close"),
            ),
          ],
        ),
      );
    } else {
      Get.back();
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text('Results'),
          content: SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: wrongAnswers.length,
              itemBuilder: (context, index) {
                final wrong = wrongAnswers[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Question: ${wrong['question']}".text.bold.make(),
                    "Your Answer: ${wrong['userAnswer']}".text.red500.make(),
                    "Correct Answer: ${wrong['correctAnswer']}"
                        .text
                        .green500
                        .make(),
                    Divider(),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.offAll(() => NavBar());
              },
              child: Text("Close"),
            ),
          ],
        ),
      );
    }
    // Get.offAll(()=> NavBar());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        // Navigate back using GetX
        return false; // Prevent default back button behavior
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  text: 'Back to home.',
                  onConfirmBtnTap: () {
                    Get.back();
                    Get.back();
                  },
                  onCancelBtnTap: () {
                    Navigator.pop(context);
                  });
            },
            child: Icon(Icons.arrow_back),
          ),
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
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text("Error fetching data."));
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
                                              groupValue:
                                                  userAnswers[questionId],
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
                                              groupValue:
                                                  userAnswers[questionId],
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
                                              groupValue:
                                                  userAnswers[questionId],
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
                                              groupValue:
                                                  userAnswers[questionId],
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
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!Get.isSnackbarOpen) {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return LoadingAnimationWidget
                                              .threeArchedCircle(
                                                  color: AppColor.white,
                                                  size: 40);
                                        });
                                  }
                                  _submitAnswers(questions);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: AppColor.baseColor,
                                  // Text color
                                  elevation: 5,
                                  // Shadow elevation
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // Rounded corners
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 15),
                                  // Padding
                                  textStyle: const TextStyle(
                                    fontSize: 18, // Text size
                                    fontWeight: FontWeight.bold, // Text weight
                                  ),
                                ),
                                child: const Text("Submit Answers"),
                              )),
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
      ),
    );
  }
}
