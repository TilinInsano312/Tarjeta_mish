package org.tarjetamish.transaction.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.mapper.ITransactionConverter;
import org.tarjetamish.transaction.model.Transaction;

@Component
public class TransactionConverter implements ITransactionConverter {
    public TransactionDTO toTransactionDTO(Transaction transaction) {
        return new TransactionDTO(transaction.getId(), transaction.getAmount(), transaction.getName(), transaction.getDate(), transaction.getDescription(), transaction.getRutDestination(), transaction.getAccountDestination(), transaction.getRutOrigin(), transaction.getAccountOrigin(), transaction.getTypeTransaction(), transaction.getBank(), transaction.getIdAccount());
    }
    public Transaction toTransaction(TransactionDTO transactionDTO) {
        return new Transaction(transactionDTO.id(), transactionDTO.amount(), transactionDTO.name(), transactionDTO.date(), transactionDTO.description(), transactionDTO.rutDestination(), transactionDTO.accountDestination(), transactionDTO.rutOrigin(), transactionDTO.accountOrigin(), transactionDTO.typeTransaction(), transactionDTO.bank(), transactionDTO.idAccount());
    }
}
