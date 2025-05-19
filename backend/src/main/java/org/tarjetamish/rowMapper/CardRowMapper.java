package org.tarjetamish.rowMapper;

import org.springframework.stereotype.Component;
import org.tarjetamish.model.Card;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class CardRowMapper implements RowMapper<Card> {
    @Override
    public Card mapRow(ResultSet rs, int rowNum) throws SQLException {
        Card card = new Card();
        card.setId(rs.getLong("idcard"));
        card.setCvv(rs.getInt("cvv"));
        card.setNumber(rs.getInt("number"));
        card.setExpirationDate(rs.getString("expirationdate"));
        card.setCardHolderName(rs.getString("cardholdername"));
        return card;
    }

}
