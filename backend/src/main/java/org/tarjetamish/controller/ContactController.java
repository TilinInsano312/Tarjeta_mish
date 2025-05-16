package org.tarjetamish.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.dto.ContactDTO;
import org.tarjetamish.service.ContactService;

import java.util.List;

@RestController
@RequestMapping("/contact")
@AllArgsConstructor
public class ContactController {

    public ContactService contactService;

    @GetMapping
    public List<ContactDTO> list() {
        return contactService.list();
    }
    @GetMapping("/name/{name}")
    public ContactDTO getContactByName(String name) {
        return contactService.findByName(name).orElse(null);
    }
    @GetMapping("/alias/{alias}")
    public ContactDTO getContactByAlias(String alias) {
        return contactService.findByAlias(alias).orElse(null);
    }

    @PutMapping
    public void createContact(@RequestBody ContactDTO contactDTO) {
        contactService.save(contactDTO);
    }

    @DeleteMapping
    public void deleteContact(Long id) {
        contactService.deleteContact(id);
    }

}
