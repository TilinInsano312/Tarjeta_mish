package org.tarjetamish.dto;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CardDTO {
    private Long id;
    private int number;
    private int cvv;
    private String expirationDate;
    private String cardHolderName;
}
