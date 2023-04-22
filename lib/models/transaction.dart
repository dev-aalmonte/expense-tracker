enum TransactionType {
  deposit,
  spent
}

class Transaction {
  late int? id;
  final TransactionType type; 
  final double amount;
  final DateTime date;
  final String description;

  Transaction({
    this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });
}