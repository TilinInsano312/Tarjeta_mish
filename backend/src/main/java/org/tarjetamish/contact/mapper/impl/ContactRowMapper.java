package org.tarjetamish.contact.mapper.impl;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.tarjetamish.contact.model.Contact;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.account.model.enums.TypeAccount;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class ContactRowMapper implements RowMapper<Contact> {
    @Override
    public Contact mapRow(ResultSet rs, int rowNum) throws SQLException {
        Contact contact = new Contact();
        contact.setId(rs.getLong("idcontact"));
        contact.setName(rs.getString("name"));
        contact.setAccountNumber(rs.getInt("numbaccount"));
        contact.setEmail(rs.getString("email"));
        contact.setAlias(rs.getString("alias"));
        int typeAccount = rs.getInt("idtypeaccount");
        contact.setTypeAccount(TypeAccount.values()[typeAccount-1]);
        int bank = rs.getInt("idbank");
        contact.setBank(Bank.values()[bank-1]); // Assuming idbank is 1-based index
        contact.setIdUser(rs.getLong("iduser"));
        return contact;
    }
}
