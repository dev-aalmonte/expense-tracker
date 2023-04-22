import 'package:expense_tracker/providers/transactions_provider.dart';
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
          Text("My Expenses",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          _expensesCard(context),
          const SizedBox(height: 4,),
          Text("Recent Transactions",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4,),
          Expanded(
            child: Consumer<TransactionsProvider>(
              builder: (context, provider, child) => ListView.builder(
                itemCount: provider.transactions.length > 4 ? 4 : provider.transactions.length,
                itemBuilder: (context, index) => _recentTransactions(),
              ),
              child: const Center(
                child: Text("We have no transaction to show")
              ),
            ),
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _expenseLabel(context, label: "Available", value: 1000, color: Colors.green),
                  Expanded(
                    child: SizedBox(
                      height: 200,
                      width: 150,
                      child: Stack(
                        children: [
                          _expenseChartLabel(context),
                          _expenseChart()
                        ] 
                      ),
                    ),
                  ),
                  _expenseLabel(context, label: "Spent", value: 500, color: Colors.red),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Positioned _expenseChartLabel(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total",
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                fontWeight: FontWeight.bold
              )
            ),
            Text(toCurrencyString("1500.00", leadingSymbol: CurrencySymbols.DOLLAR_SIGN)),
          ],
        )
      )
    );
  }

  Widget _expenseLabel(BuildContext context, {
    required String label,
    required double value,
    required Color color
  }) {
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
              const SizedBox(width: 4,),
              Text(label,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          const SizedBox(height: 4,),
          Text(toCurrencyString(value.toStringAsFixed(2), leadingSymbol: CurrencySymbols.DOLLAR_SIGN))
        ],
      ),
    );
  }

  PieChart _expenseChart() {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            value: 1000,
            showTitle: false,
            color: Colors.green
          ),
          PieChartSectionData(
            value: 500,
            showTitle: false,
            color: Colors.red
          )
        ]
      )
    );
  }

  Card _recentTransactions() {
    return Card(
      child: ListTile(
        leading: const  SizedBox(
          height: double.infinity,  
          child: Icon(Icons.arrow_upward)
        ),
        title: Text(toCurrencyString("500.00", leadingSymbol: CurrencySymbols.DOLLAR_SIGN)),
        subtitle: const Text("60/60/6060"),
      ),
    );
  }
}