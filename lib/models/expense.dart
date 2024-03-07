import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';


final formatter  = DateFormat.yMd();
const uuid = Uuid();
enum Category { food, travel, leisure, work }

const categoryIcons = {
  Category.food : Icons.fastfood_rounded,
  Category.travel : Icons.flight_takeoff,
  Category.leisure : Icons.movie_creation_outlined,
  Category.work : Icons.work_history_outlined
};

class Expense {
Expense({
  required this.title,
  required this.amount,
  required this.date,
  required this.category
}) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  String get formattedDate {
    return formatter.format(date);
  }

}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.expenses,
});

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
    : expenses = allExpense.where((expense) => expense.category == category).toList();

  final Category category;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;

    for(final expense in expenses) {
      sum += expense.amount;
    }

    return sum;
  }
}


// this is data model which is used to store all details of 1 Expense data