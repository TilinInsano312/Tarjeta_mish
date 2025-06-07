package org.tarjetamish.transaction.mapper;

import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.model.Transaction;

public interface ITransactionConverter {

    TransactionDTO toTransactionDTO(Transaction transaction);
    Transaction toTransaction(TransactionDTO transactionDTO);
}
