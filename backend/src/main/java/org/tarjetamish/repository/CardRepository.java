package org.tarjetamish.repository;


import org.tarjetamish.model.Card;

import java.util.List;
import java.util.Optional;

public interface CardRepository {
    List<Card> findAll();

    Optional<Card> findById(Long id);

    Card save(Card card);

    void deleteById(Long id);

}
