package org.tarjetamish.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.dto.ContactDTO;
import org.tarjetamish.model.Contact;
import org.tarjetamish.repository.ContactRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ContactService {
    public final ContactRepository contactRepository;

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
        Contact contactEntity = new Contact(contact.getId(), contact.getName(), contact.getAccountNumber(), contact.getEmail(), contact.getAlias(), contact.getTypeAccount(), contact.getBank(), contact.getIdUser());
        return convertToDTO(contactRepository.save(contactEntity));
    }
    public void deleteContact(Long id) {
        contactRepository.deleteById(id);
    }
    private ContactDTO convertToDTO(Contact contact) {
        return new ContactDTO(contact.getId(), contact.getName(), contact.getAccountNumber(), contact.getEmail(), contact.getAlias(), contact.getTypeAccount(), contact.getBank(), contact.getIdUser());
    }

}
