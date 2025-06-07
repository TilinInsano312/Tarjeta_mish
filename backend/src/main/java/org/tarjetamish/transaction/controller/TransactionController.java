package org.tarjetamish.transaction.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.service.TransactionService;

import java.util.List;

@RestController
@RequestMapping("api/transaction")
@AllArgsConstructor
public class TransactionController {

    private final TransactionService transactionService;

    @GetMapping
    public ResponseEntity<List<TransactionDTO>> list() {
        return ResponseEntity.ok(transactionService.list());
    }

    @GetMapping("/{id}")
    public ResponseEntity<TransactionDTO> getTransactionById(@PathVariable Long id) {
        return transactionService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity createTransaction(@RequestBody TransactionDTO transactionDTO) {
        return ResponseEntity.ok(transactionService.save(transactionDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity deleteTransaction(@PathVariable Long id) {
        return transactionService.findById(id)
                .map(transaction -> {
                    transactionService.deleteTransaction(id);
                    return ResponseEntity.ok().build();
                })
                .orElse(ResponseEntity.notFound().build());
    }
}
