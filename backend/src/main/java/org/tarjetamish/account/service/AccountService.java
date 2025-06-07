package org.tarjetamish.account.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.account.dto.AccountDTO;
import org.tarjetamish.account.dto.BalanceDTO;
import org.tarjetamish.account.mapper.IAccountConverter;
import org.tarjetamish.account.model.Account;
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
        return Optional.ofNullable(accountRepository.findById(id).map(accountConverter::toAccountDTO).orElse(null));
    }

    public Optional<AccountDTO> findByAccountNumber(int accountNumber) {
        return Optional.ofNullable(accountRepository.findByAccountNumber(accountNumber).map(accountConverter::toAccountDTO).orElse(null));
    }

    public AccountDTO save(AccountDTO account) {
        return accountConverter.toAccountDTO(
                accountRepository.save(accountConverter.toAccount(account))
        );
    }

    public void deleteAccount(Long id) {
        accountRepository.deleteById(id);
    }

    public BalanceDTO getBalance(Long id) {
        Account account = accountRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Account not found"));
        return new BalanceDTO(account.getId(), account.getBalance());
    }
}
