// ignore_for_file: unused_import

import 'package:budget_planner/model/category_item.dart';
import 'package:flutter/material.dart';

class IncomeItem {
  String? description;
  DateTime? date;
  double? cost;
  ECategoryType? type;

  IncomeItem({this.description, this.date, this.cost, this.type});

  factory IncomeItem.fromJson(Map<String, dynamic> parsedJson) {
    return IncomeItem(
        description: parsedJson['description'] ?? "",
        cost: parsedJson['cost'] ?? "",
        type: ECategoryType.values.byName(parsedJson['type']),
        date: DateTime.tryParse(parsedJson['date']));
  }

  Map<String, dynamic> toJson() {
    return {
      "description": description,
      "cost": cost,
      "type": type!.name,
      "date": date.toString()
    };
  }
}
