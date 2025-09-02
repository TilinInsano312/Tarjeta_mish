package org.tarjetamish.contact.mapper.impl;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.tarjetamish.contact.model.Contact;
import org.tarjetamish.common.utils.EnumMappingUtil;

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

        // Usar la utilidad de mapeo para convertir IDs a enums
        int typeAccountId = rs.getInt("idtypeaccount");
        contact.setTypeAccount(EnumMappingUtil.getTypeAccountById(typeAccountId));

        int bankId = rs.getInt("idbank");
        contact.setBank(EnumMappingUtil.getBankById(bankId));

        contact.setIdUser(rs.getLong("iduser"));
        return contact;
    }
}
