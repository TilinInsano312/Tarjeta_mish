package org.tarjetamish.contact.repository.impl;


import org.tarjetamish.contact.model.Contact;

import java.util.List;
import java.util.Optional;

public interface ContactRepository {
    List<Contact> findAll();

    List<Contact> findById(int id);

    Optional<Contact> findByName(String name);

    Optional<Contact> findByAlias(String alias);

    int save(Contact contact);

    int deleteById(int id);
}
