class Account{
    final int balance;
    final String acountNumber;
   
    Account({
        required this.balance,
        required this.acountNumber,
    });

    factory Account.fromJson(Map<String, dynamic> json) {
        return Account(
            balance: json['balance'] as int,
            acountNumber: json['account_number'] as String,
        );
    }

}

