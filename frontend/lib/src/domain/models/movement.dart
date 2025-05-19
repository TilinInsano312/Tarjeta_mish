class Movement {
  final String description; //Rename variable for better understandin (Donde va o de donde viene la tranasferencia)
  final int amount;

  Movement({
    required this.description,
    required this.amount
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      description: json['description'] as String,
      amount: json['amount'] as int
    );
  }

}