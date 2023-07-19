import 'dart:math';

import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/providers/transactions_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatefulWidget {
  const ChartPage({super.key});

  @override
  State<ChartPage> createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  double _maxBarChartValue = 0;

  List getExpensesChartData(BuildContext context) {
    return Provider.of<TransactionsProvider>(context)
        .expensesDataChart()
        .map((item) {
      _maxBarChartValue =
          max(max(item['deposit'], item['spent']), _maxBarChartValue);
      return BarChartGroupData(x: item['weekYear'], barRods: [
        BarChartRodData(toY: item['deposit'], color: Colors.green),
        BarChartRodData(toY: item['spent'], color: Colors.red),
      ]);
    }).toList();
  }

  List<PieChartSectionData> getExpensesPerCategoryChartData(
      BuildContext context) {
    Map<Categories, double>? expensesCategoryData =
        Provider.of<TransactionsProvider>(context).expensesCategoryDataChart();

    List<PieChartSectionData> chartData = [];

    if (expensesCategoryData != null) {
      expensesCategoryData.forEach((key, value) {
        chartData.add(PieChartSectionData(
          value: value,
          color: Categories.categoryColors(key),
          showTitle: false,
        ));
      });
    }

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> categoryChartData =
        getExpensesPerCategoryChartData(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 24, top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weekly Expenses",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
                          maxY: _maxBarChartValue + 50,
                          barGroups: getExpensesChartData(context)
                              as List<BarChartGroupData>),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16, bottom: 24, top: 12),
                    child: Text(
                      "Expenses Glosary",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (categoryChartData.isEmpty)
                    SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            size: 42,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            "No data available",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          )
                        ],
                      ),
                    )
                  else
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: getExpensesPerCategoryChartData(context),
                        ),
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
