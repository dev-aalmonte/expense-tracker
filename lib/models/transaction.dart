enum TransactionType { deposit, spent }

enum Categories {
  bill,
  gaming,
  food,
  insurance,
  investment,
  maintenance,
}

class Transaction {
  late int? id;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final Categories? category;
  final String? description;

  Transaction({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    this.category,
    this.description,
  });
}
