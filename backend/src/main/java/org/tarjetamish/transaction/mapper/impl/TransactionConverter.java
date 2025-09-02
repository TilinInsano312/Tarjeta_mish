package org.tarjetamish.transaction.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.mapper.ITransactionConverter;
import org.tarjetamish.transaction.model.Transaction;
import org.tarjetamish.transaction.model.enums.TypeTransaction;

@Component
public class TransactionConverter implements ITransactionConverter {
    public TransactionDTO toTransactionDTO(Transaction transaction) {
        Integer typeTransactionId = transaction.getTypeTransaction() != null ?
            transaction.getTypeTransaction().ordinal() + 1 : null;
        Integer bankId = transaction.getBank() != null ?
            transaction.getBank().ordinal() + 1 : null;

        return new TransactionDTO(
            transaction.getId(),
            transaction.getAmount(),
            transaction.getName(),
            transaction.getDate(),
            transaction.getDescription(),
            transaction.getRutDestination(),
            transaction.getAccountDestination(),
            transaction.getRutOrigin(),
            transaction.getAccountOrigin(),
            typeTransactionId,
            bankId,
            transaction.getIdAccount());
    }

    public Transaction toTransaction(TransactionDTO transactionDTO) {
        TypeTransaction typeTransaction = null;
        if (transactionDTO.typeTransaction() != null && transactionDTO.typeTransaction() > 0) {
            typeTransaction = TypeTransaction.values()[transactionDTO.typeTransaction() - 1];
        }

        Bank bank = null;
        if (transactionDTO.bank() != null && transactionDTO.bank() > 0) {
            bank = Bank.values()[transactionDTO.bank() - 1];
        }

        return new Transaction(
            transactionDTO.id(),
            transactionDTO.amount(),
            transactionDTO.name(),
            transactionDTO.date(),
            transactionDTO.description(),
            transactionDTO.rutDestination(),
            transactionDTO.accountDestination(),
            transactionDTO.rutOrigin(),
            transactionDTO.accountOrigin(),
            typeTransaction,
            bank,
            transactionDTO.idAccount());
    }
}
