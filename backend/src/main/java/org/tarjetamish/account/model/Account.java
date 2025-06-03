package org.tarjetamish.account.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Account {
    private Long id;
    private int balance;
    private int accountNumber;
    private Long idCard;
    private Long idUser;
}
