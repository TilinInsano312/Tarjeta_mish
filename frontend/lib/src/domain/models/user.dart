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
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      rut: json['rut'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      pin: json['pin'] ?? '',
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

  @override
  String toString() {
    return 'User(id: $id, rut: $rut, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.rut == rut &&
        other.name == name &&
        other.email == email &&
        other.pin == pin;
  }

  @override
  int get hashCode {
    return Object.hash(id, rut, name, email, pin);
  }
}
