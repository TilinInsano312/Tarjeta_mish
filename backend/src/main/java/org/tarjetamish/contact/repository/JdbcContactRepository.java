package org.tarjetamish.contact.repository;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.contact.model.Contact;
import org.tarjetamish.contact.repository.impl.ContactRepository;
import org.tarjetamish.contact.mapper.ContactRowMapper;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcContactRepository implements ContactRepository {

    private final JdbcTemplate jdbc;
    @Override
    public List<Contact> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.contact";
        return jdbc.query(sql, new ContactRowMapper());
    }

    @Override
    public Optional<Contact> findByName(String name) {
        String sql = "SELECT * FROM tarjeta_mish.contact WHERE name = ?";
        return Optional.empty();
    }

    @Override
    public Optional<Contact> findByAlias(String alias) {
        String sql = "SELECT * FROM tarjeta_mish.contact WHERE alias = ?";
        return Optional.empty();
    }

    @Override
    public Contact save(Contact contact) {
        String sql = "INSERT INTO tarjeta_mish.contact (name, numbaccount, email, alias, typeaccount, bank, iduser) VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbc.queryForObject(sql, new ContactRowMapper(), contact.getName(), contact.getAccountNumber(), contact.getEmail(), contact.getAlias(), contact.getTypeAccount().name(), contact.getBank().name(), contact.getIdUser());
    }

    @Override
    public void deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.contact WHERE idcontact = ?";
        jdbc.update(sql, id);
    }
}
