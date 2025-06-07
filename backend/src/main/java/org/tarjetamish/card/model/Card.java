package org.tarjetamish.card.model;

import lombok.*;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Card {
    private Long id;
    private String number;
    private String cvv;
    private Date expirationDate;
    private String cardHolderName;
}
