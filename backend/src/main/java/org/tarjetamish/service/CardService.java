package org.tarjetamish.service;

import org.tarjetamish.dto.CardDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.model.Card;
import org.tarjetamish.repository.CardRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CardService {
    private final CardRepository cardRepository;

    public List<CardDTO> list() {
        return cardRepository.findAll().stream()
                .map(this::convertToDTO)
                .toList();
    }

    public Optional<CardDTO> findById(Long id) {
        return Optional.ofNullable(cardRepository.findById(id).map(this::convertToDTO).orElse(null));
    }

    public CardDTO save(CardDTO card) {
        Card cardEntity = new Card(card.id(), card.number(), card.cvv(), card.expirationDate(), card.cardHolderName());
        return convertToDTO(cardRepository.save(cardEntity));
    }

    public void deleteCard(Long id) {
        cardRepository.deleteById(id);
    }

    private CardDTO convertToDTO(Card card) {
        return new CardDTO(card.getId(), card.getNumber(), card.getCvv(), card.getExpirationDate(), card.getCardHolderName());
    }

    //Do method to get the data of the card
}
