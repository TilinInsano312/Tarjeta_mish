package org.tarjetamish.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.tarjetamish.model.enums.*;
import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Transaction {
    private Long id;
    private int amount;
    private Date date;
    private String description;
    private String rutDestino;
    private String cuentaDestino;
    private String rutOrigen;
    private String cuentaOrigen;
    private TypeTransaction typeTransaction;
    private Bank bank;
    private Long idAccount;


}
