import 'package:expense_tracker/helpers/db_helper.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

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
      type: TransactionType.values[item['type']], 
      amount: item['amount'], 
      date: DateTime.parse(item['date']), 
      description: item['description'])
    ).toList();
    notifyListeners();
  }

  Map<String, List<Transaction>> groupByWeekYear() {
    var groupedTransaction = <String, List<Transaction>>{};
    for (var transaction in _transactions) {
      int weekYear = Jiffy.parseFromDateTime(transaction.date).weekOfYear;
      int year = Jiffy.parseFromDateTime(transaction.date).year;
      String key = "$year-$weekYear";
      if(groupedTransaction.containsKey(key)) {
        groupedTransaction[key]!.add(transaction);
      }
      else {
        groupedTransaction[key] = [transaction];
      }
    }
    
    return groupedTransaction;
  }
}