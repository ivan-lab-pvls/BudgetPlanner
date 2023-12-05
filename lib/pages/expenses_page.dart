import 'dart:math';

import 'package:budget_planner/model/category_item.dart';
import 'package:budget_planner/model/expenses_item.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

enum EExpensesPage { addExpenses, totalExpenses }

class ExpensesPage extends StatefulWidget {
  const ExpensesPage(
      {super.key,
      required this.categoryTypeList,
      required this.callback,
      required this.expensesList});
  final List<ECategoryType> categoryTypeList;
  final Function(List<ExpensesItem>) callback;
  final List<ExpensesItem> expensesList;

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  EExpensesPage page = EExpensesPage.totalExpenses;
  TextEditingController textControllerExpenses = TextEditingController();
  TextEditingController textControllerExpensesDescription =
      TextEditingController();
  ECategoryType currentType = ECategoryType.food;
  double totalExpenses = 0.0;
  List<ExpensesItem> expensesList = [];
  @override
  Widget build(BuildContext context) {
    return page == EExpensesPage.totalExpenses
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 60, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('YOUR EXPENSES',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 15)),
                    InkWell(
                      onTap: () {
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              page = EExpensesPage.addExpenses;
                              setState(() {});
                            },
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF2B62DF),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Add expenses',
                                      style: TextStyle(
                                          fontFamily: 'HK Grotesk',
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 13, 18, 36),
                child: Divider(
                  thickness: 0.5,
                  height: 0,
                  color: Provider.of<ThemeProvider>(context).currentTheme ==
                          ThemeClass.lightTheme
                      ? const Color(0xFFF6F6F6)
                      : const Color(0xFF28364E),
                ),
              ),
              if (page == EExpensesPage.totalExpenses)
                getContent().isNotEmpty
                    ? Expanded(
                        child: SingleChildScrollView(
                            child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: getContent(),
                        ),
                      )))
                    : const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('There is no information about the receipts',
                                style: TextStyle(
                                    fontFamily: 'HK Grotesk',
                                    color: Color(0xFF8C9297),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15)),
                          ],
                        ),
                      ),
              Container(
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
                          : BoxShadow(
                              color: Colors.transparent.withOpacity(0.10))
                    ]),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 25, 15, 47),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Your total Expenses',
                              style: TextStyle(
                                  fontFamily: 'HK Grotesk',
                                  color: Color(0xFF8C9297),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11)),
                          Text('$totalExpenses\$',
                              style: const TextStyle(
                                  fontFamily: 'HK Grotesk',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
        : Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(18, 60, 18, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ADD EXPENSES',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 15)),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                child: Divider(
                  thickness: 0.5,
                  height: 0,
                  color: Provider.of<ThemeProvider>(context).currentTheme ==
                          ThemeClass.lightTheme
                      ? const Color(0xFFF6F6F6)
                      : const Color(0xFF28364E),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Provider.of<ThemeProvider>(context).currentTheme ==
                              ThemeClass.lightTheme
                          ? const Color(0xFFF5F7FA)
                          : Colors.white.withOpacity(0.15)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Enter your Expense',
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
                        keyboardType: TextInputType.number,
                        controller: textControllerExpenses,
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
                                            const Text('Enter description',
                                                style: TextStyle(
                                                    fontFamily: 'HK Grotesk',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                cursorColor:
                                                    Provider.of<ThemeProvider>(
                                                                    context)
                                                                .currentTheme ==
                                                            ThemeClass
                                                                .lightTheme
                                                        ? Colors.black
                                                        : Colors.white,
                                                style: const TextStyle(
                                                    fontFamily: 'HK Grotesk',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 15),
                                                controller:
                                                    textControllerExpensesDescription,
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
                                                        borderSide: BorderSide(
                                                            width: 1)),
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
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500))),
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
                                                    ExpensesItem expenses =
                                                        ExpensesItem();
                                                    expenses
                                                        .cost = num.tryParse(
                                                            textControllerExpenses
                                                                .text)!
                                                        .toDouble();
                                                    expenses.date =
                                                        DateTime.now();
                                                    expenses.type = currentType;
                                                    expenses.description =
                                                        textControllerExpensesDescription
                                                            .text;
                                                    expensesList.add(expenses);
                                                    widget
                                                        .callback(expensesList);
                                                    Navigator.pop(context);
                                                    page = EExpensesPage
                                                        .totalExpenses;
                                                    setState(() {});
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
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 18, 0, 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Choose categories',
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
              ))),
            ],
          );
  }

  List<Widget> getCategories() {
    List<Widget> list = [];

    for (var category in widget.categoryTypeList) {
      bool selected = currentType == category;
      list.add(InkWell(
        onTap: () {
          if (!selected) {
            selected = true;
            currentType = category;
            setState(() {});
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 13),
              child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Row(children: [
                          if (category == ECategoryType.food)
                            Image.asset('assets/icons/food.png'),
                          if (category == ECategoryType.business)
                            Image.asset('assets/icons/business.png'),
                          if (category == ECategoryType.transport)
                            Image.asset('assets/icons/transport.png'),
                          if (category == ECategoryType.beautyAndClothes)
                            Image.asset('assets/icons/beauty.png'),
                          if (category == ECategoryType.health)
                            Image.asset('assets/icons/health.png'),
                          if (category == ECategoryType.other)
                            Image.asset('assets/icons/other.png'),
                          Padding(
                            padding: const EdgeInsets.only(left: 19),
                            child: Text(category.text,
                                style: const TextStyle(
                                    fontFamily: 'HK Grotesk',
                                    fontWeight: FontWeight.w800,
                                    fontSize: 14)),
                          )
                        ]),
                      ],
                    ),
                    if (selected) Image.asset('assets/icons/selected_icon.png')
                  ],
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

  List<Widget> getContent() {
    totalExpenses = 0.0;
    List<Widget> list = [];
    for (var expense in widget.expensesList) {
      list.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/icons/expenses.png'),
                    Padding(
                      padding: const EdgeInsets.only(left: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(expense.description!,
                                  style: const TextStyle(
                                      fontFamily: 'HK Grotesk',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14)),
                              const Padding(
                                padding: EdgeInsets.only(left: 6, right: 6),
                                child: Text('\u2022',
                                    style: TextStyle(
                                        color: Color(0xFF8C9297),
                                        fontFamily: 'HK Grotesk',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                              ),
                              Text(expense.type!.text,
                                  style: const TextStyle(
                                      color: Color(0xFF8C9297),
                                      fontFamily: 'HK Grotesk',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12)),
                            ],
                          ),
                          Text(
                              DateFormat("dd MMMM, yyyy").format(expense.date!),
                              style: const TextStyle(
                                  fontFamily: 'HK Grotesk',
                                  color: Color(0xFF8C9297),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${expense.cost}',
                        style: const TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w800,
                            fontSize: 13))
                  ],
                ),
              ],
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
      totalExpenses = totalExpenses + expense.cost!;
    }
    return list;
  }
}
