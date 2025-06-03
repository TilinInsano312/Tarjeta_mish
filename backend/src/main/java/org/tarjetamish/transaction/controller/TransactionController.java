package org.tarjetamish.transaction.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.service.TransactionService;

import java.util.List;

@RestController
@RequestMapping("/transaction")
@AllArgsConstructor
public class TransactionController {

    private final TransactionService transactionService;

    @GetMapping
    public List<TransactionDTO> list() {
        return transactionService.list();
    }

    @GetMapping("/{id}")
    public TransactionDTO getTransactionById(@PathVariable Long id) {
        return transactionService.findById(id).orElse(null);
    }

    @PostMapping
    public void createTransaction(@RequestBody TransactionDTO transactionDTO) {
        transactionService.save(transactionDTO);
    }

    @DeleteMapping("/{id}")
    public void deleteTransaction(@PathVariable Long id) {
        transactionService.deleteTransaction(id);
    }
}
