package org.tarjetamish.account.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.account.dto.AccountDTO;
import org.tarjetamish.account.dto.BalanceDTO;
import org.tarjetamish.account.model.Account;
import org.tarjetamish.account.repository.AccountRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AccountService {
    private final AccountRepository accountRepository;

    public List<AccountDTO> list() {
        return accountRepository.findAll().stream()
                .map(this::convertToDTO)
                .toList();
    }

    public Optional<AccountDTO> findById(Long id) {
        return Optional.ofNullable(accountRepository.findById(id).map(this::convertToDTO).orElse(null));
    }

    public Optional<AccountDTO> findByAccountNumber(int accountNumber) {
        return Optional.ofNullable(accountRepository.findByAccountNumber(accountNumber).map(this::convertToDTO).orElse(null));
    }

    public AccountDTO save(AccountDTO account) {
        Account accountEntity = new Account(account.id(), account.balance(), account.accountNumber(), account.idCard(), account.idUser());
        return convertToDTO(accountRepository.save(accountEntity));
    }

    public void deleteAccount(Long id) {
        accountRepository.deleteById(id);
    }

    private AccountDTO convertToDTO(Account account) {
        return new AccountDTO(account.getId(), account.getBalance(), account.getAccountNumber(), account.getIdCard(), account.getIdUser());
    }

    public BalanceDTO getBalance(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        return new BalanceDTO(account.getId(), account.getBalance());
    }
}
