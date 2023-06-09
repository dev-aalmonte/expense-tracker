import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/providers/transactions_provider.dart';
import 'package:expense_tracker/widgets/transaction_tile.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Expenses",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          FutureBuilder(
              future:
                  Provider.of<TransactionsProvider>(context).fetchUserDeposit(),
              builder: (context, snapshot) => _expensesCard(context)),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Recent Transactions",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(
            height: 4,
          ),
          Expanded(
            child: FutureBuilder(
              future: Provider.of<TransactionsProvider>(context)
                  .fetchTransactions(),
              builder: (context, snapshot) => Consumer<TransactionsProvider>(
                builder: (context, provider, child) => provider
                        .transactions.isNotEmpty
                    ? ListView.builder(
                        itemCount: provider.transactions.length > 4
                            ? 4
                            : provider.transactions.length,
                        itemBuilder: (context, index) => _recentTransactions(
                            transactionType: provider.transactions[index].type,
                            category: provider.transactions[index].category,
                            amount: provider.transactions[index].amount,
                            date: provider.transactions[index].date))
                    : child!,
                child: _noDataWidget(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  Center _noDataWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 52,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Sorry, no data to be shown!",
            style: Theme.of(context).textTheme.titleMedium,
          )
        ],
      ),
    );
  }

  Padding _expensesCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<TransactionsProvider>(
            builder: (context, provider, child) => provider.deposit > 0.00 ||
                    provider.spent > 0.00
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _expenseLabel(context,
                              label: "Available",
                              value: (provider.deposit - provider.spent),
                              color: Colors.green),
                          Expanded(
                            child: SizedBox(
                              height: 200,
                              width: 150,
                              child: Stack(children: [
                                _expenseChartLabel(context, provider.deposit),
                                _expenseChart(
                                    (provider.deposit - provider.spent),
                                    provider.spent)
                              ]),
                            ),
                          ),
                          _expenseLabel(context,
                              label: "Spent",
                              value: provider.spent,
                              color: Colors.red),
                        ],
                      )
                    ],
                  )
                : child!,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: _noDataWidget(context),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _expenseChartLabel(BuildContext context, double deposit) {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Total",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(toCurrencyString(deposit.toString(),
                    leadingSymbol: CurrencySymbols.DOLLAR_SIGN)),
              ],
            )));
  }

  Widget _expenseLabel(BuildContext context,
      {required String label, required double value, required Color color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                maxRadius: 5,
                backgroundColor: color,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Text(toCurrencyString(value.toStringAsFixed(2),
              leadingSymbol: CurrencySymbols.DOLLAR_SIGN))
        ],
      ),
    );
  }

  PieChart _expenseChart(double available, double spent) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
              value: available, showTitle: false, color: Colors.green),
          PieChartSectionData(
              value: spent, showTitle: false, color: Colors.red),
        ],
      ),
    );
  }

  Card _recentTransactions(
      {required TransactionType transactionType,
      required double amount,
      required DateTime date,
      Categories? category}) {
    return Card(
      child: TransactionTile(
          transactionType: transactionType,
          category: category,
          amount: amount,
          date: date),
    );
  }
}
