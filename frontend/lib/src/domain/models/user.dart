class User {
  final int id;
  final String rut;
  final String name;
  final String email;
  final String pin;

  const User({
    required this.id,
    required this.rut,
    required this.name,
    required this.email,
    required this.pin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num).toInt(), // Handle Long from backend
      rut: json['rut'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      pin: json['pin'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rut': rut,
      'name': name,
      'email': email,
      'pin': pin,
    };
  }
}
