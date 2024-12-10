import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/files/colors.dart';
import 'package:quiz_app/files/images.dart';
import 'package:quiz_app/files/text.dart';
import 'package:velocity_x/velocity_x.dart';

class RankInfo extends StatefulWidget {
  const RankInfo({super.key});

  @override
  State<RankInfo> createState() => _RankInfoState();
}

class _RankInfoState extends State<RankInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: 'Badges'.text.make(),
        backgroundColor: AppColor.baseColor,
        foregroundColor: Colors.white,
      ),
      body: VxBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              VxBox(
                child: Row(
                  children: [
                    Image.asset(
                      RankBadges.rank_1,
                      height: 60,
                      width: 60,
                    ),
                    Expanded(
                      child: VxBox(child: AppText.info_rank_1.text.bold.make())
                          .padding(EdgeInsets.all(10))
                          .make(),
                    )
                  ],
                ),
              )
                  .height(100)
                  .white
                  .rounded
                  .padding(EdgeInsets.all(10))
                  .width(double.infinity)
                  .margin(EdgeInsets.only(bottom: 10))
                  .make(),
              VxBox(
                child: Row(
                  children: [
                    Image.asset(
                      RankBadges.rank_2,
                      height: 60,
                      width: 60,
                    ),
                    Expanded(
                      child: VxBox(child: AppText.info_rank_2.text.bold.make())
                          .padding(EdgeInsets.all(10))
                          .make(),
                    )
                  ],
                ),
              )
                  .height(100)
                  .white
                  .rounded
                  .padding(EdgeInsets.all(10))
                  .width(double.infinity)
                  .margin(EdgeInsets.only(bottom: 10))
                  .make(),
              VxBox(
                child: Row(
                  children: [
                    Image.asset(
                      RankBadges.rank_3,
                      height: 60,
                      width: 60,
                    ),
                    Expanded(
                      child: VxBox(child: AppText.info_rank_3.text.bold.make())
                          .padding(EdgeInsets.all(10))
                          .make(),
                    )
                  ],
                ),
              )
                  .height(100)
                  .white
                  .rounded
                  .padding(EdgeInsets.all(10))
                  .width(double.infinity)
                  .margin(EdgeInsets.only(bottom: 10))
                  .make(),
              VxBox(
                child: Row(
                  children: [
                    Image.asset(
                      RankBadges.rank,
                      height: 60,
                      width: 60,
                    ),
                    Expanded(
                      child: VxBox(child: AppText.info_rank.text.bold.make())
                          .padding(EdgeInsets.all(10))
                          .make(),
                    )
                  ],
                ),
              )
                  .height(100)
                  .white
                  .rounded
                  .padding(EdgeInsets.all(10))
                  .width(double.infinity)
                  .margin(EdgeInsets.only(bottom: 10))
                  .make()
            ],
          ),
        ),
      )
          .height(MediaQuery.of(context).size.height)
          .width(MediaQuery.of(context).size.width)
          .color(AppColor.baseColor)
          .padding(EdgeInsets.all(20))
          .make(),
    );
  }
}
