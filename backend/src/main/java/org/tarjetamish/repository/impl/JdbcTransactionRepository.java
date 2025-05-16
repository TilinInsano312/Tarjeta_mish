package org.tarjetamish.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.model.Transaction;
import org.tarjetamish.repository.TransactionRepository;
import org.tarjetamish.rowMapper.TransactionRowMapper;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcTransactionRepository implements TransactionRepository {

    private final JdbcTemplate jdbc;
    @Override
    public List<Transaction> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.transaction";
        return jdbc.query(sql, new TransactionRowMapper());
    }

    @Override
    public Optional<Transaction> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.transaction WHERE idtransaction = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, new TransactionRowMapper(), id));
    }

    @Override
    public Transaction save(Transaction transaction) {
        String sql = "INSERT INTO tarjeta_mish.transaction (amount, date, description, rutdestination, accountdestination, rutorigin, accountorigin, idtypemovement, idbank, idaccount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbc.queryForObject(sql, new TransactionRowMapper(), transaction.getAmount(), transaction.getDate(), transaction.getDescription(), transaction.getRutDestination(), transaction.getAccountDestination(), transaction.getRutOrigin(), transaction.getAccountOrigin(), transaction.getTypeTransaction().name(), transaction.getBank().name(), transaction.getIdAccount());
    }

    @Override
    public void deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.transaction WHERE idtransaction = ?";
        jdbc.update(sql, id);
    }
}
