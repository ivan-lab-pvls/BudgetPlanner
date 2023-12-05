// ignore_for_file: unnecessary_import

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:budget_planner/main.dart';
import 'package:budget_planner/pages/home_page.dart';
import 'package:budget_planner/pages/onBoarding_page.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  //   Future.delayed(
  //     const Duration(seconds: 2),
  //     () {
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (_) => const MyHomePage(
  //                 title: 'Food',
  //               )));
  //     },
  //   );
  // }

  // @override
  // void dispose() {
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //       overlays: SystemUiOverlay.values);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Provider.of<ThemeProvider>(context).currentTheme ==
              ThemeClass.lightTheme
          ? Colors.white
          : const Color(0xFF0A1A35),
      duration: 1000,
      splashIconSize: double.infinity,
      splash: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SvgPicture.asset(
            //   'assets/splash_screen_icon.svg',
            // ),
            Text(
              'Budget planner',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Color(0xFF2B62DF)),
            )
          ],
        ),
      ),
      nextScreen: initScreen == 0 || initScreen == null
          ? const OnBoardingPage()
          : const MyHomePage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
