package org.tarjetamish.contact.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.contact.dto.ContactDTO;
import org.tarjetamish.contact.service.ContactService;

import java.util.List;

@RestController
@RequestMapping("api/contact")
@AllArgsConstructor
public class ContactController {

    private final ContactService contactService;

    @GetMapping
    public ResponseEntity<List<ContactDTO>> list() {
        return ResponseEntity.ok(contactService.list());
    }
    @GetMapping("/name/{name}")
    public ResponseEntity<ContactDTO> getContactByName(@PathVariable String name) {
        return contactService.findByName(name)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    @GetMapping("/alias/{alias}")
    public ResponseEntity<ContactDTO> getContactByAlias(@PathVariable String alias) {
        return contactService.findByAlias(alias)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping
    public ResponseEntity createContact(@RequestBody ContactDTO contactDTO) {
        return ResponseEntity.ok(contactService.save(contactDTO));
    }

    @DeleteMapping
    public ResponseEntity deleteContact(@PathVariable Long id) {
        contactService.deleteContact(id);
        return ResponseEntity.ok().build();
    }

}
