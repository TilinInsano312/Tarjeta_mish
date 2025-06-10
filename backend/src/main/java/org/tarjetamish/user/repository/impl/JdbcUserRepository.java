package org.tarjetamish.user.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;
import org.tarjetamish.user.mapper.impl.UserRowMapper;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcUserRepository implements UserRepository {

    private final JdbcTemplate jdbc;
    private final UserRowMapper userRowMapper;
    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.user";
        return jdbc.query(sql, userRowMapper);
    }

    @Override
    public Optional<User> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.user WHERE iduser = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, userRowMapper, id));
    }

    @Override
    public int save(User user) {
        String sql = "INSERT INTO tarjeta_mish.user (rut, name, email, pin) VALUES (?, ?, ?, ?)";
        jdbc.queryForObject(sql, userRowMapper, user.getRut(), user.getName(), user.getEmail(), user.getPin());
        return 1;
    }

    @Override
    public void deleteByRut(String  rut) {
        String sql = "DELETE FROM tarjeta_mish.user WHERE rut = ?";
        jdbc.update(sql, rut);
    }

    @Override
    public Optional<User> findByRut(String rut) {
        String sql = "SELECT * FROM tarjeta_mish.user WHERE rut = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, userRowMapper, rut));
    }

    @Override
    public boolean existByRut(String rut) {
        String sql = "SELECT COUNT(*) FROM tarjeta_mish.user WHERE rut = ?";
        Integer count = jdbc.queryForObject(sql, Integer.class, rut);
        return count != null && count > 0;
    }
}
