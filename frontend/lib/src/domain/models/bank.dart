enum Bank {
  BANCO_CHILE,
  BANCO_ESTADO;

  String get displayName {
    switch (this) {
      case Bank.BANCO_CHILE:
        return 'Banco de Chile';
      case Bank.BANCO_ESTADO:
        return 'Banco Estado';
    }
  }

  static Bank fromString(String bankName) {
    return Bank.values.firstWhere(
      (bank) => bank.name == bankName,
      orElse: () => Bank.BANCO_CHILE,
    );
  }
}
