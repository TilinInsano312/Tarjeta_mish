package org.tarjetamish.account.model.enums;

public enum TypeAccount {
    CUENTA_CORRIENTE,
    CUENTA_VISTA,
    CUENTA_DE_AHORRO,
    CUENTA_RUT;
    public int getIndex() {
        return ordinal() + 1;
    }


}
