package org.tarjetamish.transaction.service;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.model.enums.TypeTransaction;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;
@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class TransactionServiceTest {

    @Autowired
    private TransactionService transactionService;

    @Test
    void testListTransactions() {
        assertNotNull(transactionService.list(), "Transaction list should not be null");
    }
    @Test
    void testFindById() {
        assertEquals(1,transactionService.findById(1L).get().id(), "Transaction with ID 1 should exist");
    }
    @Test
    void testSaveTransaction() {
        Date date = new Date( 2025-06-21); // Adjust the date format as needed
        TransactionDTO transactionDTO = new TransactionDTO(0L, 10000,"pepe", date,"transancion test","21715794-3","123456789", "123456789", "123456789", TypeTransaction.TARJETA_DEBITO, Bank.BANCO_BICE, 1L);
        assertEquals(1L, transactionService.save(transactionDTO), "Transaction should be saved successfully");
    }
    @Test
    void testDeleteTransaction() {
        Long id = 1L; // Assuming a transaction with ID 1 exists
        assertEquals(1, transactionService.deleteTransaction(id), "Transaction should be deleted successfully");
    }
}
