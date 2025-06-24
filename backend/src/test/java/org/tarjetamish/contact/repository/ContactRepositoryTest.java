package org.tarjetamish.contact.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.account.model.enums.TypeAccount;
import org.tarjetamish.contact.model.Contact;

import static org.junit.jupiter.api.Assertions.*;
@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ContactRepositoryTest {

    @Autowired
    private ContactRepository contactRepository;

    @Test
    void testFindAll() {
        assertNotNull(contactRepository.findAll(), "Contact list should not be null");
    }
    @Test
    void testFindById() {
        int idUser = 1;
        assertNotNull(contactRepository.findById(idUser), "Contacts for user with ID " + idUser + " should not be null");
    }
    @Test
    void testFindByName() {
        String name = "pepe";
        assertTrue(contactRepository.findByName(name).isPresent(), "Contact with name " + name + " should exist");
    }
    @Test
    void testFindByAlias() {
        String alias = "jose";
        assertTrue(contactRepository.findByAlias(alias).isPresent(), "Contact with alias " + alias + " should exist");
    }
    @Test
    void testSaveContact() {
        Contact contact = new Contact(0L, "John Doe", 123456789, "example@test.com", "juan", TypeAccount.CUENTA_VISTA, Bank.BANCO_DE_CHILE, 1L);
        assertEquals(1, contactRepository.save(contact), "Contact should be saved successfully");
    }
    @Test
    void testDeleteContact() {
        Long contactId = 2L;
        assertEquals(1, contactRepository.deleteById(contactId), "Contact should be deleted successfully");
    }
}
