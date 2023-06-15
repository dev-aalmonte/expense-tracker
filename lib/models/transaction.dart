enum TransactionType { deposit, spent }

enum Categories {
  bill,
  gaming,
  food,
  insurance,
  investment,
  maintenance;

  static Categories? fromName(String name) {
    for (Categories category in Categories.values) {
      if (category.name == name) return category;
    }
    return null;
  }
}

extension ParseToString on Categories {
  String toShortString() {
    String categoryString = toString().split('.').last;
    String firstLetterUpper = categoryString[0].toUpperCase();
    categoryString = categoryString.replaceRange(0, 1, firstLetterUpper);
    return categoryString;
  }
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
