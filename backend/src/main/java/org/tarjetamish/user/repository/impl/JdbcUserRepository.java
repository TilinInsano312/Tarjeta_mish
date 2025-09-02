package org.tarjetamish.user.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;
import org.tarjetamish.user.mapper.impl.UserRowMapper;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcUserRepository implements UserRepository {

    private final JdbcTemplate jdbc;
    private final UserRowMapper userRowMapper;
    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.\"user\"";
        return jdbc.query(sql, userRowMapper);
    }

    @Override
    public Optional<User> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.\"user\" WHERE iduser = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, userRowMapper, id));
    }

    @Override
    public int save(User user) {
        String sql = "INSERT INTO tarjeta_mish.\"user\" (rut, name, email, pin) VALUES (?, ?, ?, ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();

        jdbc.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getRut());
            ps.setString(2, user.getName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPin());
            return ps;
        }, keyHolder);

        Map<String, Object> keys = keyHolder.getKeys();
        user.setId(((Number) keys.get("iduser")).longValue());
        return 1;
    }

    @Override
    public int deleteByRut(String  rut) {
        String sql = "DELETE FROM tarjeta_mish.\"user\" WHERE rut = ?";
        return jdbc.update(sql, rut);
    }

    @Override
    public Optional<User> findByRut(String rut) {
        String sql = "SELECT * FROM tarjeta_mish.\"user\" WHERE rut = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, userRowMapper, rut));
    }

    @Override
    public boolean existByRut(String rut) {
        String sql = "SELECT COUNT(*) FROM tarjeta_mish.\"user\" WHERE rut = ?";
        Integer count = jdbc.queryForObject(sql, Integer.class, rut);
        return count != null && count > 0;
    }
}
