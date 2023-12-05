import 'package:budget_planner/model/category_item.dart';
import 'package:budget_planner/model/transaction_item.dart';
import 'package:budget_planner/theme.dart';
import 'package:budget_planner/theme_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget(
      {super.key,
      required this.category,
      required this.isEditMode,
      required this.transactions});
  final CategoryItem category;
  final bool isEditMode;
  final List<TransactionItem> transactions;

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  TextEditingController textControllerBudget = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (widget.category.type == ECategoryType.food)
                  Image.asset('assets/icons/food.png'),
                if (widget.category.type == ECategoryType.business)
                  Image.asset('assets/icons/business.png'),
                if (widget.category.type == ECategoryType.transport)
                  Image.asset('assets/icons/transport.png'),
                if (widget.category.type == ECategoryType.beautyAndClothes)
                  Image.asset('assets/icons/beauty.png'),
                if (widget.category.type == ECategoryType.health)
                  Image.asset('assets/icons/health.png'),
                if (widget.category.type == ECategoryType.other)
                  Image.asset('assets/icons/other.png'),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 19),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(widget.category.name!,
                                  style: const TextStyle(
                                      fontFamily: 'HK Grotesk',
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14)),
                            ),
                          ],
                        ),
                        if (!widget.isEditMode)
                          Text('${widget.transactions.length} transactions',
                              style: const TextStyle(
                                  fontFamily: 'HK Grotesk',
                                  color: Color(0xFF8C9297),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11))
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (!widget.isEditMode)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Budget for this month',
                    style: TextStyle(
                        fontFamily: 'HK Grotesk',
                        color: Color(0xFF8C9297),
                        fontWeight: FontWeight.w700,
                        fontSize: 11)),
                Row(
                  children: [
                    widget.category.currentCount == null
                        ? Text('\$0',
                            style: TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w800,
                                color: widget.category.type ==
                                        ECategoryType.food
                                    ? const Color(0xFFFF9100)
                                    : widget.category.type ==
                                            ECategoryType.transport
                                        ? const Color(0xFF00D422)
                                        : widget.category.type ==
                                                ECategoryType.beautyAndClothes
                                            ? const Color(0xFFB336FF)
                                            : widget.category.type ==
                                                    ECategoryType.business
                                                ? const Color(0xFFD5DA00)
                                                : widget.category.type ==
                                                        ECategoryType.health
                                                    ? const Color(0xFF4FA0FF)
                                                    : const Color(0xFFA6A6A6),
                                fontSize: 14))
                        : Text('\$${widget.category.currentCount}',
                            style: const TextStyle(
                                fontFamily: 'HK Grotesk',
                                fontWeight: FontWeight.w800,
                                fontSize: 14)),
                    const Text('/',
                        style: TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w800,
                            fontSize: 14)),
                    Text('\$${widget.category.totalCount}',
                        style: const TextStyle(
                            fontFamily: 'HK Grotesk',
                            fontWeight: FontWeight.w800,
                            fontSize: 14)),
                  ],
                ),
              ],
            ),
          if (widget.isEditMode)
            Expanded(
              child: TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                controller: textControllerBudget,
                textAlign: TextAlign.end,
                cursorColor: Provider.of<ThemeProvider>(context).currentTheme ==
                        ThemeClass.lightTheme
                    ? Colors.black
                    : Colors.white,
                style: const TextStyle(
                    fontFamily: 'HK Grotesk',
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    fontSize: 11),
                decoration: const InputDecoration(
                  hintText: 'Enter monthly budget',
                  border: InputBorder.none,
                ),
                onEditingComplete: () {
                  widget.category.totalCount =
                      num.tryParse(textControllerBudget.text)!.toDouble();
                  setState(() {});
                },
              ),
            )
        ],
      ),
    );
  }
}
