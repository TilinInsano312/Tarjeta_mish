package org.tarjetamish.model;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Card {
    private Long id;
    private int number;
    private int cvv;
    private String expirationDate;
    private String cardHolderName;
}
