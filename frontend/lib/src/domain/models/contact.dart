class Contact {
  final int id;
  final String name;
  final String fullName;
  final String accountNumber;
  final String email;
  final String alias;
  final String typeAccount;
  final String bank;
  final String idUser;
  

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
      fullName: json['full_name'] as String,
      accountNumber: json['account_number'] as String,
      email: json['email'] as String,
      alias: json['alias'] as String,
      typeAccount: json['type_account'] as String,
      bank: json['bank'] as String,
      idUser: json['id_user'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
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


}