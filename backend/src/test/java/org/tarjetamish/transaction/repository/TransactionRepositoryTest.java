package org.tarjetamish.transaction.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.transaction.mapper.impl.TransactionConverter;
import org.tarjetamish.transaction.model.Transaction;
import org.tarjetamish.transaction.model.enums.TypeTransaction;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;
@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class TransactionRepositoryTest {

    @Autowired
    private TransactionRepository transactionRepository;
    private TransactionConverter transactionConverter;

    @Test
    void testFindById() {
        assertTrue(transactionRepository.findById(1L).isPresent(), "Transaction with ID 1 should exist");
    }
    @Test
    void testDeleteById() {
        Long id = 1L; // Assuming a transaction with ID 1 exists
        assertEquals(1, transactionRepository.deleteById(id), "Transaction should be deleted successfully");
    }
    @Test
    void testSaveTransaction() {
        Date date = new Date( 2025-06-21);
        Transaction transaction = new Transaction(0L, 10000,"pepe", date,"transancion test","21715794-3","123456789", "123456789", "123456789", TypeTransaction.TARJETA_DEBITO, Bank.BANCO_BICE, 1L);
        assertEquals(1, transactionRepository.save(transaction), "Transaction should be saved successfully");
    }
    @Test
    void testListTransactions() {
        assertEquals(1,transactionRepository.findAll().size(), "Transaction list should not be empty");
    }
}
