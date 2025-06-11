package org.tarjetamish.card.repository;


import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.tarjetamish.card.model.Card;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class CardRepositoryTest {

    @Autowired
    private CardRepository cardRepository;

    @Test
    void findByNumber() {
        String number= "1234567890121256";
        Optional<Card> card = cardRepository.findByNumber(number);
        assertTrue(card.isPresent(), "Card with number  should exist");
    }

    @Test
    void addCard() {
        Card card = new Card(0L, "1234876512346789", "123", new java.util.Date("2040/10/01"), "Bastian Almonacid");
        int result = cardRepository.save(card);
        assertEquals(1, result, "Card should be added successfully");
    }

    @Test
    void deleteCard() {
        String number = "1234876512346789";
        assertEquals(1, cardRepository.deleteCardByNumber(number), "Card should be deleted successfully");
    }

}
