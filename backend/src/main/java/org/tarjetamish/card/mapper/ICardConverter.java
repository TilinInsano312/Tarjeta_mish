package org.tarjetamish.card.mapper;

import org.tarjetamish.card.dto.CardDTO;
import org.tarjetamish.card.model.Card;

public interface ICardConverter {
    CardDTO toCardDTO(Card card);
    Card toCard(CardDTO cardDTO);
}
