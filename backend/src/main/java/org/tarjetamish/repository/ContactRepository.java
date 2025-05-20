package org.tarjetamish.repository;


import org.tarjetamish.model.Contact;

import java.util.List;
import java.util.Optional;

public interface ContactRepository {
    List<Contact> findAll();

    Optional<Contact> findByName(String name);

    Optional<Contact> findByAlias(String alias);

    Contact save(Contact contact);

    void deleteById(Long id);
}
