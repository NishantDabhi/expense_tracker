// this widget is responsible for long list of expenses that will be added by used and returning ListView Widget

import 'package:expense_tracker/widgets/expenses_list/expenses_item.dart';
import 'package:flutter/material.dart';

import '../../models/expense.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key, required this.expenses, required this.onRemoveExpense});

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(context) {
    return ListView.builder(itemCount: expenses.length,  itemBuilder: (ctx, index) =>
        Dismissible(
          onDismissed: (direction) {
            onRemoveExpense(expenses[index]);
          },
            key: ValueKey(expenses[index]),
            background: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.error.withOpacity(0.5),

              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10
              ),
            ),
            child: ExpenseItem(expenses[index]))
        );
  }
}