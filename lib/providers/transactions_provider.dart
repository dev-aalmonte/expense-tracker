import 'dart:async';

import 'package:expense_tracker/helpers/db_helper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsProvider with ChangeNotifier {
  double deposit = 0.00;
  double spent = 0.00;

  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  Future<void> fetchUserDeposit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    deposit = prefs.getDouble('deposit') ?? 0.00;
    spent = prefs.getDouble('spent') ?? 0.00;
  }

  Future<void> addTransaction(Transaction transaction) async {
    var transactionObject = {
      "type": transaction.type.index,
      "amount": transaction.amount,
      "date": transaction.date.toIso8601String(),
      "description": transaction.description
    };

    if (transaction.type == TransactionType.spent) {
      transactionObject['category'] = transaction.category!.index;
    }

    transaction.id = await DBHelper.insert('transactions', transactionObject);
    _transactions.add(transaction);
    _setDepositPreference(transaction);

    notifyListeners();
  }

  void _setDepositPreference(Transaction transaction) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    fetchUserDeposit();

    if (transaction.type == TransactionType.deposit) {
      await prefs.setDouble('deposit', deposit + transaction.amount);
    } else {
      await prefs.setDouble('spent', spent + transaction.amount);
    }
  }

  Future<void> fetchTransactions() async {
    final dataList = await DBHelper.getData('transactions');
    _transactions = dataList
        .map((item) => Transaction(
            id: item['id'],
            type: TransactionType.values[item['type']],
            category: item['category'] != null
                ? Categories.values[item['category']]
                : null,
            amount: item['amount'],
            date: DateTime.parse(item['date']),
            description: item['description']))
        .toList();
    notifyListeners();
  }

  Map<String, dynamic> groupByWeekYear() {
    fetchTransactions();
    var groupedTransaction = <String, dynamic>{};
    for (var transaction in _transactions) {
      int weekYear = Jiffy.parseFromDateTime(transaction.date).weekOfYear;
      int year = Jiffy.parseFromDateTime(transaction.date).year;
      double sum = 0;
      String key = "$year-$weekYear";
      int positiveNegative =
          transaction.type == TransactionType.deposit ? 1 : -1;

      if (groupedTransaction.containsKey(key)) {
        groupedTransaction[key]['sumAmount'] +=
            transaction.amount * positiveNegative;
        groupedTransaction[key]['transactions'].add(transaction);
      } else {
        groupedTransaction[key] = {};

        sum = transaction.amount * positiveNegative;
        groupedTransaction[key]['sumAmount'] = sum;
        groupedTransaction[key]['transactions'] = [transaction];
      }
    }

    return groupedTransaction;
  }
}
