import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({super.key});

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  bool _expanded = false;

  final int itemCount = 3;
  final DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
              child: Text(DateFormat('y').format(date)),
            ),
            title: Text("${DateFormat('MMMd').format(date)} - ${DateFormat('MMMd').format(date.add(const Duration(days: 7)))}"),
            subtitle: Text("Week: ${Jiffy.parseFromDateTime(date).weekOfYear}"),
            trailing: const Icon(Icons.keyboard_arrow_down),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
          constraints: BoxConstraints(
            minHeight: _expanded ? 80 : 0,
            maxHeight: _expanded ? (74.0 * itemCount) : 0
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) => const ListTile(
              leading: SizedBox(
                height: double.infinity,
                child: Icon(Icons.arrow_upward)
              ),
              title: Text("\$500.00"),
              subtitle: Text("60/60/6060"),
            ),
          ),
        )
      ],
    );
  }
}