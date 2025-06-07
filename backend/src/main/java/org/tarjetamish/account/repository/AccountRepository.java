package org.tarjetamish.account.repository;

import org.tarjetamish.account.model.Account;

import java.util.List;
import java.util.Optional;


public interface AccountRepository {
    List<Account> findAll();

    Optional<Account> findById(Long id);

    Optional<Account> findByAccountNumber(int accountNumber);

    Account save(Account account);

    void deleteById(Long id);

    void updateBalance(Long id, int balance);
}
