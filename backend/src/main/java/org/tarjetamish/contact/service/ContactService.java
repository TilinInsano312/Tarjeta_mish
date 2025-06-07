package org.tarjetamish.contact.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.mapper.IContactConverter;
import org.tarjetamish.contact.model.Contact;
import org.tarjetamish.contact.repository.impl.ContactRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ContactService {
    private final ContactRepository contactRepository;
    private final IContactConverter contactConverter;

    public List<ContactDTO> list() {
        return contactRepository.findAll().stream()
                .map(contactConverter::toContactDTO)
                .toList();
    }

    public Optional<ContactDTO> findByName(String name) {
        return Optional.ofNullable(contactRepository.findByName(name).map(contactConverter::toContactDTO).orElse(null));
    }

    public Optional<ContactDTO> findByAlias(String alias) {
        return Optional.ofNullable(contactRepository.findByAlias(alias).map(contactConverter::toContactDTO).orElse(null));
    }

    public ContactDTO save(ContactDTO contact) {
        return contactConverter.toContactDTO(
                contactRepository.save(contactConverter.toContact(contact))
        );
    }

    public void deleteContact(Long id) {
        contactRepository.deleteById(id);
    }

}
