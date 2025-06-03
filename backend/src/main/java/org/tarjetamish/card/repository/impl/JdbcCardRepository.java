package org.tarjetamish.card.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.card.model.Card;
import org.tarjetamish.card.repository.CardRepository;
import org.tarjetamish.card.mapper.CardRowMapper;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcCardRepository implements CardRepository {

    private final JdbcTemplate jdbc;

    @Override
    public List<Card> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.card";
        return jdbc.query(sql, new CardRowMapper());
    }

    @Override
    public Optional<Card> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.card WHERE idcard = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, new CardRowMapper(), id));
    }

    @Override
    public Card save(Card card) {
        String sql = "INSERT INTO tarjeta_mish.card (number, cvv, expirationdate, cardholdername) VALUES (?, ?, ?, ?)";
        return jdbc.queryForObject(sql, new CardRowMapper(), card.getNumber(), card.getCvv(), card.getExpirationDate(), card.getCardHolderName());
    }

    @Override
    public void deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.card WHERE idcard = ?";
        jdbc.update(sql, id);

    }
}
