package org.tarjetamish.rowMapper;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.tarjetamish.model.Transaction;
import org.tarjetamish.model.enums.Bank;
import org.tarjetamish.model.enums.TypeTransaction;

import java.sql.ResultSet;
import java.sql.SQLException;
@Component
public class TransactionRowMapper implements RowMapper<Transaction> {
    @Override
    public Transaction mapRow(ResultSet rs, int rowNum) throws SQLException {
        Transaction transaction = new Transaction();
        transaction.setId(rs.getLong("idtransaction"));
        transaction.setAmount(rs.getInt("amount"));
        transaction.setDate(rs.getDate("date"));
        transaction.setDescription(rs.getString("description"));
        transaction.setRutDestination(rs.getString("rutdestino"));
        transaction.setAccountDestination(rs.getString("cuentadestino"));
        transaction.setRutOrigin(rs.getString("rutorigen"));
        transaction.setAccountOrigin(rs.getString("cuentaorigen"));
        String typeTransaction = rs.getString("typetransaction");
        transaction.setTypeTransaction(TypeTransaction.valueOf(typeTransaction));
        String bank = rs.getString("bank");
        transaction.setBank(Bank.valueOf(bank));
        transaction.setIdAccount(rs.getLong("idaccount"));
        return transaction;
    }
}
