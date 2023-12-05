// ignore_for_file: unrelated_type_equality_checks

import 'package:budget_planner/model/category_item.dart';
import 'package:budget_planner/model/income_item.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class IncomePage extends StatefulWidget {
  const IncomePage(
      {super.key,
      required this.callback,
      required this.incomeList,
      required this.categoryTypeList});
  final Function(List<IncomeItem>) callback;
  final List<IncomeItem> incomeList;
  final List<ECategoryType> categoryTypeList;

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  double totalIncome = 0.0;
  TextEditingController textControllerIncome = TextEditingController();
  TextEditingController textControllerIncomeDescription =
      TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ECategoryType? currentSelectedValue;
  List<IncomeItem> incomeList = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 60, 18, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('YOUR INCOME',
                  style: TextStyle(
                      fontFamily: 'HK Grotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
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
                                        const Text('Enter new income',
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
                                                textControllerIncomeDescription,
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
                                                label: Text('Enter description',
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
                                                            FontWeight.w500))),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            keyboardType: TextInputType.number,
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
                                            controller: textControllerIncome,
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
                                                        fontWeight:
                                                            FontWeight.w500))),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: FormField<ECategoryType>(
                                            builder:
                                                (FormFieldState<ECategoryType>
                                                    state) {
                                              return InputDecorator(
                                                decoration: InputDecoration(
                                                    labelStyle:
                                                        const TextStyle(),
                                                    errorStyle: const TextStyle(
                                                        color: Colors.redAccent,
                                                        fontSize: 16.0),
                                                    hintText:
                                                        'Please select expense',
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
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
                                                        state.didChange(
                                                            newValue);
                                                      });
                                                    },
                                                    items: widget
                                                        .categoryTypeList
                                                        .map((ECategoryType
                                                            value) {
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
                                                      fontFamily: 'HK Grotesk',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15)),
                                            ),
                                            child: CupertinoDatePicker(
                                              mode:
                                                  CupertinoDatePickerMode.date,
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
                                                      fontFamily: 'HK Grotesk',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15))),
                                          InkWell(
                                              onTap: () {
                                                IncomeItem expenses =
                                                    IncomeItem();
                                                expenses.cost = num.tryParse(
                                                        textControllerIncome
                                                            .text)!
                                                    .toDouble();
                                                expenses.date = DateTime.now();
                                                expenses.type =
                                                    currentSelectedValue;
                                                expenses.description =
                                                    textControllerIncomeDescription
                                                        .text;
                                                incomeList.add(expenses);
                                                widget.callback(incomeList);
                                                Navigator.pop(context);
                                                setState(() {});
                                              },
                                              child: const Text('Save',
                                                  style: TextStyle(
                                                      fontFamily: 'HK Grotesk',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 15)))
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ));
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
                          Text('Add income',
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
        getContent().isNotEmpty
            ? Expanded(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Column(
                          children: [...getContent()],
                        ))))
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
                        color: Colors.grey.withOpacity(0.5), //color of shadow
                        spreadRadius: 5, //spread radius
                        blurRadius: 7, // blur radius
                        offset:
                            const Offset(0, 2), // changes position of shadow
                        //first paramerter of offset is left-right
                        //second parameter is top to down
                      )
                    : BoxShadow(color: Colors.transparent.withOpacity(0.10))
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 47),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Your total income',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            color: Color(0xFF8C9297),
                            fontWeight: FontWeight.w600,
                            fontSize: 11)),
                    Text('$totalIncome\$',
                        style: const TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w800,
                            fontSize: 16))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> getContent() {
    totalIncome = 0.0;
    List<Widget> list = [];
    for (var expense in widget.incomeList) {
      list.add(Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 13),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/icons/income.png'),
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
      totalIncome = totalIncome + expense.cost!;
    }
    return list;
  }
}
