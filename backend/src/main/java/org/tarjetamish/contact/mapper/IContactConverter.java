package org.tarjetamish.contact.mapper;

import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.model.Contact;

public interface IContactConverter {
    ContactDTO toContactDTO(Contact contact);
    Contact toContact(ContactDTO contactDTO);
}
