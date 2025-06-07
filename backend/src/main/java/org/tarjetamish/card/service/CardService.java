package org.tarjetamish.card.service;

import org.tarjetamish.card.dto.CardDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.card.mapper.ICardConverter;
import org.tarjetamish.card.repository.CardRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CardService {
    private final CardRepository cardRepository;
    private final ICardConverter cardConverter;

    public List<CardDTO> list() {
        return cardRepository.findAll().stream()
                .map(cardConverter::toCardDTO)
                .toList();
    }

    public Optional<CardDTO> findById(Long id) {
        return Optional.ofNullable(cardRepository.findById(id).map(cardConverter::toCardDTO).orElse(null));
    }

    public CardDTO save(CardDTO card) {
        return cardConverter.toCardDTO(
                cardRepository.save(cardConverter.toCard(card))
        );
    }
    public void deleteCard(Long id) {
        cardRepository.deleteById(id);
    }


    //Do method to get the data of the card
}
