import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/providers/transactions_provider.dart';
import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatelessWidget {
  final DateTime date = DateTime.now();
  
  TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionsProvider>(
      builder: (context, provider, child) {
        final Map<String, List<Transaction>> groupedTransactions = provider.groupByWeekYear();
        final dataLength = provider.transactions.length;
        return dataLength > 0 
        ? ListView.builder(
          itemCount: groupedTransactions.length,
          itemBuilder: (context, index) {
            String key = groupedTransactions.keys.elementAt(index);
            return Card(
              child: TransactionItem(
                groupTransaction: groupedTransactions[key]!,
              ),
            );
          } 
        ) 
        : child!;
      } ,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64,),
            const SizedBox(height: 10,),
            Text("Sorry, no data to be shown!", style: Theme.of(context).textTheme.titleLarge,)
          ],
        ),
      ),
    );
  }
}