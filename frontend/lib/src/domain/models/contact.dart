class Contact {
  final int id;
  final String name;
  final String fullName;
  final String accountNumber;
  final String email;
  final String alias;
  final String typeAccount;
  final String bank;
  final int idUser;
  

  const Contact({
    required this.id,
    required this.name,
    required this.fullName,
    required this.accountNumber,
    required this.email,
    required this.alias,
    required this.typeAccount,
    required this.bank,
    required this.idUser
  });

 factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String? ?? '',
      accountNumber: json['accountNumber']?.toString() ?? '',
      email: json['email'] as String,
      alias: json['alias'] as String,
      typeAccount: json['typeAccount']?.toString() ?? '',
      bank: json['bank']?.toString() ?? '',
      idUser: json['idUser'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'accountNumber': int.tryParse(accountNumber) ?? 0,
      'email': email,
      'alias': alias,
      'typeAccount': typeAccount,
      'bank': bank,
      'idUser': idUser,
    };
  }

  String get displayName => alias.isNotEmpty ? alias : name;
  String get displayFullName => name;


}