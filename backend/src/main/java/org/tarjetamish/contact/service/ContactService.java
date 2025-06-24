package org.tarjetamish.contact.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.exception.ContactNotFoundException;
import org.tarjetamish.contact.mapper.IContactConverter;
import org.tarjetamish.contact.repository.ContactRepository;

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

    public List<ContactDTO> findByIdUser(int iduser) {
        return contactRepository.findById(iduser).stream()
                .map(contactConverter::toContactDTO)
                .toList();
    }

    public Optional<ContactDTO> findByName(String name) {
        return Optional.ofNullable(contactRepository.findByName(name).map(contactConverter::toContactDTO).orElseThrow(ContactNotFoundException::new));
    }

    public Optional<ContactDTO> findByAlias(String alias) {
        return Optional.ofNullable(contactRepository.findByAlias(alias).map(contactConverter::toContactDTO).orElseThrow(ContactNotFoundException::new));
    }

    public int save(ContactDTO contact) {
        return contactRepository.save(contactConverter.toContact(contact));
    }

    public int deleteContact(Long id) {
        return contactRepository.deleteById(id);
    }

}
