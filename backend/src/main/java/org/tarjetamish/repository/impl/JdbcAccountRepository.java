package org.tarjetamish.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.model.Account;
import org.tarjetamish.repository.AccountRepository;
import org.tarjetamish.rowMapper.AccountRowMapper;

import java.util.List;
import java.util.Optional;
@Repository
@RequiredArgsConstructor
public class JdbcAccountRepository implements AccountRepository {

    private final JdbcTemplate jdbc;

    @Override
    public List<Account> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.account";
        return jdbc.query(sql, new AccountRowMapper());
    }

    @Override
    public Optional<Account> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.account WHERE idaccount = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, new AccountRowMapper(), id));
    }

    @Override
    public Optional<Account> findByAccountNumber(int accountNumber) {
        String sql = "SELECT * FROM tarjeta_mish.account WHERE accountnumber = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, new AccountRowMapper(), accountNumber));
    }

    @Override
    public Account save(Account account) {
        String sql = "INSERT INTO tarjeta_mish.account (balance, accountnumber, idcard, iduser) VALUES (?, ?, ?, ?)";
        return jdbc.queryForObject(sql, new AccountRowMapper(), account.getBalance(), account.getAccountNumber(), account.getIdCard(), account.getIdUser());
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
