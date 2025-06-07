class Card{
  final String cardNumber;
  final String cardCVV;
  final String expirationDate;
  final String cardHolderName;

  const Card({
    required this.cardNumber,
    required this.cardCVV,
    required this.expirationDate,
    required this.cardHolderName,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      cardNumber: json['number'] as String,
      cardCVV: json['cvv'] as String,
      expirationDate: json['expirationDate'] as String,
      cardHolderName: json['cardHolderName'] as String,
    );
  }
}