import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';

class TransactionTile extends StatelessWidget {
  final TransactionType transactionType;
  final double amount;
  final DateTime date;
  final Categories? category;

  const TransactionTile({
    super.key,
    required this.transactionType,
    required this.amount,
    required this.date,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    late MaterialColor iconColor;
    late IconData icon;

    switch (transactionType) {
      case TransactionType.deposit:
        icon = Icons.arrow_upward;
        iconColor = Colors.green;
        break;
      case TransactionType.spent:
        icon = Icons.arrow_downward;
        iconColor = Colors.red;
        break;
    }

    return ListTile(
      leading: SizedBox(
        height: double.infinity,
        child: Icon(icon, color: iconColor),
      ),
      title: Text(toCurrencyString(amount.toString(),
          leadingSymbol: CurrencySymbols.DOLLAR_SIGN)),
      subtitle: Text(DateFormat("M/d/y").format(date)),
      trailing: category != null
          ? Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: Categories.categoryColors(category!),
                    radius: 10,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    category!.toShortString(),
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        fontWeight: FontWeight.bold, letterSpacing: .5),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
