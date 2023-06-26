import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartPage extends StatelessWidget {
  const ChartPage({super.key});

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
                      "Chart 1",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  SizedBox(
                    height: 200,
                    child: BarChart(
                      BarChartData(maxY: 80, barGroups: [
                        BarChartGroupData(x: 0, barRods: [
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 50),
                        ]),
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 50),
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 50),
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 50),
                        ]),
                        BarChartGroupData(x: 4, barRods: [
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 50),
                        ]),
                        BarChartGroupData(x: 5, barRods: [
                          BarChartRodData(toY: 30),
                          BarChartRodData(toY: 50),
                        ]),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
