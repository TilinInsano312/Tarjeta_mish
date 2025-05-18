class Card{
  final String cardNumber;
  final String cardCVV;
  final String expirationDate;

  const Card({
    required this.cardNumber,
    required this.cardCVV,
    required this.expirationDate,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      cardNumber: json['card_number'] as String,
      cardCVV: json['card_cvv'] as String,
      expirationDate: json['expirationDate'] as String,
    );
  }
}