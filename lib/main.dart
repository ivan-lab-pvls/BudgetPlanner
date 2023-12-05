import 'package:budget_planner/pages/splash_page.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/config.dart';
import 'model/notifx.dart';
import 'pages/onBoarding_page.dart';
import 'pages/show_screen.dart';

int? initScreen;
late SharedPreferences prefs;
final rateCallView = InAppReview.instance;
final remoteConfig = FirebaseRemoteConfig.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  await Firebase.initializeApp(options: Configs.currentPlatform);
  await remoteConfig.fetchAndActivate();
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(seconds: 5),
    minimumFetchInterval: const Duration(seconds: 5),
  ));
  await NotiCoax().activate();
  prefs = await SharedPreferences.getInstance();
  await starCallRt();
  runApp(ChangeNotifierProvider(
      create: (context) => DarkMode(), child: const MyApp()));
}

Future<void> starCallRt() async {
  bool isRated = prefs.getBool('rate') ?? false;
  if (!isRated) {
    if (await rateCallView.isAvailable()) {
      rateCallView.requestReview();
      await prefs.setBool('rate', true);
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
          builder: (context, ThemeProvider notifier, child) {
        return FutureBuilder<bool>(
          future: getBudgetData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return MaterialApp(
                home: Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                      child: Container(
                    height: 80,
                    width: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset('assets/icons/modeLoad.png'),
                    ),
                  )),
                ),
              );
            } else {
              if (snapshot.data ?? false) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Dark Mode',
                  theme: notifier.currentTheme,
                  home: ShowReadBudgetterms(
                    link: showBudgettext!,
                  ),
                );
              } else {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Dark Mode',
                  theme: notifier.currentTheme,
                  home: const SplachScreen(),
                );
              }
            }
          },
        );
      }),
    );
  }
}

class DarkMode with ChangeNotifier {
  bool darkMode = true;
  changemode() {
    darkMode = !darkMode;
    notifyListeners();
  }
}
