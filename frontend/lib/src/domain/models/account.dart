class Account{

    final int id;
    final int balance;
    final String accountNumber;
   
    Account({
        required this.id,
        required this.balance,
        required this.accountNumber,
    });

    factory Account.fromJson(Map<String, dynamic> json) {
        return Account(
            id: json['id'] as int,
            balance: json['balance'] as int,
            accountNumber: json['accountNumber'].toString(), 
        );
    }

    int get getId => id;
    int get getBalance => balance;
    String get getAccountNumber => accountNumber;

}

