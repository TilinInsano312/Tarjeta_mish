package org.tarjetamish.card.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.RequestEntity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.card.dto.CardDTO;
import org.tarjetamish.card.model.Card;
import org.tarjetamish.card.service.CardService;
import java.util.List;


@RestController
@RequestMapping("api/card")
@AllArgsConstructor
public class CardController {
    private final CardService cardService;

    @GetMapping
    public ResponseEntity<List<CardDTO>> getAllCards() {
        return ResponseEntity.ok(cardService.list());
    }
    @GetMapping("/{id}")
    public ResponseEntity<CardDTO> getCardById(@PathVariable Long id) {
        return cardService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    @PostMapping
    public ResponseEntity createCard(@RequestBody CardDTO cardDTO) {
        return ResponseEntity.ok(cardService.save(cardDTO));
    }
    @DeleteMapping("/{id}")
    public ResponseEntity deleteCard(@PathVariable Long id) {
        cardService.deleteCard(id);
        return ResponseEntity.ok().build();
    }
}
