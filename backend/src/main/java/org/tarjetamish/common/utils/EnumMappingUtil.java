package org.tarjetamish.common.utils;

import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.account.model.enums.TypeAccount;

import java.util.HashMap;
import java.util.Map;

public class EnumMappingUtil {

    private static final Map<Integer, TypeAccount> TYPE_ACCOUNT_MAP = new HashMap<>();
    private static final Map<TypeAccount, Integer> TYPE_ACCOUNT_REVERSE_MAP = new HashMap<>();

    private static final Map<Integer, Bank> BANK_MAP = new HashMap<>();
    private static final Map<Bank, Integer> BANK_REVERSE_MAP = new HashMap<>();

    static {
        // Inicializar mapeo de tipos de cuenta (basado en los IDs reales en data.sql)
        TYPE_ACCOUNT_MAP.put(1, TypeAccount.CUENTA_CORRIENTE);
        TYPE_ACCOUNT_MAP.put(2, TypeAccount.CUENTA_VISTA);
        TYPE_ACCOUNT_MAP.put(3, TypeAccount.CUENTA_DE_AHORRO);
        TYPE_ACCOUNT_MAP.put(4, TypeAccount.CUENTA_RUT);
        // Nota: TARJETA_DE_CREDITO (ID 5) no está en el enum, se omite por ahora

        // Inicializar mapeo reverso
        for (Map.Entry<Integer, TypeAccount> entry : TYPE_ACCOUNT_MAP.entrySet()) {
            TYPE_ACCOUNT_REVERSE_MAP.put(entry.getValue(), entry.getKey());
        }

        // Inicializar mapeo de bancos (basado en data.sql - IDs 1-10)
        BANK_MAP.put(1, Bank.BANCO_DE_CHILE);
        BANK_MAP.put(2, Bank.BANCO_SANTANDER);
        BANK_MAP.put(3, Bank.BANCO_ESTADO);
        BANK_MAP.put(4, Bank.BANCO_ITAU);
        BANK_MAP.put(5, Bank.SCOTIABANCO);
        BANK_MAP.put(6, Bank.BANCO_BICE);
        BANK_MAP.put(7, Bank.BANCO_CONSORCIO);
        BANK_MAP.put(8, Bank.BANCO_INTERNACIONAL);
        BANK_MAP.put(9, Bank.BANCO_SECURITY);
        BANK_MAP.put(10, Bank.BANCO_FALABELLA);

        // Inicializar mapeo reverso
        for (Map.Entry<Integer, Bank> entry : BANK_MAP.entrySet()) {
            BANK_REVERSE_MAP.put(entry.getValue(), entry.getKey());
        }
    }

    public static TypeAccount getTypeAccountById(int id) {
        TypeAccount typeAccount = TYPE_ACCOUNT_MAP.get(id);
        if (typeAccount == null) {
            throw new IllegalArgumentException("Invalid TypeAccount ID: " + id);
        }
        return typeAccount;
    }

    public static Integer getTypeAccountId(TypeAccount typeAccount) {
        Integer id = TYPE_ACCOUNT_REVERSE_MAP.get(typeAccount);
        if (id == null) {
            throw new IllegalArgumentException("Invalid TypeAccount: " + typeAccount);
        }
        return id;
    }

    public static Bank getBankById(int id) {
        Bank bank = BANK_MAP.get(id);
        if (bank == null) {
            throw new IllegalArgumentException("Invalid Bank ID: " + id);
        }
        return bank;
    }

    public static Integer getBankId(Bank bank) {
        Integer id = BANK_REVERSE_MAP.get(bank);
        if (id == null) {
            throw new IllegalArgumentException("Invalid Bank: " + bank);
        }
        return id;
    }
}
