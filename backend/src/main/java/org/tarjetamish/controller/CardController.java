package org.tarjetamish.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.dto.CardDTO;
import org.tarjetamish.service.CardService;
import java.util.List;


@RestController
@RequestMapping("/card")
@AllArgsConstructor
public class CardController {
    private final CardService cardService;

    @GetMapping
    public List<CardDTO> getAllCards() {
        return cardService.list();
    }
    @GetMapping("/{id}")
    public CardDTO getCardById(@PathVariable Long id) {
        return cardService.findById(id).orElse(null);
    }
    @PostMapping
    public void createCard(@RequestBody CardDTO cardDTO) {
        cardService.save(cardDTO);
    }
    @DeleteMapping("/{id}")
    public void deleteCard(@PathVariable Long id) {
        cardService.deleteCard(id);
    }
}
