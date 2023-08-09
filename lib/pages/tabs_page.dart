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
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final List<String> _pagesTitle = [
    "Transactions",
    "Dashboard",
    "User Statistics"
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
        child: PageView(
          controller: _pageController,
          onPageChanged: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          // onHorizontalDragUpdate: (details) {
          //   const int sensitivity = 4;
          //   if (details.delta.dx > sensitivity && _selectedIndex > 0) {
          //     _swipeDirection = "left";
          //   }
          //   if (details.delta.dx < -sensitivity &&
          //       _selectedIndex < _pagesTitle.length - 1) {
          //     _swipeDirection = "right";
          //   }
          // },
          // onHorizontalDragEnd: (details) {
          //   switch (_swipeDirection) {
          //     case "left":
          //       _selectPage(_selectedIndex - 1);
          //       break;
          //     case "right":
          //       _selectPage(_selectedIndex + 1);
          //       break;
          //   }
          //   _swipeDirection = "";
          // },
          children: [
            TransactionsPage(),
            const HomePage(),
            const ChartPage()
            // AddTransactionPage(changePage: () => _selectPage(1),)
          ],
          // child: Padding(
          //   padding: const EdgeInsets.only(top: 28, left: 16, right: 16),
          //   child: [
          //     TransactionsPage(),
          //     const HomePage(),
          //     const ChartPage()
          //     // AddTransactionPage(changePage: () => _selectPage(1),)
          //   ][_selectedIndex],
          // ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddTransactionPage.route);
        },
        child: const Icon(Icons.add),
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
