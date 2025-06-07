package org.tarjetamish.contact.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.model.Contact;
import org.tarjetamish.contact.repository.impl.ContactRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ContactService {
    private final ContactRepository contactRepository;

    public List<ContactDTO> list() {
        return contactRepository.findAll().stream()
                .map(this::convertToDTO)
                .toList();
    }

    public Optional<ContactDTO> findByName(String name) {
        return Optional.ofNullable(contactRepository.findByName(name).map(this::convertToDTO).orElse(null));
    }

    public Optional<ContactDTO> findByAlias(String alias) {
        return Optional.ofNullable(contactRepository.findByAlias(alias).map(this::convertToDTO).orElse(null));
    }

    public ContactDTO save(ContactDTO contact) {
        Contact contactEntity = new Contact(contact.id(), contact.name(), contact.accountNumber(), contact.email(), contact.alias(), contact.typeAccount(), contact.bank(), contact.idUser());
        return convertToDTO(contactRepository.save(contactEntity));
    }

    public void deleteContact(Long id) {
        contactRepository.deleteById(id);
    }

    private ContactDTO convertToDTO(Contact contact) {
        return new ContactDTO(contact.getId(), contact.getName(), contact.getAccountNumber(), contact.getEmail(), contact.getAlias(), contact.getTypeAccount(), contact.getBank(), contact.getIdUser());
    }

}
