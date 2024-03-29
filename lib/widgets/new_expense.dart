import 'dart:convert';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

final formatter  = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
    final _titleController = TextEditingController();
    final _amountController = TextEditingController();
    DateTime? _selectedDate;
    Category _selectedCategory = Category.leisure;

    void _presentDatePicker() async {
      final now = DateTime.now();
      final firstDate = DateTime(now.year - 1 , now.month, now.day);
      final pickedDate = await showDatePicker(context: context, firstDate: firstDate, lastDate: now);

      setState(() {
        _selectedDate = pickedDate;
      });
    }



    void _submitExpenseData()  {
      final enteredAmount = double.tryParse(_amountController.text); //tryParse('Hello') => Null and tryParse('1.12') => 1.12
      final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

      if(_titleController.text.trim().isEmpty || amountIsInvalid || _selectedDate == null) {
        showDialog(context: context, builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text('Please make sure that vald title, amount, category and date was entered'),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(ctx);
            }, child: const Text('Okay'))
          ],
        ));
        return;
      }

      // final url = Uri.https('expense-tracker-49f75-default-rtdb.firebaseio.com', 'expense-list.json');
      //
      // final response = await http.post(
      //     url,
      //     headers: { 'Content-Type' : 'application/json' },
      //     body: json.encode({
      //       'title': _titleController.text,
      //       'amount': enteredAmount,
      //       'date': _selectedDate.toString(),
      //       'category': _selectedCategory.name
      //     })
      // );
      //
      // print(response.body);
      // print(response.statusCode);

      widget.onAddExpense(Expense(title: _titleController.text, amount: enteredAmount, date: _selectedDate!, category: _selectedCategory));
      Navigator.pop(context);
    }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20,50,20,20),
    child: Column(
      children: [
        TextField(
          controller: _titleController,
          maxLength: 50,
          decoration: const InputDecoration(
            label: Text('Title')
          )
        ),
         Row(
           children: [
             Expanded(
               child: TextField(
               controller: _amountController,
               keyboardType: TextInputType.number,
               decoration: const InputDecoration(
                   prefix: Text('\$'),
                   label: Text('Amount')
               ),
             ),),
             const SizedBox(width: 16,),
             Expanded(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.end,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                    Text(_selectedDate == null ? 'Date not Selected' : formatter.format(_selectedDate!)),
                   IconButton(onPressed: () { _presentDatePicker(); }, icon: const Icon(Icons.calendar_month_outlined))
                 ],
               ),
             )
           ],
         ),
        const SizedBox(height: 15,),
        Row(
          children: [
            DropdownButton(value: _selectedCategory,
            items: Category.values.map((category) =>
                DropdownMenuItem(value: category,child: Text(category.name.toUpperCase(),),),).toList(),
              onChanged: (value) {
              if(value == null) {
                return;
              }
              setState(() {
                _selectedCategory = value;
              });
              },
            ),
            const Spacer(),
            ElevatedButton(onPressed: () { _submitExpenseData(); }, child: const Text('Add Expense')),
            const SizedBox(width: 8,),
            TextButton(onPressed: () { Navigator.pop(context); }, child: const Text('Cancel'))
          ],
        )
      ],
    ),);
  }
}