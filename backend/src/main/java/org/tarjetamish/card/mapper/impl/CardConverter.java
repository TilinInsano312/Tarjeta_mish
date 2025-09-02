package org.tarjetamish.card.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.card.dto.CardDTO;
import org.tarjetamish.card.mapper.ICardConverter;
import org.tarjetamish.card.model.Card;

@Component
public class CardConverter implements ICardConverter {

    public CardDTO toCardDTO(Card card) {
        return new CardDTO(card.getId(), card.getNumber(), card.getCvv(), card.getExpirationDate(), card.getCardHolderName());
    }
    public Card toCard(CardDTO cardDTO) {
        return new Card(cardDTO.id(), cardDTO.number(), cardDTO.cvv(), cardDTO.expirationDate(), cardDTO.cardHolderName());
    }
}
