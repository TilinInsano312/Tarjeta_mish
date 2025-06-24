package org.tarjetamish.transaction.mapper.impl;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.tarjetamish.transaction.model.Transaction;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.transaction.model.enums.TypeTransaction;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class TransactionRowMapper implements RowMapper<Transaction> {
    @Override
    public Transaction mapRow(ResultSet rs, int rowNum) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setId(rs.getLong("idmovement"));
        transaction.setAmount(rs.getInt("amount"));
        transaction.setName(rs.getString("name"));
        transaction.setDate(rs.getDate("date"));
        transaction.setDescription(rs.getString("description"));
        transaction.setRutDestination(rs.getString("rutdestination"));
        transaction.setAccountDestination(rs.getString("accountdestination"));
        transaction.setRutOrigin(rs.getString("rutorigin"));
        transaction.setAccountOrigin(rs.getString("accountorigin"));
        int typeTransaction = rs.getInt("idtypemovement");
        transaction.setTypeTransaction(TypeTransaction.values()[typeTransaction-1]); // Assuming idtypemovement is 1-based index
        int bank = rs.getInt("idbank");
        transaction.setBank(Bank.values()[bank-1]); // Assuming idbank is 1-based index
        transaction.setIdAccount(rs.getLong("idaccount"));
        return transaction;
    }
}
