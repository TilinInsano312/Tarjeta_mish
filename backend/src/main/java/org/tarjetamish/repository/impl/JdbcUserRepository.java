package org.tarjetamish.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.model.User;
import org.tarjetamish.repository.UserRepository;
import org.tarjetamish.rowMapper.UserRowMapper;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcUserRepository implements UserRepository {

    private final JdbcTemplate jdbc;
    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.user";
        return jdbc.query(sql, new UserRowMapper());
    }

    @Override
    public Optional<User> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.user WHERE iduser = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, new UserRowMapper(), id));
    }

    @Override
    public User save(User user) {
        String sql = "INSERT INTO tarjeta_mish.user (rut, name, email, pin, idAccount) VALUES (?, ?, ?, ?, ?)";
        return jdbc.queryForObject(sql, new UserRowMapper(), user.getRut(), user.getName(), user.getEmail(), user.getPin(), user.getIdAccount());
    }

    @Override
    public void deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.user WHERE iduser = ?";
        jdbc.update(sql, id);
    }
}
