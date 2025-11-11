import 'package:frontend/src/domain/models/bank.dart';
import 'package:frontend/src/domain/models/type_account.dart';

class Contact {
  final int? id;
  final String name;
  final int accountNumber;
  final String email;
  final String alias;
  final String rut; // Necesario para transferencias
  final TypeAccount typeAccount;
  final Bank bank;
  final int idUser;
  

  const Contact({
    this.id,
    required this.name,
    required this.accountNumber,
    required this.email,
    required this.alias,
    required this.rut,
    required this.typeAccount,
    required this.bank,
    required this.idUser
  });

  String get displayName => alias;
  String get displayFullName => name;

 factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      name: json['name'] as String,
      accountNumber: (json['accountNumber'] as num).toInt(),
      email: json['email'] as String,
      alias: json['alias'] as String,
      rut: json['rut'] as String? ?? '', // Vacío si no viene del backend
      typeAccount: TypeAccount.fromString(json['typeAccount'] as String),
      bank: Bank.fromString(json['bank'] as String),
      idUser: (json['idUser'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'accountNumber': accountNumber,
      'email': email,
      'alias': alias,
      'typeAccount': typeAccount.name,
      'bank': bank.name,
      'idUser': idUser,
    };
  }

  String get displayName => alias.isNotEmpty ? alias : name;
  String get displayFullName => name; // Solo usar name ya que fullName no existe en backend

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Contact &&
        other.id == id &&
        other.name == name &&
        other.accountNumber == accountNumber &&
        other.email == email &&
        other.alias == alias &&
        other.rut == rut &&
        other.typeAccount == typeAccount &&
        other.bank == bank &&
        other.idUser == idUser;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      accountNumber,
      email,
      alias,
      rut,
      typeAccount,
      bank,
      idUser,
    );
  }

  @override
  String toString() {
    return 'Contact(id: $id, name: $name, alias: $alias, rut: $rut, accountNumber: $accountNumber)';
  }
}