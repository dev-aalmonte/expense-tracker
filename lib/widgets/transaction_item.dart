import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class TransactionItem extends StatefulWidget {
  final List<Transaction> groupTransaction;
  const TransactionItem({
    super.key,
    required this.groupTransaction
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {

    final List<Transaction> transactions = widget.groupTransaction;
    final firstDayOfWeek = DateFormat('MMMd')
      .format(transactions[0].date.subtract(
        Duration(days: 7 - (8 - Jiffy.parseFromDateTime(transactions[0].date).dayOfWeek) )
      ) 
    );
    final lastDayOfWeek = DateFormat('MMMd')
      .format(transactions[0].date.add(
        Duration(days: 7 - Jiffy.parseFromDateTime(transactions[0].date).dayOfWeek)
      ) 
    );

    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
            });
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              child: Text(DateFormat('y').format(transactions[0].date)),
            ),
            title: Text("$firstDayOfWeek - $lastDayOfWeek"),
            subtitle: Text("Week: ${Jiffy.parseFromDateTime(transactions[0].date).weekOfYear}"),
            trailing: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          constraints: BoxConstraints(
            minHeight: _expanded ? 80 : 0,
            maxHeight: _expanded ? (74.0 * transactions.length) : 0
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) => ListTile(
              leading: SizedBox(
                height: double.infinity,
                child: Icon(transactions[index].type.index == 0 
                  ? Icons.arrow_upward 
                  : Icons.arrow_downward
                )
              ),
              title: Text(toCurrencyString(
                transactions[index].amount.toStringAsFixed(2), 
                leadingSymbol: CurrencySymbols.DOLLAR_SIGN)
              ),
              subtitle: Text(DateFormat("M/d/y").format(transactions[index].date)),
            ),
          ),
        )
      ],
    );
  }
}