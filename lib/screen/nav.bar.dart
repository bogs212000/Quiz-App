import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screen/home.dart';
import 'package:quiz_app/screen/login.dart';
import 'package:quiz_app/screen/profile.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

import '../fucntion/fetch.dart';
import '../fucntion/user.model.dart';
import 'add.form.dart';
import 'leaderboard.dart';
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int selected = 1;
  bool heart = false;
  final controller = PageController();

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
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StylishBottomBar(
        // option: AnimatedBarOptions(
        //   // iconSize: 32,
        //   barAnimation: BarAnimation.blink,
        //   iconStyle: IconStyle.animated,

        //   // opacity: 0.3,
        // ),
        option: DotBarOptions(
          dotStyle: DotStyle.tile,
          gradient: const LinearGradient(
            colors: [
              Colors.deepPurple,
              Colors.pink,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        items: [
          BottomBarItem(
            icon: const Icon(
              Icons.house_outlined,
            ),
            selectedIcon: const Icon(Icons.house_rounded),
            selectedColor: Colors.teal,
            unSelectedColor: Colors.grey,
            title: const Text('Home'),
            // badge: const Text('9+'),
            showBadge: true,
            badgeColor: Colors.purple,
            badgePadding: const EdgeInsets.only(left: 4, right: 4),
          ),
          BottomBarItem(
            icon: const Icon(Icons.star_border_rounded),
            selectedIcon: const Icon(Icons.star_rounded),
            selectedColor: Colors.red,
            // unSelectedColor: Colors.purple,
            // backgroundColor: Colors.orange,
            title: const Text('Star'),
          ),
          BottomBarItem(
              icon: const Icon(
                Icons.leaderboard,
              ),
              selectedIcon: const Icon(
                Icons.leaderboard,
              ),
              selectedColor: Colors.deepOrangeAccent,
              title: const Text('Ranking')),
          BottomBarItem(
              icon: const Icon(
                Icons.person_outline,
              ),
              selectedIcon: const Icon(
                Icons.person,
              ),
              selectedColor: Colors.deepPurple,
              title: const Text('Profile')),
        ],
        hasNotch: true,
        fabLocation: StylishBarFabLocation.center,
        currentIndex: selected,
        notchStyle: NotchStyle.square,
        onTap: (index) {
          if (index == selected) return;
          controller.jumpToPage(index);
          setState(() {
            selected = index;
          });
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       heart = !heart;
      //     });
      //   },
      //   backgroundColor: Colors.white,
      //   child: Icon(
      //     heart ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
      //     color: Colors.red,
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: PageView(
        controller: controller,
        children: const [
          HomePage(),
          AddForm(),
          LeaderboardPage(),
          ProfilePage(),
        ],
      ),
    );
  }
}
