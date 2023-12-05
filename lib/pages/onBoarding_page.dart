import 'package:budget_planner/pages/home_page.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
String? showBudgettext;
final remoteConfig = FirebaseRemoteConfig.instance;
Future<bool> getBudgetData() async {
  try {
    await remoteConfig.fetchAndActivate();
    final String axssada = remoteConfig.getString('budgetDataGet');
    if (axssada.contains('budgetDataGet')) {
      return false;
    } else {
      showBudgettext = axssada;
      return true;
    }
  } catch (e) {
    return false;
  }
}


class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  ValueNotifier<int> page = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Provider.of<ThemeProvider>(context).currentTheme ==
              ThemeClass.lightTheme
          ? const Color(0xFFF5F7FA)
          : const Color(0xFF0A1A35),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 65),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: page,
                builder: (context, index, child) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: DotsIndicator(
                    dotsCount: 2,
                    position: page.value,
                    decorator: DotsDecorator(
                      size: const Size(80.0, 4.0),
                      activeSize: const Size(80.0, 4.0),
                      spacing: const EdgeInsets.all(3),
                      color: page.value == 0
                          ? Colors.white.withOpacity(0.26)
                          : const Color(0xFF2B62DF),
                      activeColor: const Color(0xFF2B62DF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      activeShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (page.value == 0)
          Expanded(child: Image.asset('assets/onBoarding.png')),
        if (page.value == 1)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 95, left: 19, right: 19),
              child: Stack(
                  alignment: Alignment.topCenter,
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: const BoxDecoration(color: Colors.white),
                      child: SingleChildScrollView(
                        child: Column(children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15, top: 70),
                            child: Text(
                              'Five Stars for Financial Empowerment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'HK Grotesk',
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: getStars(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                                bottom: 19, left: 19, right: 19),
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'Is more than just a budget planner app; it\'s a holistic financial companion. Whether you\'re just starting your financial journey or looking to level up your money management skills, this the app to have. Highly recommended!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'HK Grotesk',
                                        fontSize: 12,
                                        color: Color(0xFF8C9297),
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                    Positioned(
                        top: -30,
                        child: Image.asset('assets/onBoardingEclipse.png'))
                  ]),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 89, 11, 11),
          child: Container(
            decoration: BoxDecoration(
                color: Provider.of<ThemeProvider>(context).currentTheme ==
                        ThemeClass.lightTheme
                    ? Colors.white
                    : Colors.white.withOpacity(0.15)),
            child: Column(children: [
              if (page.value == 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12, top: 38),
                  child: Text(
                    'Let\'s Achieve Financial Success Together',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              if (page.value == 1)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12, top: 38),
                  child: Text(
                    'We value your feedback',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              if (page.value == 1)
                const Padding(
                  padding: EdgeInsets.only(bottom: 33, left: 20, right: 20),
                  child: Text(
                    'Every day we are getting better due to your ratings and reviews — that helps us protect your accounts.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontSize: 11,
                        color: Color(0xFF8C9297),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              if (page.value == 0)
                const Padding(
                  padding: EdgeInsets.only(bottom: 33),
                  child: Text(
                    'Become a financial expert on the go! Bid farewell to financial uncertainty!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontSize: 11,
                        color: Color(0xFF8C9297),
                        fontWeight: FontWeight.w400),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InkWell(
                  onTap: () {
                    if (page.value == 0) {
                      page.value = 1;
                      setState(() {});
                    } else if (page.value == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const MyHomePage()),
                      );
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: const Color(0xFF2B62DF),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        'Continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w800),
                      )),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Terms of use  |  Privacy Policy',
                  style: TextStyle(
                      fontFamily: 'HK Grotesk',
                      fontSize: 10,
                      color: Color(0xFF8C9297),
                      fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ),
        )
      ]),
    );
  }

  Widget getStars() {
    List<Widget> list = [];
    for (var i = 0; i < 5; i++) {
      list.add(const Icon(
        Icons.star,
        color: Colors.yellow,
        size: 16,
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }
}
