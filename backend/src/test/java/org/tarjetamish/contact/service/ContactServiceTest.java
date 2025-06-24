package org.tarjetamish.contact.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.account.model.enums.TypeAccount;
import org.tarjetamish.contact.dto.ContactDTO;

import static org.junit.jupiter.api.Assertions.*;
@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class ContactServiceTest {

    @Autowired
    private ContactService contactService;

    @Test
    void testListContacts() {
        assertNotNull(contactService.list(), "Contact list should not be null");
    }
    @Test
    void testFindByIdUser() {
        int idUser = 1;
        assertNotNull(contactService.findByIdUser(idUser), "Contacts for user with ID " + idUser + " should not be null");
    }
    @Test
    void testFindByName() {
        String name = "pepe";
        assertTrue(contactService.findByName(name).isPresent(), "Contact with name " + name + " should exist");
    }
    @Test
    void testFindByAlias() {
        String alias = "jose";
        assertTrue(contactService.findByAlias(alias).isPresent(), "Contact with alias " + alias + " should exist");
    }
    @Test
    void testSaveContact() {
        ContactDTO contactDTO = new ContactDTO(0L, "John Doe", 123456789, "example@test.com", "juan", TypeAccount.CUENTA_VISTA, Bank.BANCO_DE_CHILE, 1L);
        assertEquals(1,contactService.save(contactDTO));
    }
    @Test
    void testDeleteContact() {
        assertEquals(1,contactService.deleteContact(2L) , "Contact should be deleted successfully");
    }
}
