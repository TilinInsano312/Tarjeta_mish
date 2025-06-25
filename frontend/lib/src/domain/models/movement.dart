class Movement {
  final int? id;
  final int amount;
  final String? name;
  final DateTime? date;
  final String description;
  final String? rutDestination;
  final String? accountDestination;
  final String? rutOrigin;
  final String? accountOrigin;
  final String? typeTransaction;
  final String? bank;
  final int? idAccount;

  Movement({
    this.id,
    required this.amount,
    this.name,
    this.date,
    required this.description,
    this.rutDestination,
    this.accountDestination,
    this.rutOrigin,
    this.accountOrigin,
    this.typeTransaction,
    this.bank,
    this.idAccount,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['id'] as int?,
      amount: json['amount'] as int,
      name: json['name'] as String?,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      description: json['description'] as String? ?? '',
      rutDestination: json['rutDestination'] as String?,
      accountDestination: json['accountDestination'] as String?,
      rutOrigin: json['rutOrigin'] as String?,
      accountOrigin: json['accountOrigin'] as String?,
      typeTransaction: json['typeTransaction'] as String?,
      bank: json['bank'] as String?,
      idAccount: json['idAccount'] as int?,
    );
  }
}