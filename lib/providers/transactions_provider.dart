import 'dart:async';

import 'package:expense_tracker/helpers/db_helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/db_where.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/providers/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class TransactionsProvider with ChangeNotifier {
  // double deposit = 0.00;
  // double spent = 0.00;
  double max = 0.00;
  bool isDataLoaded = false;
  bool isMonthly = false;

  List<Transaction> transactionsSummary = [];
  Map<String, dynamic> transactionsByWeekYear = {};
  Map<String, double> transactionSummaryChartData = {};

  Future<void> deleteData() async {
    await DBHelper.clearData();
    notifyListeners();
  }

  Future<void> addTransaction(
      Transaction transaction, Account activeAccount) async {
    var transactionObject = {
      "type": transaction.type.index,
      "amount": transaction.amount,
      "account_id": transaction.account.id,
      "date": transaction.date.toIso8601String(),
      "description": transaction.description
    };

    if (transaction.type == TransactionType.spent) {
      transactionObject['category'] = transaction.category!.index;
    }

    transaction.id = await DBHelper.insert('transactions', transactionObject);
    _setDepositPreference(transaction, activeAccount);

    notifyListeners();
  }

  void _setDepositPreference(
      Transaction transaction, Account activeAccount) async {
    late Account updatedAccount;
    if (transaction.type == TransactionType.deposit) {
      updatedAccount = Account(
        id: activeAccount.id,
        name: activeAccount.name,
        accNumber: activeAccount.accNumber,
        available: activeAccount.available + transaction.amount,
        spent: activeAccount.spent,
      );
    } else {
      updatedAccount = Account(
        id: activeAccount.id,
        name: activeAccount.name,
        accNumber: activeAccount.accNumber,
        available: activeAccount.available,
        spent: activeAccount.spent + transaction.amount,
      );
    }

    AccountProvider.updateAccount(updatedAccount);
  }

  Future<void> fetchTransactionSummary(Account activeAccount) async {
    List range = [];
    if (!isMonthly) {
      // Weekly
      int todayWeekday = Jiffy.now().dayOfWeek;
      DateTime weekStart =
          DateTime.now().subtract(Duration(days: (todayWeekday - 1)));
      weekStart = DateTime(weekStart.year, weekStart.month, weekStart.day);

      range = [
        weekStart.toIso8601String(),
        DateTime.now().toIso8601String(),
      ];
    } else {
      // Monthly
      int todayYear = DateTime.now().year;
      int todayMonth = DateTime.now().month;
      range = [
        DateTime(todayYear, todayMonth, 1).toIso8601String(),
        DateTime.now().toIso8601String(),
      ];
    }

    final dataList = await DBHelper.fetchWhereMultiple('transactions', [
      DBWhere(
        column: 'date',
        operation: WhereOperation.between,
        value: range,
        chain: WhereChain.and,
      ),
      DBWhere(
        column: 'account_id',
        operation: WhereOperation.equal,
        value: activeAccount.id,
      ),
    ]);

    List<Transaction> summaryTransactions = [];

    for (var item in dataList) {
      summaryTransactions.add(Transaction(
        id: item['id'],
        account: await AccountProvider.fetchAccountById(item['account_id']),
        type: TransactionType.values[item['type']],
        amount: item['amount'],
        date: DateTime.parse(item['date']),
        description: item['description'],
      ));
    }

    transactionsSummary = summaryTransactions;
    _fetchTransactionSummaryChartData();
    notifyListeners();
  }

  void _fetchTransactionSummaryChartData() {
    transactionSummaryChartData = {"deposit": 0.00, "spent": 0.00};

    for (Transaction transaction in transactionsSummary) {
      if (transaction.type == TransactionType.deposit) {
        transactionSummaryChartData["deposit"] =
            (transactionSummaryChartData["deposit"] ?? 0) + transaction.amount;
      }
      if (transaction.type == TransactionType.spent) {
        transactionSummaryChartData["spent"] =
            (transactionSummaryChartData["spent"] ?? 0) + transaction.amount;
      }
    }
  }

  Future<List<Transaction>> fetchTransactions() async {
    final dataList = await DBHelper.getData('transactions');

    List<Transaction> transactions = [];

    for (var item in dataList) {
      transactions.add(Transaction(
        id: item['id'],
        account: await AccountProvider.fetchAccountById(item['account_id']),
        type: TransactionType.values[item['type']],
        amount: item['amount'],
        date: DateTime.parse(item['date']),
        description: item['description'],
      ));
    }

    return transactions;
  }

  Future<void> groupByWeekYear() async {
    List<Transaction> transactions = await fetchTransactions();
    Map<String, dynamic> groupedTransactions = {};

    for (var transaction in transactions) {
      int weekYear = Jiffy.parseFromDateTime(transaction.date).weekOfYear;
      int year = Jiffy.parseFromDateTime(transaction.date).year;
      String key = "$year-$weekYear";
      int positiveNegative =
          transaction.type == TransactionType.deposit ? 1 : -1;

      if (!groupedTransactions.containsKey(key)) {
        groupedTransactions[key] = {
          'sumAmount': 0,
          'transactions': [],
        };
      }

      groupedTransactions[key]['sumAmount'] +=
          transaction.amount * positiveNegative;
      groupedTransactions[key]['transactions'].add(transaction);
    }

    transactionsByWeekYear = groupedTransactions;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> expensesDataChart() async {
    await groupByWeekYear();
    Map<String, dynamic> groupedTransactions = transactionsByWeekYear;
    List<Map<String, dynamic>> expensesData = [];
    int weekYear = Jiffy.parseFromDateTime(DateTime.now()).weekOfYear;
    int year = Jiffy.parseFromDateTime(DateTime.now()).year;
    int max = 2; // Maximum week Lookout (Relative to the actual week)

    for (int actual = -2; actual <= max; actual++) {
      String key = "$year-${weekYear - actual}";

      List<Transaction> weeklyTransactions = groupedTransactions[key] == null
          ? []
          : [...groupedTransactions[key]['transactions']];

      double deposit = 0;
      double spent = 0;

      for (var transaction in weeklyTransactions) {
        if (transaction.category == null) {
          deposit += transaction.amount;
        } else {
          spent += transaction.amount;
        }
      }

      expensesData.add(
        {'deposit': deposit, 'spent': spent, 'weekYear': weekYear - actual},
      );
    }

    return expensesData;
  }

  Future<Map<Categories, double>?> expensesCategoryDataChart(
      DateTimeRange? dateRange) async {
    await groupByWeekYear();
    Map<String, dynamic> groupedTransactions = transactionsByWeekYear;
    Map<Categories, double> expensesCategoryData = {};
    late int startWeekYear;
    late int endWeekYear;
    late int startYear;
    late int endYear;

    max = 0;

    if (dateRange != null) {
      startWeekYear = Jiffy.parseFromDateTime(dateRange.start).weekOfYear;
      endWeekYear = Jiffy.parseFromDateTime(dateRange.end).weekOfYear;
      startYear = Jiffy.parseFromDateTime(dateRange.start).year;
      endYear = Jiffy.parseFromDateTime(dateRange.end).year;
    } else {
      startWeekYear = Jiffy.parseFromDateTime(DateTime.now()).weekOfYear;
      endWeekYear = startWeekYear;
      startYear = Jiffy.parseFromDateTime(DateTime.now()).year;
      endYear = startYear;
    }

    for (int year = startYear; year <= endYear; year++) {
      for (int weekYear = startWeekYear; weekYear <= endWeekYear; weekYear++) {
        String key = "$year-$weekYear";
        if (!groupedTransactions.containsKey(key)) {
          continue;
        }

        for (Transaction transaction in groupedTransactions[key]
            ['transactions']) {
          if (transaction.category != null) {
            max += transaction.amount;
            expensesCategoryData[transaction.category!] = transaction.amount;
          }
        }
      }
    }

    return expensesCategoryData.isEmpty ? null : expensesCategoryData;
  }
}
