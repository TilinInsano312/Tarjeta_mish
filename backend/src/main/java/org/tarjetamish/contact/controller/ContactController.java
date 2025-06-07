package org.tarjetamish.contact.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.service.ContactService;

import java.util.List;

@RestController
@RequestMapping("/contact")
@AllArgsConstructor
public class ContactController {

    private final ContactService contactService;

    @GetMapping
    public List<ContactDTO> list() {
        return contactService.list();
    }
    @GetMapping("/name/{name}")
    public ContactDTO getContactByName(@PathVariable String name) {
        return contactService.findByName(name).orElse(null);
    }
    @GetMapping("/alias/{alias}")
    public ContactDTO getContactByAlias(@PathVariable String alias) {
        return contactService.findByAlias(alias).orElse(null);
    }

    @PutMapping
    public void createContact(@RequestBody ContactDTO contactDTO) {
        contactService.save(contactDTO);
    }

    @DeleteMapping
    public void deleteContact(@PathVariable Long id) {
        contactService.deleteContact(id);
    }

}
