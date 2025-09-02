package org.tarjetamish.card.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.card.model.Card;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class CardRowMapper implements RowMapper<Card> {
    @Override
    public Card mapRow(ResultSet rs, int rowNum) throws SQLException {
        Card card = new Card();
        card.setId(rs.getLong("idcard"));
        card.setCvv(rs.getString("cvv"));
        card.setNumber(rs.getString("number"));
        card.setExpirationDate(rs.getDate("expirationdate"));
        card.setCardHolderName(rs.getString("cardholdername"));
        return card;
    }

}
