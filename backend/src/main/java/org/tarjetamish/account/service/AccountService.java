package org.tarjetamish.account.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.account.exception.AccountNotFoundException;
import org.tarjetamish.account.dto.AccountDTO;
import org.tarjetamish.account.mapper.IAccountConverter;
import org.tarjetamish.account.repository.AccountRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AccountService {
    private final AccountRepository accountRepository;
    private final IAccountConverter accountConverter;

    public List<AccountDTO> list() {
        return accountRepository.findAll().stream()
                .map(accountConverter::toAccountDTO)
                .toList();
    }

    public Optional<AccountDTO> findById(Long id) {
        return Optional.ofNullable(accountRepository.findById(id).map(accountConverter::toAccountDTO).orElseThrow(AccountNotFoundException::new));
    }

    public Optional<AccountDTO> findByAccountNumber(String accountNumber) {
        return Optional.ofNullable(accountRepository.findByAccountNumber(accountNumber).map(accountConverter::toAccountDTO).orElseThrow(AccountNotFoundException::new));
    }

    public int save(AccountDTO account) {
        return accountRepository.save(accountConverter.toAccount(account));
    }

    /**
     * Descuenta dinero de una cuenta específica
     */
    public void deductBalance(Long accountId, int amount) {
        Optional<AccountDTO> account = findById(accountId);
        if (account.isEmpty()) {
            throw new AccountNotFoundException();
        }

        AccountDTO currentAccount = account.get();
        int newBalance = currentAccount.balance() - amount;

        // Permitir balances negativos si es necesario, o validar aquí
        if (newBalance < 0) {
            throw new RuntimeException("Fondos insuficientes. Balance actual: " + currentAccount.balance() + ", monto a descontar: " + amount);
        }

        accountRepository.updateBalance(accountId, newBalance);
    }

    /**
     * Añade dinero a una cuenta específica
     */
    public void addBalance(Long accountId, int amount) {
        Optional<AccountDTO> account = findById(accountId);
        if (account.isEmpty()) {
            throw new AccountNotFoundException();
        }

        AccountDTO currentAccount = account.get();
        int newBalance = currentAccount.balance() + amount;

        accountRepository.updateBalance(accountId, newBalance);
    }

    /**
     * Añade dinero a una cuenta por número de cuenta
     */
    public void addBalanceByAccountNumber(String accountNumber, int amount) {
        Optional<AccountDTO> account = findByAccountNumber(accountNumber);
        if (account.isEmpty()) {
            throw new AccountNotFoundException();
        }

        addBalance(account.get().id(), amount);
    }

    public void deleteAccount(Long id) {
        accountRepository.deleteById(id);
    }
}
