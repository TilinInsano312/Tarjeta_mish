package org.tarjetamish.contact.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.contact.model.Contact;
import org.tarjetamish.contact.mapper.impl.ContactRowMapper;
import org.tarjetamish.contact.repository.ContactRepository;
import org.tarjetamish.common.utils.EnumMappingUtil;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcContactRepository implements ContactRepository {

    private final JdbcTemplate jdbc;
    private final ContactRowMapper contactRowMapper;

    @Override
    public List<Contact> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.contact";
        return jdbc.query(sql, contactRowMapper);
    }

    @Override
    public List<Contact> findById(int iduser) {
        String sql = "SELECT * FROM tarjeta_mish.contact WHERE iduser = ?";
        return jdbc.query(sql, contactRowMapper, iduser);
    }

    @Override
    public Optional<Contact> findByName(String name) {
        String sql = "SELECT * FROM tarjeta_mish.contact WHERE name = ?";
        try {
            Contact contact = jdbc.queryForObject(sql, contactRowMapper, name);
            return Optional.ofNullable(contact);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public Optional<Contact> findByAlias(String alias) {
        String sql = "SELECT * FROM tarjeta_mish.contact WHERE alias = ?";
        try {
            Contact contact = jdbc.queryForObject(sql, contactRowMapper, alias);
            return Optional.ofNullable(contact);
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    @Override
    public int save(Contact contact) {
        String sql = "INSERT INTO tarjeta_mish.contact (name, numbaccount, email, alias, idtypeaccount, idbank, iduser) VALUES (?, ?, ?, ?, ?, ?, ?)";
        return jdbc.update(sql,
            contact.getName(),
            contact.getAccountNumber(),
            contact.getEmail(),
            contact.getAlias(),
            EnumMappingUtil.getTypeAccountId(contact.getTypeAccount()),
            EnumMappingUtil.getBankId(contact.getBank()),
            contact.getIdUser()
        );
    }

    @Override
    public int deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.contact WHERE idcontact = ?";
        return jdbc.update(sql, id);
    }
}
