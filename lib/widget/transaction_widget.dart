// ignore_for_file: unused_import

import 'package:budget_planner/model/category_item.dart';
import 'package:budget_planner/model/transaction_item.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionWidget extends StatefulWidget {
  const TransactionWidget({super.key, required this.transaction});
  final TransactionItem transaction;

  @override
  State<TransactionWidget> createState() => _TransactionWidgetState();
}

class _TransactionWidgetState extends State<TransactionWidget> {
  TextEditingController textControllerBudget = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.transaction.description!,
                style: const TextStyle(
                    fontFamily: 'HK Grotesk',
                    fontWeight: FontWeight.w800,
                    fontSize: 14)),
            Text(DateFormat("dd MMMM, yyyy").format(widget.transaction.date!),
                style: const TextStyle(
                    fontFamily: 'HK Grotesk',
                    color: Color(0xFF8C9297),
                    fontWeight: FontWeight.w500,
                    fontSize: 11)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('\$${widget.transaction.cost}',
                style: const TextStyle(
                    fontFamily: 'HK Grotesk',
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFCE2828),
                    fontSize: 13))
          ],
        ),
      ],
    );
  }
}
