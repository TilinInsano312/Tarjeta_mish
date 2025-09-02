package org.tarjetamish.contact.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.mapper.IContactConverter;
import org.tarjetamish.contact.model.Contact;
import org.tarjetamish.common.utils.EnumMappingUtil;

@Component
public class ContactConverter implements IContactConverter {
    public ContactDTO toContactDTO(Contact contact) {
        Integer typeAccountId = contact.getTypeAccount() != null ?
            EnumMappingUtil.getTypeAccountId(contact.getTypeAccount()) : null;
        Integer bankId = contact.getBank() != null ?
            EnumMappingUtil.getBankId(contact.getBank()) : null;

        return new ContactDTO(
            contact.getId(),
            contact.getName(),
            contact.getAccountNumber(),
            contact.getEmail(),
            contact.getAlias(),
            typeAccountId,
            bankId,
            contact.getIdUser());
    }

    public Contact toContact(ContactDTO contactDTO) {
        return new Contact(
            contactDTO.id(),
            contactDTO.name(),
            contactDTO.accountNumber(),
            contactDTO.email(),
            contactDTO.alias(),
            contactDTO.idTypeAccount() != null ? EnumMappingUtil.getTypeAccountById(contactDTO.idTypeAccount()) : null,
            contactDTO.idBank() != null ? EnumMappingUtil.getBankById(contactDTO.idBank()) : null,
            contactDTO.idUser());
    }
}
