import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:flutter/material.dart';


class TransactionsPage extends StatelessWidget {
  final DateTime date = DateTime.now();
  
  TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) => const Card(
        child: TransactionItem(),
      )
    );
  }
}