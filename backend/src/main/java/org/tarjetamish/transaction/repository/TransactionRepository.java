package org.tarjetamish.transaction.repository;

import org.tarjetamish.transaction.model.Transaction;

import java.util.List;
import java.util.Optional;

public interface TransactionRepository {
    List<Transaction> findAll();

    Optional<Transaction> findById(Long id);

    int save(Transaction transaction);

    int deleteById(Long id);
}
