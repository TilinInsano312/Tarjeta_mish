package org.tarjetamish.card.service;

import org.tarjetamish.card.dto.CardDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.card.exception.CardNotFoundException;
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
        return Optional.ofNullable(cardRepository.findById(id).map(cardConverter::toCardDTO).orElseThrow(CardNotFoundException::new));
    }

    public Optional<CardDTO> findByNumber(String number) {
        return cardRepository.findByNumber(number)
                .map(cardConverter::toCardDTO);
    }

    public int save(CardDTO cardDTO) {
        return cardRepository.save(cardConverter.toCard(cardDTO));

    }
    public void deleteCard(Long id) {
        cardRepository.deleteById(id);
    }

    public int deleteCardByNumber(String number) {
        return cardRepository.deleteCardByNumber(number);
    }

}
