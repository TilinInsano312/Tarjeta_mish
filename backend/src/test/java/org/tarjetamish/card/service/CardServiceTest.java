package org.tarjetamish.card.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.tarjetamish.card.dto.CardDTO;

import java.util.Date;

import static org.junit.jupiter.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class CardServiceTest {

    @Autowired
    private CardService cardService;

    @Test
    void testListCards(){
        assertNotNull(cardService.list(), "Card list should not be null");
    }

    @Test
    void testFindById() {
        assertTrue(cardService.findById(26L).isPresent(), "Card with ID 1 should exist");
    }

    @Test
    void testFindByNumber() {
        String number = "1234567890121256";
        assertTrue(cardService.findByNumber(number).isPresent(), "Card with number " + number + " should exist");
    }

    @Test
    void testSaveCard() {
        Date now = new Date("2040/10/01");
        int result = cardService.save(new CardDTO( 0L,"0987654321123456", "123", now , "Bastian Almonacid"));
        assertEquals(1, result, "Card should be saved successfully");
    }

    @Test
    void testDeleteCard() {
        String number = "0987654321123456";
        assertEquals(1, cardService.deleteCardByNumber(number), "Card should be deleted successfully");

    }
}
