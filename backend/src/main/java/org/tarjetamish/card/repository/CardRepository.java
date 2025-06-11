package org.tarjetamish.card.repository;


import org.tarjetamish.card.model.Card;

import java.util.List;
import java.util.Optional;

public interface CardRepository {
    List<Card> findAll();

    Optional<Card> findById(Long id);

    Optional<Card> findByNumber(String number);
    int save(Card card);

    void deleteById(Long id);



    int deleteCardByNumber(String number);

}
