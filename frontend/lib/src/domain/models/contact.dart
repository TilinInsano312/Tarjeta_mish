import 'package:frontend/src/domain/models/bank.dart';
import 'package:frontend/src/domain/models/type_account.dart';

class Contact {
  final int? id;
  final String name;
  final int accountNumber;
  final String email;
  final String alias;
<<<<<<< Updated upstream
  final String typeAccount;
  final String bank;
  final String idUser;
=======
  final TypeAccount typeAccount;
  final Bank bank;
  final int idUser;
>>>>>>> Stashed changes
  

  const Contact({
    this.id,
    required this.name,
    required this.accountNumber,
    required this.email,
    required this.alias,
    required this.typeAccount,
    required this.bank,
    required this.idUser
  });

  String get displayName => alias;
  String get displayFullName => name;

 factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] != null ? (json['id'] as num).toInt() : null, // Handle Long from backend
      name: json['name'] as String,
<<<<<<< Updated upstream
      fullName: json['full_name'] as String,
      accountNumber: json['account_number'] as String,
      email: json['email'] as String,
      alias: json['alias'] as String,
      typeAccount: json['type_account'] as String,
      bank: json['bank'] as String,
      idUser: json['id_user'] as String,
=======
      accountNumber: (json['accountNumber'] as num).toInt(),
      email: json['email'] as String,
      alias: json['alias'] as String,
      typeAccount: TypeAccount.fromString(json['typeAccount'] as String),
      bank: Bank.fromString(json['bank'] as String),
      idUser: (json['idUser'] as num).toInt(), // Handle Long from backend
>>>>>>> Stashed changes
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
<<<<<<< Updated upstream
      'full_name': fullName,
      'account_number': accountNumber,
      'email': email,
      'alias': alias,
      'type_account': typeAccount,
      'bank': bank,
      'id_user': idUser,
    };
  }

  String get displayName => alias.isNotEmpty ? alias : name;
  String get displayFullName => fullName.isNotEmpty ? fullName : name;


=======
      'accountNumber': accountNumber,
      'email': email,
      'alias': alias,
      'typeAccount': typeAccount.name,
      'bank': bank.name,
      'idUser': idUser,
    };
  }
>>>>>>> Stashed changes
}