import 'dart:convert';

import 'package:budget_planner/model/category_item.dart';
import 'package:budget_planner/model/expenses_item.dart';
import 'package:budget_planner/model/income_item.dart';
import 'package:budget_planner/model/transaction_item.dart';
import 'package:budget_planner/model/user_item.dart';
import 'package:budget_planner/pages/expenses_page.dart';
import 'package:budget_planner/pages/income_page.dart';
import 'package:budget_planner/pages/settings_page.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:budget_planner/widget/category_widget.dart';
import 'package:budget_planner/widget/transaction_widget.dart';
import 'package:datepicker_dropdown/datepicker_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EPageOnSelect {
  budgetPage,
  incomePage,
  expensesPage,
  settingsPage,
  categoryPage
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SharedPreferences prefs;
  EPageOnSelect page = EPageOnSelect.budgetPage;
  UserItem user = UserItem();
  TextEditingController textControlleronBudgetPage = TextEditingController();
  TextEditingController textControlleronCategoryPage = TextEditingController();
  TextEditingController textControllerName = TextEditingController();
  TextEditingController textControllerBudget = TextEditingController();
  TextEditingController textControllerTransactionDescription =
      TextEditingController();
  DateTime _selectedDate = DateTime.now();
  DateTime filterDate = DateTime.now();
  List<ECategoryType> categoryTypeList = [
    ECategoryType.food,
    ECategoryType.beautyAndClothes,
    ECategoryType.business,
    ECategoryType.health,
    ECategoryType.transport,
    ECategoryType.other
  ];
  bool isEditMode = false;
  bool isEditCategoryMode = false;
  ECategoryType? currentSelectedValue;
  List<CategoryItem> categoryList = [];
  List<TransactionItem> transactionList = [];
  CategoryItem currentCategory = CategoryItem();
  List<ExpensesItem> expensesList = [];
  List<IncomeItem> incomeList = [];
  @override
  void initState() {
    super.initState();

    getSP();
  }

  Future<void> addToSP(
      List<CategoryItem>? categoryList,
      List<ExpensesItem>? expensesList,
      List<IncomeItem>? incomeList,
      List<TransactionItem>? transactionList,
      UserItem? user) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    if (categoryList != null) {
      prefs.setString('categoriesLists', jsonEncode(categoryList));
    }
    if (user != null) {
      prefs.setString('user', jsonEncode(user));
    }
    if (expensesList != null) {
      prefs.setString('expensesLists', jsonEncode(expensesList));
    }
    if (incomeList != null) {
      prefs.setString('incomeLists', jsonEncode(incomeList));
    }
    if (transactionList != null) {
      prefs.setString('transactionLists', jsonEncode(transactionList));
    }
  }

  void getSP() async {
    final prefs = await SharedPreferences.getInstance();
    final List<dynamic> jsonData1 =
        jsonDecode(prefs.getString('categoriesLists') ?? '[]');
    final List<dynamic> jsonData2 =
        jsonDecode(prefs.getString('expensesLists') ?? '[]');
    final List<dynamic> jsonData3 =
        jsonDecode(prefs.getString('incomeLists') ?? '[]');
    final List<dynamic> jsonData4 =
        jsonDecode(prefs.getString('transactionLists') ?? '[]');
    if (prefs.getString('user') != null) {
      Map<String, dynamic> userMap = jsonDecode(prefs.getString('user')!);
      user = UserItem.fromJson(userMap);
    }
    categoryList = jsonData1.map<CategoryItem>((jsonList) {
      {
        return CategoryItem.fromJson(jsonList);
      }
    }).toList();
    expensesList = jsonData2.map<ExpensesItem>((jsonList) {
      {
        return ExpensesItem.fromJson(jsonList);
      }
    }).toList();
    incomeList = jsonData3.map<IncomeItem>((jsonList) {
      {
        return IncomeItem.fromJson(jsonList);
      }
    }).toList();
    transactionList = jsonData4.map<TransactionItem>((jsonList) {
      {
        return TransactionItem.fromJson(jsonList);
      }
    }).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    user.totalExpenses = 0.0;
    for (var category in categoryList) {
      user.totalExpenses = user.totalExpenses! + category.currentCount!;
    }
    return Scaffold(
        body: Center(
      child: page == EPageOnSelect.budgetPage

          /// Main page
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 60, 18, 0),
                        child: !isEditMode
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!isEditMode)
                                    const Text('YOUR BUDGET',
                                        style: TextStyle(
                                            fontFamily: 'HK Grotesk',
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15)),
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Dialog(
                                                    child: SizedBox(
                                                      width: 300,
                                                      height: 200,
                                                      child:
                                                          CupertinoDatePicker(
                                                        mode:
                                                            CupertinoDatePickerMode
                                                                .date,
                                                        initialDateTime:
                                                            _selectedDate,
                                                        onDateTimeChanged:
                                                            (DateTime newDate) {
                                                          setState(() {
                                                            filterDate =
                                                                newDate;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ));
                                    },
                                    child: Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Text('November',
                                              style: TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF8C9297),
                                                  fontSize: 11)),
                                        ),
                                        Image.asset(
                                            'assets/icons/arrow-down.png')
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  isEditMode = false;
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/icons/chevron_left.png'),
                                        const Text('Back to main',
                                            style: TextStyle(
                                                fontFamily: 'HK Grotesk',
                                                color: Color(0xFF8C9297),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13)),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (textControlleronBudgetPage
                                            .text.isNotEmpty) {
                                          user.budget = num.tryParse(
                                                  textControlleronBudgetPage
                                                      .text)!
                                              .toDouble();
                                        }
                                        addToSP(categoryList, expensesList,
                                            incomeList, transactionList, user);
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 2, 8, 2),
                                        decoration: BoxDecoration(
                                            color: textControlleronBudgetPage
                                                    .text.isEmpty
                                                ? Provider.of<ThemeProvider>(
                                                                context)
                                                            .currentTheme ==
                                                        ThemeClass.lightTheme
                                                    ? const Color(0xFFE7E7E7)
                                                    : const Color(0xFFE7E7E7)
                                                        .withOpacity(0.15)
                                                : user.budget ==
                                                        num.tryParse(
                                                                textControlleronBudgetPage
                                                                    .text)!
                                                            .toInt()
                                                    ? const Color(0xFF2B62DF)
                                                    : Provider.of<ThemeProvider>(
                                                                    context)
                                                                .currentTheme ==
                                                            ThemeClass
                                                                .lightTheme
                                                        ? const Color(
                                                            0xFFE7E7E7)
                                                        : const Color(0xFFE7E7E7)
                                                            .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(50)),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Text('Save',
                                                  style: TextStyle(
                                                      fontFamily: 'HK Grotesk',
                                                      color: Color(0xFF8C9297),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 11)),
                                            ),
                                            Icon(
                                              Icons.check,
                                              size: 14,
                                              color: Color(0xFF8C9297),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 13),
                        child: Divider(
                          thickness: 0.5,
                          height: 0,
                          color: Provider.of<ThemeProvider>(context)
                                      .currentTheme ==
                                  ThemeClass.lightTheme
                              ? const Color(0xFFF6F6F6)
                              : const Color(0xFF28364E),
                        ),
                      ),
                      if (!isEditMode)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 13),
                                  child: Text('Your budget for this month',
                                      style: TextStyle(
                                          fontFamily: 'HK Grotesk',
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF8C9297),
                                          fontSize: 11)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 7),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text('\$${user.totalExpenses}',
                                              style: const TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 16)),
                                          const Text('/',
                                              style: TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF8C9297),
                                                  fontSize: 16)),
                                          Text('${user.budget}',
                                              style: const TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w800,
                                                  color: Color(0xFF8C9297),
                                                  fontSize: 16))
                                        ],
                                      ),
                                      InkWell(
                                          onTap: () {
                                            if (isEditMode) {
                                              isEditMode = false;
                                              setState(() {});
                                            } else {
                                              isEditMode = true;
                                              setState(() {});
                                            }
                                          },
                                          child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: Image.asset(
                                                'assets/icons/edit-2.png'),
                                          ))
                                    ],
                                  ),
                                ),
                                LinearPercentIndicator(
                                  padding: const EdgeInsets.all(0),
                                  lineHeight: 24,
                                  percent: user.totalExpenses == 0.0
                                      ? 0
                                      : user.totalExpenses!.toInt() /
                                          user.budget!.toInt(),
                                  progressColor: const Color(0xFF2B62DF),
                                  backgroundColor:
                                      Provider.of<ThemeProvider>(context)
                                                  .currentTheme ==
                                              ThemeClass.lightTheme
                                          ? const Color(0xFFF6F6F6)
                                          : Colors.white.withOpacity(0.15),
                                ),
                              ]),
                        ),
                      if (!isEditMode)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 59),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 14, bottom: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Your categories',
                                            style: TextStyle(
                                                fontFamily: 'HK Grotesk',
                                                color: Color(0xFF8C9297),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  ...getCategories()
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (isEditMode)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Provider.of<ThemeProvider>(context)
                                            .currentTheme ==
                                        ThemeClass.lightTheme
                                    ? const Color(0xFFF5F7FA)
                                    : Colors.white.withOpacity(0.15)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text('Enter your monthly budget',
                                    style: TextStyle(
                                        fontFamily: 'HK Grotesk',
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: Color(0xFF8C9297),
                                        fontSize: 10)),
                                TextField(
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  cursorColor:
                                      Provider.of<ThemeProvider>(context)
                                                  .currentTheme ==
                                              ThemeClass.lightTheme
                                          ? Colors.black
                                          : Colors.white,
                                  keyboardType: TextInputType.number,
                                  controller: textControlleronBudgetPage,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontFamily: 'HK Grotesk',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 36),
                                  decoration: const InputDecoration(
                                    hintText: '\$',
                                    border: InputBorder.none,
                                  ),
                                  onEditingComplete: () {
                                    setState(() {});
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      if (isEditMode)
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 59),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 14, bottom: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('Your categories',
                                            style: TextStyle(
                                                fontFamily: 'HK Grotesk',
                                                color: Color(0xFF8C9297),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                  ...getCategories()
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                customBottomNavigation()
              ],
            )

          ///Settings Page
          : page == EPageOnSelect.settingsPage
              ? Column(
                  children: [
                    const Expanded(child: SettingsPage()),
                    customBottomNavigation()
                  ],
                )

              ///Category Page
              : page == EPageOnSelect.categoryPage
                  ? Column(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(18, 60, 18, 0),
                          child: Column(
                            children: [
                              InkWell(
                                  onTap: () {
                                    page = EPageOnSelect.budgetPage;
                                    setState(() {});
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                              'assets/icons/chevron_left.png'),
                                          const Text('Back to main',
                                              style: TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  color: Color(0xFF8C9297),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13)),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (textControlleronCategoryPage
                                              .text.isNotEmpty) {
                                            currentCategory
                                                .totalCount = num.tryParse(
                                                    textControlleronCategoryPage
                                                        .text)!
                                                .toDouble();
                                            isEditCategoryMode = false;
                                          }
                                          addToSP(
                                              categoryList,
                                              expensesList,
                                              incomeList,
                                              transactionList,
                                              user);
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 2, 8, 2),
                                          decoration: BoxDecoration(
                                              color: textControlleronCategoryPage
                                                          .text.isEmpty ||
                                                      !isEditCategoryMode
                                                  ? Provider.of<ThemeProvider>(context)
                                                              .currentTheme ==
                                                          ThemeClass.lightTheme
                                                      ? const Color(0xFFE7E7E7)
                                                      : const Color(0xFFE7E7E7)
                                                          .withOpacity(0.15)
                                                  : currentCategory.totalCount ==
                                                          num.tryParse(
                                                                  textControlleronCategoryPage
                                                                      .text)!
                                                              .toInt()
                                                      ? const Color(0xFF2B62DF)
                                                      : Provider.of<ThemeProvider>(
                                                                      context)
                                                                  .currentTheme ==
                                                              ThemeClass
                                                                  .lightTheme
                                                          ? const Color(
                                                              0xFFE7E7E7)
                                                          : const Color(0xFFE7E7E7)
                                                              .withOpacity(0.15),
                                              borderRadius: BorderRadius.circular(50)),
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 10),
                                                child: Text('Save',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'HK Grotesk',
                                                        color:
                                                            Color(0xFF8C9297),
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 11)),
                                              ),
                                              Icon(
                                                Icons.check,
                                                size: 14,
                                                color: Color(0xFF8C9297),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 13),
                                child: Divider(
                                  thickness: 0.5,
                                  height: 0,
                                  color: Provider.of<ThemeProvider>(context)
                                              .currentTheme ==
                                          ThemeClass.lightTheme
                                      ? const Color(0xFFF6F6F6)
                                      : const Color(0xFF28364E),
                                ),
                              ),
                              if (!isEditCategoryMode)
                                Container(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 13),
                                          child: Text(
                                              'Your budget for this month',
                                              style: TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w700,
                                                  color: Color(0xFF8C9297),
                                                  fontSize: 11)),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 7),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  currentCategory.currentCount !=
                                                          null
                                                      ? Text('\$${currentCategory.currentCount}',
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'HK Grotesk',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 16))
                                                      : const Text('\$${0}',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'HK Grotesk',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 16)),
                                                  const Text('/',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'HK Grotesk',
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Color(0xFF8C9297),
                                                          fontSize: 16)),
                                                  Text(
                                                      '${currentCategory.totalCount}',
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              'HK Grotesk',
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              Color(0xFF8C9297),
                                                          fontSize: 16))
                                                ],
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    if (isEditCategoryMode) {
                                                      isEditCategoryMode =
                                                          false;
                                                      setState(() {});
                                                    } else {
                                                      isEditCategoryMode = true;
                                                      setState(() {});
                                                    }
                                                  },
                                                  child: SizedBox(
                                                    width: 40,
                                                    height: 40,
                                                    child: Image.asset(
                                                        'assets/icons/edit-2.png'),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        LinearPercentIndicator(
                                          padding: const EdgeInsets.all(0),
                                          lineHeight: 24,
                                          percent: currentCategory
                                                      .currentCount !=
                                                  null
                                              ? currentCategory.currentCount! /
                                                  currentCategory.totalCount!
                                              : 0,
                                          progressColor:
                                              const Color(0xFF2B62DF),
                                          backgroundColor:
                                              Provider.of<ThemeProvider>(
                                                              context)
                                                          .currentTheme ==
                                                      ThemeClass.lightTheme
                                                  ? const Color(0xFFF6F6F6)
                                                  : Colors.white
                                                      .withOpacity(0.15),
                                        ),
                                      ]),
                                ),
                              if (isEditCategoryMode)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                        color:
                                            Provider.of<ThemeProvider>(context)
                                                        .currentTheme ==
                                                    ThemeClass.lightTheme
                                                ? const Color(0xFFF5F7FA)
                                                : Colors.white
                                                    .withOpacity(0.15)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Text('Enter your monthly budget',
                                            style: TextStyle(
                                                fontFamily: 'HK Grotesk',
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.italic,
                                                color: Color(0xFF8C9297),
                                                fontSize: 10)),
                                        TextField(
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          cursorColor:
                                              Provider.of<ThemeProvider>(
                                                              context)
                                                          .currentTheme ==
                                                      ThemeClass.lightTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                          keyboardType: TextInputType.number,
                                          controller:
                                              textControlleronCategoryPage,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontFamily: 'HK Grotesk',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 36),
                                          decoration: const InputDecoration(
                                            hintText: '\$',
                                            border: InputBorder.none,
                                          ),
                                          onEditingComplete: () {
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 32),
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 18),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text('Transactions',
                                                  style: TextStyle(
                                                      fontFamily: 'HK Grotesk',
                                                      color: Color(0xFF8C9297),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 11)),
                                            ],
                                          ),
                                        ),
                                        ...getTransaction()
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      customBottomNavigation()
                    ])
                  : page == EPageOnSelect.expensesPage
                      ? Column(
                          children: [
                            Expanded(
                                child: ExpensesPage(
                              categoryTypeList: categoryTypeList,
                              callback: (expenses) {
                                expensesList.addAll(expenses);
                                addToSP(categoryList, expensesList, incomeList,
                                    transactionList, user);
                                setState(() {});
                              },
                              expensesList: expensesList,
                            )),
                            customBottomNavigation()
                          ],
                        )
                      : page == EPageOnSelect.incomePage
                          ? Column(
                              children: [
                                Expanded(
                                  child: IncomePage(
                                      incomeList: incomeList,
                                      categoryTypeList: categoryTypeList,
                                      callback: (income) {
                                        incomeList.addAll(income);
                                        addToSP(categoryList, expensesList,
                                            incomeList, transactionList, user);
                                        setState(() {});
                                      }),
                                ),
                                customBottomNavigation()
                              ],
                            )
                          : const SizedBox(),
    ));
  }

  Widget customBottomNavigation() {
    return Row(
      children: [
        Expanded(
          child: Stack(
              alignment: Alignment.topCenter,
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).currentTheme ==
                              ThemeClass.lightTheme
                          ? Colors.white
                          : Colors.white.withOpacity(0.15),
                      boxShadow: [
                        Provider.of<ThemeProvider>(context).currentTheme ==
                                ThemeClass.lightTheme
                            ? BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.5), //color of shadow
                                spreadRadius: 5, //spread radius
                                blurRadius: 7, // blur radius
                                offset: const Offset(
                                    0, 2), // changes position of shadow
                                //first paramerter of offset is left-right
                                //second parameter is top to down
                              )
                            : const BoxShadow(color: Colors.transparent)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            onTap: () {
                              page = EPageOnSelect.budgetPage;
                              setState(() {});
                            },
                            child: page == EPageOnSelect.budgetPage ||
                                    page == EPageOnSelect.categoryPage
                                ? Image.asset(
                                    'assets/icons/selected-document-text.png',
                                  )
                                : Image.asset(
                                    'assets/icons/document-text.png',
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: InkWell(
                          onTap: () {
                            page = EPageOnSelect.incomePage;
                            setState(() {});
                          },
                          child: page == EPageOnSelect.incomePage
                              ? Image.asset(
                                  'assets/icons/selected-wallet-add.png',
                                )
                              : Image.asset(
                                  'assets/icons/wallet-add.png',
                                ),
                        ),
                      ),
                      const SizedBox(
                        width: 88,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            onTap: () {
                              page = EPageOnSelect.expensesPage;
                              setState(() {});
                            },
                            child: page == EPageOnSelect.expensesPage
                                ? Image.asset(
                                    'assets/icons/selected-wallet-remove.png',
                                  )
                                : Image.asset(
                                    'assets/icons/wallet-remove.png',
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20, left: 20),
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: InkWell(
                            onTap: () {
                              page = EPageOnSelect.settingsPage;
                              setState(() {});
                            },
                            child: page == EPageOnSelect.settingsPage
                                ? Image.asset(
                                    'assets/icons/selected-menu.png',
                                  )
                                : Image.asset(
                                    'assets/icons/menu.png',
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -30,
                  child: InkWell(
                    onTap: () {
                      if (page == EPageOnSelect.budgetPage) {
                        showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  content: Card(
                                    // color: Provider.of<ThemeProvider>(context)
                                    //             .currentTheme ==
                                    //         ThemeClass.lightTheme
                                    //     ? Colors.white
                                    //     : const Color(0xFF0A1A35),
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    child: Column(children: [
                                      const Text('Enter new category',
                                          style: TextStyle(
                                              fontFamily: 'HK Grotesk',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FormField<ECategoryType>(
                                          builder:
                                              (FormFieldState<ECategoryType>
                                                  state) {
                                            return InputDecorator(
                                              decoration: InputDecoration(
                                                  labelStyle: const TextStyle(),
                                                  errorStyle: const TextStyle(
                                                      color: Colors.redAccent,
                                                      fontSize: 16.0),
                                                  hintText:
                                                      'Please select expense',
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0))),
                                              isEmpty:
                                                  currentSelectedValue == '',
                                              child:
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton<
                                                    ECategoryType>(
                                                  value: currentSelectedValue,
                                                  isDense: true,
                                                  onChanged: (ECategoryType?
                                                      newValue) {
                                                    setState(() {
                                                      currentSelectedValue =
                                                          newValue;
                                                      state.didChange(newValue);
                                                    });
                                                  },
                                                  items: categoryTypeList.map(
                                                      (ECategoryType value) {
                                                    return DropdownMenuItem<
                                                        ECategoryType>(
                                                      value: value,
                                                      child: Text(value.text,
                                                          style: const TextStyle(
                                                              fontFamily:
                                                                  'HK Grotesk',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 15)),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextField(
                                          keyboardType: TextInputType.number,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          cursorColor:
                                              Provider.of<ThemeProvider>(
                                                              context)
                                                          .currentTheme ==
                                                      ThemeClass.lightTheme
                                                  ? Colors.black
                                                  : Colors.white,
                                          style: const TextStyle(
                                              fontFamily: 'HK Grotesk',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                          controller: textControllerBudget,
                                          decoration: InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Provider.of<ThemeProvider>(
                                                                    context)
                                                                .currentTheme ==
                                                            ThemeClass
                                                                .lightTheme
                                                        ? Colors.black
                                                        : Colors.white,
                                                    width: 1.0),
                                              ),
                                              border: const OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                  borderSide:
                                                      BorderSide(width: 1)),
                                              label: Text(
                                                  'Budget for this month ',
                                                  style: TextStyle(
                                                      fontFamily: 'HK Grotesk',
                                                      color: Provider.of<ThemeProvider>(
                                                                      context)
                                                                  .currentTheme ==
                                                              ThemeClass
                                                                  .lightTheme
                                                          ? Colors.black
                                                          : Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ),
                                      ),
                                    ]),
                                  ),
                                  actions: [
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 0.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'HK Grotesk',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15))),
                                            InkWell(
                                                onTap: () {
                                                  CategoryItem category =
                                                      CategoryItem();
                                                  category.name =
                                                      currentSelectedValue!
                                                          .text;
                                                  category.type =
                                                      currentSelectedValue;
                                                  category
                                                      .totalCount = num.tryParse(
                                                          textControllerBudget
                                                              .text)!
                                                      .toDouble();
                                                  category.date =
                                                      DateTime.now();
                                                  categoryList.add(category);
                                                  addToSP(
                                                      categoryList,
                                                      expensesList,
                                                      incomeList,
                                                      transactionList,
                                                      user);
                                                  setState(() {});
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Save',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'HK Grotesk',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15)))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                      } else if (page == EPageOnSelect.categoryPage) {
                        showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  content: Card(
                                    color: Colors.transparent,
                                    elevation: 0.0,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text('Enter new transaction',
                                              style: TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15)),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              cursorColor:
                                                  Provider.of<ThemeProvider>(
                                                                  context)
                                                              .currentTheme ==
                                                          ThemeClass.lightTheme
                                                      ? Colors.black
                                                      : Colors.white,
                                              style: const TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                              controller:
                                                  textControllerTransactionDescription,
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Provider.of<ThemeProvider>(
                                                                        context)
                                                                    .currentTheme ==
                                                                ThemeClass
                                                                    .lightTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                        width: 1.0),
                                                  ),
                                                  border: const OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  15)),
                                                      borderSide:
                                                          BorderSide(width: 1)),
                                                  label: Text(
                                                      'Enter description',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'HK Grotesk',
                                                          color: Provider.of<ThemeProvider>(
                                                                          context)
                                                                      .currentTheme ==
                                                                  ThemeClass
                                                                      .lightTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              cursorColor:
                                                  Provider.of<ThemeProvider>(
                                                                  context)
                                                              .currentTheme ==
                                                          ThemeClass.lightTheme
                                                      ? Colors.black
                                                      : Colors.white,
                                              style: const TextStyle(
                                                  fontFamily: 'HK Grotesk',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15),
                                              controller: textControllerBudget,
                                              decoration: InputDecoration(
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color: Provider.of<ThemeProvider>(
                                                                        context)
                                                                    .currentTheme ==
                                                                ThemeClass
                                                                    .lightTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                        width: 1.0),
                                                  ),
                                                  border:
                                                      const OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      15)),
                                                          borderSide:
                                                              BorderSide(
                                                                  width: 1)),
                                                  label: Text('Enter cost',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'HK Grotesk',
                                                          color: Provider.of<ThemeProvider>(
                                                                          context)
                                                                      .currentTheme ==
                                                                  ThemeClass
                                                                      .lightTheme
                                                              ? Colors.black
                                                              : Colors.white,
                                                          fontWeight: FontWeight
                                                              .w500))),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 500,
                                            height: 100,
                                            child: CupertinoTheme(
                                              data: CupertinoThemeData(
                                                textTheme: CupertinoTextThemeData(
                                                    dateTimePickerTextStyle: TextStyle(
                                                        color: Provider.of<ThemeProvider>(
                                                                        context)
                                                                    .currentTheme ==
                                                                ThemeClass
                                                                    .lightTheme
                                                            ? Colors.black
                                                            : Colors.white,
                                                        fontFamily:
                                                            'HK Grotesk',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15)),
                                              ),
                                              child: CupertinoDatePicker(
                                                mode: CupertinoDatePickerMode
                                                    .date,
                                                itemExtent: 50,
                                                initialDateTime: _selectedDate,
                                                onDateTimeChanged:
                                                    (DateTime newDate) {
                                                  setState(() {
                                                    _selectedDate = newDate;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ]),
                                  ),
                                  actions: [
                                    Card(
                                      color: Colors.transparent,
                                      elevation: 0.0,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 14),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'HK Grotesk',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15))),
                                            InkWell(
                                                onTap: () {
                                                  if (user.budget != 0.0) {
                                                    TransactionItem
                                                        transaction =
                                                        TransactionItem();
                                                    transaction.description =
                                                        textControllerTransactionDescription
                                                            .text;
                                                    transaction.type =
                                                        currentCategory.type;
                                                    transaction
                                                        .cost = num.tryParse(
                                                            textControllerBudget
                                                                .text)!
                                                        .toDouble();
                                                    transaction.date =
                                                        _selectedDate;
                                                    transactionList
                                                        .add(transaction);

                                                    currentCategory
                                                            .currentCount =
                                                        currentCategory
                                                                .currentCount! +
                                                            transaction.cost!;
                                                    addToSP(
                                                        categoryList,
                                                        expensesList,
                                                        incomeList,
                                                        transactionList,
                                                        user);
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  } else {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            CupertinoAlertDialog(
                                                              content:
                                                                  const Column(
                                                                      children: [
                                                                    Text(
                                                                        'Your total budget is 0. Please enter budget first!',
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'HK Grotesk',
                                                                            color:
                                                                                Colors.red,
                                                                            fontWeight: FontWeight.w400,
                                                                            fontSize: 15))
                                                                  ]),
                                                              actions: [
                                                                Card(
                                                                  color: Colors
                                                                      .transparent,
                                                                  elevation:
                                                                      0.0,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'Ok',
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              fontFamily: 'HK Grotesk',
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 15)),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ));
                                                  }
                                                },
                                                child: const Text('Save',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'HK Grotesk',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 15)))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                      } else if (page == EPageOnSelect.incomePage) {}
                    },
                    child: Image.asset('assets/icons/add_button.png'),
                  ),
                )
              ]),
        ),
      ],
    );
  }

  List<Widget> getCategories() {
    List<Widget> list = [];
    for (var category in categoryList
        .where((element) => element.date!.month == filterDate.month)) {
      list.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                currentCategory = category;
                page = EPageOnSelect.categoryPage;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: CategoryWidget(
                  transactions: transactionList
                      .where((element) => element.type == category.type)
                      .toList(),
                  category: category,
                  isEditMode: isEditMode,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Divider(
                thickness: 0.5,
                height: 0,
                color: Provider.of<ThemeProvider>(context).currentTheme ==
                        ThemeClass.lightTheme
                    ? const Color(0xFFF6F6F6)
                    : const Color(0xFF28364E),
              ),
            )
          ],
        ),
      ));
    }

    return list;
  }

  List<Widget> getTransaction() {
    List<Widget> list = [];

    for (var transaction in transactionList
        .where((element) => element.type == currentCategory.type)) {
      list.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: TransactionWidget(
              transaction: transaction,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Divider(
              thickness: 0.5,
              height: 0,
              color: Provider.of<ThemeProvider>(context).currentTheme ==
                      ThemeClass.lightTheme
                  ? const Color(0xFFF6F6F6)
                  : const Color(0xFF28364E),
            ),
          )
        ],
      ));
    }
    return list;
  }
}
