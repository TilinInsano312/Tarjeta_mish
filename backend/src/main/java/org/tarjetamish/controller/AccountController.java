package org.tarjetamish.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.dto.AccountDTO;
import org.tarjetamish.dto.BalanceDTO;
import org.tarjetamish.service.AccountService;

import java.util.List;

@RestController
@RequestMapping("/account")
@AllArgsConstructor
public class AccountController {
    private final AccountService accountService;

    @GetMapping
    public List<AccountDTO> getAllAccounts() {
        return accountService.list();
    }
    @GetMapping("/{id}")
    public AccountDTO getAccountById(Long id) {
        return accountService.findById(id).orElse(null);
    }
    @GetMapping("/accountnumber/{accountNumber}")
    public AccountDTO getAccountByAccountNumber(@PathVariable int accountNumber) {
        return accountService.findByAccountNumber(accountNumber).orElse(null);
    }
    @PostMapping
    public void createAccount(@RequestBody AccountDTO accountDTO) {
        accountService.save(accountDTO);
    }
    @DeleteMapping("/{id}")
    public void deleteAccount(@PathVariable Long id) {
        accountService.deleteAccount(id);
    }
    @GetMapping("/balance/{id}")
    public BalanceDTO balance(@PathVariable Long id) {
        return accountService.getBalance(id);
    }
}