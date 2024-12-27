import 'package:flutter/material.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.baseColor,
      body: VxBox(
        child: Center(
          child: SizedBox(
            height: 30,
            width: 30,
            child: LoadingAnimationWidget.threeArchedCircle(
                color: Colors.white, size: 50),
          ),
        ),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .color(
            AppColor.baseColor,
          )
          .make(),
    );
  }
}
