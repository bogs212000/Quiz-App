import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:velocity_x/velocity_x.dart';

import '../files/text.dart';
import '../fucntion/function.dart';

class AddForm extends StatefulWidget {
  const AddForm({super.key});

  @override
  State<AddForm> createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final TextEditingController levelController = TextEditingController();
  final TextEditingController noController = TextEditingController();
  final TextEditingController questionController = TextEditingController();
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController cController = TextEditingController();
  final TextEditingController dController = TextEditingController();
  final TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.baseColor,
          foregroundColor: Colors.white,
          title: 'Add Questions'.text.make(),
        ),
        body: VxBox(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    'Level'.text.size(15).white.bold.make(),
                  ],
                ),
                5.heightBox,
                TextField(
                  controller: levelController,
                  keyboardType: TextInputType.number,
                  maxLength: 3,
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
                    hintText: '',
                    prefixIcon: Icon(
                      Icons.linear_scale,
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    'No.'.text.size(15).white.bold.make(),
                  ],
                ),
                5.heightBox,
                TextField(
                  controller: noController,
                  keyboardType: TextInputType.number,
                  maxLength: 2,
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
                    hintText: '',
                    prefixIcon: Icon(
                      Icons.linear_scale,
                      color: Colors.white,
                    ),
                  ),
                ),
                10.heightBox,
                Row(
                  children: [
                    'Question'.text.size(15).white.bold.make(),
                  ],
                ),
                5.heightBox,
                TextField(
                  controller: questionController,
                  keyboardType: TextInputType.name,
                  maxLines: 3,
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
                    hintText: '',
                    // prefixIcon: Icon(
                    //   Icons.email_outlined,
                    //   color: Colors.white,
                    // ),
                  ),
                ),
                10.heightBox,
                Row(
                  children: [
                    'A.'.text.size(15).white.bold.make(),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: aController,
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
                      hintText: '',
                      // prefixIcon: Icon(
                      //   Icons.email_outlined,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                ),
                10.heightBox,
                Row(
                  children: [
                    'B.'.text.size(15).white.bold.make(),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: bController,
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
                      hintText: '',
                      // prefixIcon: Icon(
                      //   Icons.email_outlined,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                ),
                10.heightBox,
                Row(
                  children: [
                    'C.'.text.size(15).white.bold.make(),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: cController,
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
                      hintText: '',
                      // prefixIcon: Icon(
                      //   Icons.email_outlined,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                ),
                10.heightBox,
                Row(
                  children: [
                    'D.'.text.size(15).white.bold.make(),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: dController,
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
                      hintText: '',
                      // prefixIcon: Icon(
                      //   Icons.email_outlined,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                ),
                10.heightBox,
                Row(
                  children: [
                    'Answer(letter only)'.text.size(15).white.bold.make(),
                  ],
                ),
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: answerController,
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
                      hintText: '',
                      // prefixIcon: Icon(
                      //   Icons.email_outlined,
                      //   color: Colors.white,
                      // ),
                    ),
                  ),
                ),
                10.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () async => {
                          Get.snackbar(
                            'Loading',
                            'Adding Question...',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.white,
                            colorText: Colors.black,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 70),
                            padding: EdgeInsets.all(10),
                            duration: Duration(seconds: 5),
                          ),
                          await AuthService().addQuestions(
                              int.parse(levelController.text),
                              // Parse level to integer
                              int.parse(noController.text),
                              // Parse no to integer
                              questionController.text,
                              aController.text,
                              bController.text,
                              cController.text,
                              dController.text,
                              answerController.text),
                          questionController.clear(),
                          aController.clear(),
                          bController.clear(),
                          cController.clear(),
                          dController.clear(),
                          answerController.clear(),

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            'Add'.text.make(),
                            Icon(CupertinoIcons.add_circled),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
            .color(AppColor.baseColor)
            .height(MediaQuery.of(context).size.height)
            .width(MediaQuery.of(context).size.width)
            .padding(
              EdgeInsets.all(20),
            )
            .make());
  }
}
