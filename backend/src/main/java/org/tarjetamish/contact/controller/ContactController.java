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
    @GetMapping("/user/{iduser}")
    public ResponseEntity<List<ContactDTO>> listByIdUser(@PathVariable int iduser) {
        return ResponseEntity.ok(contactService.findByIdUser(iduser));
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
    @PostMapping
    public ResponseEntity<Integer> createContact(@RequestBody ContactDTO contactDTO) {
        return ResponseEntity.status(201).body(contactService.save(contactDTO));
    }
    @DeleteMapping("/{idcontact}")
    public ResponseEntity<Integer> deleteContact(@PathVariable Long idcontact) {
        return ResponseEntity.ok(contactService.deleteContact(idcontact));
    }

}
