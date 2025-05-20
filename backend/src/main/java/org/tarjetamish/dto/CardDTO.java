package org.tarjetamish.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CardDTO {
    private Long id;
    private String number;
    private String cvv;
    private Date expirationDate;
    private String cardHolderName;
}
