package org.tarjetamish.rowMapper;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.tarjetamish.model.Contact;
import org.tarjetamish.model.enums.Bank;
import org.tarjetamish.model.enums.TypeAccount;

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
        String typeAccount = rs.getString("idtypeaccount");
        contact.setTypeAccount(TypeAccount.valueOf(typeAccount));
        String bank = rs.getString("idbank");
        contact.setBank(Bank.valueOf(bank));
        contact.setIdUser(rs.getLong("iduser"));
        return contact;
    }
}
