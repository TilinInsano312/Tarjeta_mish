package org.tarjetamish.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.tarjetamish.model.enums.Bank;
import org.tarjetamish.model.enums.TypeTransaction;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Transaction {
    private Long id;
    private int amount;
    private String name;
    private Date date;
    private String description;
    private String rutDestination;
    private String accountDestination;
    private String rutOrigin;
    private String accountOrigin;
    private TypeTransaction typeTransaction;
    private Bank bank;
    private Long idAccount;

}
