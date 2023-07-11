import 'package:expense_tracker/providers/transactions_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

  List getExpensesChartData(BuildContext context) {
    return Provider.of<TransactionsProvider>(context)
        .expensesDataChart()
        .map((item) {
      return BarChartGroupData(x: item['weekYear'], barRods: [
        BarChartRodData(toY: item['deposit'], color: Colors.green),
        BarChartRodData(toY: item['spent'], color: Colors.red),
      ]);
    }).toList();
  }

  List<PieChartSectionData> getExpensesPerCategoryChartData(
      BuildContext context) {
    return [
      PieChartSectionData(value: 200, showTitle: false, color: Colors.green),
      PieChartSectionData(value: 50, showTitle: false, color: Colors.red),
    ];
  }

  @override
  Widget build(BuildContext context) {
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
                    child: Text(
                      "Weekly Expenses",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(
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
