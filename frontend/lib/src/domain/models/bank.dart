enum Bank {
  BANCO_CHILE,
  BANCO_ESTADO,
  BANCO_SANTANDER;

  String get displayName {
    switch (this) {
      case Bank.BANCO_CHILE:
        return 'Banco de Chile';
      case Bank.BANCO_ESTADO:
        return 'Banco Estado';
      case Bank.BANCO_SANTANDER:
        return 'Banco Santander';
    }
  }

  // Nuevo getter para obtener el ID del banco según la base de datos
  int get id {
    switch (this) {
      case Bank.BANCO_ESTADO:
        return 4;
      case Bank.BANCO_CHILE:
        return 5;
      case Bank.BANCO_SANTANDER:
        return 6;
    }
  }

  static Bank fromString(String bankName) {
    return Bank.values.firstWhere(
      (bank) => bank.name == bankName,
      orElse: () => Bank.BANCO_CHILE,
    );
  }

  // Método para obtener Bank por ID
  static Bank fromId(int id) {
    switch (id) {
      case 4:
        return Bank.BANCO_ESTADO;
      case 5:
        return Bank.BANCO_CHILE;
      case 6:
        return Bank.BANCO_SANTANDER;
      default:
        return Bank.BANCO_CHILE;
    }
  }
}
