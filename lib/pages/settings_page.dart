import 'package:budget_planner/pages/home_page.dart';
import 'package:budget_planner/pages/show_screen.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  EPageOnSelect page = EPageOnSelect.settingsPage;
  @override
  Widget build(BuildContext context) {
    return getContent();
  }

  Widget getContent() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(18, 60, 18, 0),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('SETTINGS',
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        fontWeight: FontWeight.w900,
                        fontSize: 15)),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const ShowReadBudgettermss(
                          link: 'https://docs.google.com/document/d/1AlkOYnJxODVgjVdIOMpP65ZodWJab5rsT6mL-clvQaU/edit?usp=sharing',
                        )),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/privacy.png',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Privacy Policy',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const ShowReadBudgettermss(
                          link: 'https://docs.google.com/document/d/18vcCGdNCYPXWNZh41GtfybC4O74pqY9ps4Gzhb-ZjBQ/edit?usp=sharing',
                        )),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/chat.png',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Text('Terms of Use',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              InAppReview.instance.openStoreListing(
                appStoreId: '6473787749',
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/star.png',
                  ),
                  const Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Rate app',
                          style: TextStyle(
                              fontFamily: 'HK Grotesk',
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  )
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {
              // page = EPageOnSelect.ratePage;
              // setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.only(top: 7, bottom: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/bubble.png',
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text('Dark theme',
                            style: TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: Provider.of<ThemeProvider>(context).currentTheme ==
                        ThemeClass.darkTheme,
                    onChanged: (bool val) {
                      context.read<ThemeProvider>().changeCurrentTheme();
                    },
                  ),
                ],
              ),
            ),
          )
        ]));
  }
}
