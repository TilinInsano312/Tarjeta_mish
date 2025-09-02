package org.tarjetamish.card.dto;
import java.util.Date;
public record CardDTO(Long id, String number, String cvv, Date expirationDate, String cardHolderName) { }
