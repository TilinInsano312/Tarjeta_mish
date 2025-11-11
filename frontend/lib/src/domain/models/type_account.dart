enum TypeAccount {
  CORRIENTE,
  AHORRO;

  String get displayName {
    switch (this) {
      case TypeAccount.CORRIENTE:
        return 'Cuenta Corriente';
      case TypeAccount.AHORRO:
        return 'Cuenta de Ahorro';
    }
  }

  static TypeAccount fromString(String typeName) {
    return TypeAccount.values.firstWhere(
      (type) => type.name == typeName,
      orElse: () => TypeAccount.CORRIENTE,
    );
  }
}
