// ignore_for_file: unused_import

import 'package:flutter/material.dart';

class UserItem {
  double? totalExpenses;
  double? budget;

  UserItem({
    this.totalExpenses = 0.0,
    this.budget = 0.0,
  });

  factory UserItem.fromJson(Map<String, dynamic> parsedJson) {
    return UserItem(
      totalExpenses: parsedJson['totalExpenses'] ?? 0.0,
      budget: parsedJson['budget'] ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "currentCount": totalExpenses,
      "budget": budget,
    };
  }
}
