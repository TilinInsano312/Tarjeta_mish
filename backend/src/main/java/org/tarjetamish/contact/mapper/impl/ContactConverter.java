package org.tarjetamish.contact.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.mapper.IContactConverter;
import org.tarjetamish.contact.model.Contact;

@Component
public class ContactConverter implements IContactConverter {
    public ContactDTO toContactDTO(Contact contact) {
        return new ContactDTO(contact.getId(), contact.getName(), contact.getAccountNumber(), contact.getEmail(), contact.getAlias(), contact.getTypeAccount(), contact.getBank(), contact.getIdUser());
    }
    public Contact toContact(ContactDTO contactDTO) {
        return new Contact(contactDTO.id(), contactDTO.name(), contactDTO.accountNumber(), contactDTO.email(), contactDTO.alias(), contactDTO.typeAccount(), contactDTO.bank(), contactDTO.idUser());
    }
}
