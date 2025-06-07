package org.tarjetamish.account.mapper.impl;

import org.springframework.jdbc.core.RowMapper;

import org.springframework.stereotype.Component;
import org.tarjetamish.account.model.Account;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class AccountRowMapper implements RowMapper<Account> {
    @Override
    public Account mapRow(ResultSet rs, int rowNum) throws SQLException {
        Account account = new Account();
        account.setId(rs.getLong("idaccount"));
        account.setBalance(rs.getInt("balance"));
        account.setAccountNumber(rs.getInt("accountnumber"));
        account.setIdCard(rs.getLong("idcard"));
        account.setIdUser(rs.getLong("iduser"));
        return account;
    }

}
