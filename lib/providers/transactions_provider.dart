import 'package:expense_tracker/helpers/db_helper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionsProvider with ChangeNotifier {
  List<Transaction> _transactions = [];

  List<Transaction> get transactions {
    return [..._transactions];
  }

  Future<void> addTransaction(Transaction transaction) async {
    transaction.id = await DBHelper.insert('transactions', {
      "type": transaction.type.index,
      "amount": transaction.amount,
      "date": transaction.date.toIso8601String(),
      "description": transaction.description
    });
    _transactions.add(transaction);
    notifyListeners();
  }

  Future<void> fetchTransactions() async {
    final dataList = await DBHelper.getData('transactions');
    _transactions = dataList.map((item) => Transaction(
      id: item['id'],
      type: item['type'], 
      amount: item['amount'], 
      date: item['date'], 
      description: item['description'])
    ).toList();
    notifyListeners();
  }
}