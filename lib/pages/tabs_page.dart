import 'package:expense_tracker/pages/add_transaction_page.dart';
import 'package:expense_tracker/pages/chart_page.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:expense_tracker/pages/transactions_page.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  static const String route = '/tabs';

  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _selectedIndex = 1;
  String _swipeDirection = "";
  final List<String> _pagesTitle = [
    "Transactions",
    "Dashboard",
    "Add Transaction"
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pagesTitle[_selectedIndex]),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AddTransactionPage.route);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          const int sensitivity = 4;
          if (details.delta.dx > sensitivity && _selectedIndex > 0) {
            _swipeDirection = "left";
          }
          if (details.delta.dx < -sensitivity &&
              _selectedIndex < _pagesTitle.length - 1) {
            _swipeDirection = "right";
          }
        },
        onHorizontalDragEnd: (details) {
          switch (_swipeDirection) {
            case "left":
              _selectPage(_selectedIndex - 1);
              break;
            case "right":
              _selectPage(_selectedIndex + 1);
              break;
          }
          _swipeDirection = "";
        },
        child: [
          TransactionsPage(),
          const HomePage(),
          const ChartPage()
          // AddTransactionPage(changePage: () => _selectPage(1),)
        ][_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: "Transactions",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Charts",
          ),
        ],
      ),
    );
  }
}
