package org.tarjetamish.account.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.tarjetamish.account.model.Account;
import org.tarjetamish.account.repository.AccountRepository;
import org.tarjetamish.account.mapper.impl.AccountRowMapper;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Map;
import java.util.Optional;
@Repository
@RequiredArgsConstructor
public class JdbcAccountRepository implements AccountRepository {

    private final JdbcTemplate jdbc;
    private final AccountRowMapper accountRowMapper;

    @Override
    public List<Account> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.account";
        return jdbc.query(sql, new AccountRowMapper());
    }

    @Override
    public Optional<Account> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.account WHERE idaccount = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, accountRowMapper, id));
    }

    @Override
    public Optional<Account> findByAccountNumber(int accountNumber) {
        String sql = "SELECT * FROM tarjeta_mish.account WHERE accountnumber = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, accountRowMapper, accountNumber));
    }

    @Override
    public int save(Account account) {
        String sql = "INSERT INTO tarjeta_mish.account (balance, accountnumber, idcard, iduser) VALUES (?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbc.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, account.getBalance());
            ps.setInt(2, account.getAccountNumber());
            ps.setLong(3, account.getIdCard());
            ps.setLong(4, account.getIdUser());
            return ps;
        }, keyHolder);

        Map<String, Object> keys = keyHolder.getKeys();
        account.setId(((Number) keys.get("idaccount")).longValue());
        return 1;
    }

    @Override
    public void deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.account WHERE idaccount = ?";
        jdbc.update(sql, id);
    }


    @Override
    public void updateBalance(Long id, int balance) {
        String sql = "UPDATE tarjeta_mish.account SET balance = ? WHERE idaccount = ?";
        jdbc.update(sql, balance, id);
    }



}
