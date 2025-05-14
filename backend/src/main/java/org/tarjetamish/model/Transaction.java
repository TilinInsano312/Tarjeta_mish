package org.tarjetamish.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.tarjetamish.model.enums.TypeTransaction;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Transaction {
    private int id;
    private int amount;
    private Date date;
    private User addressee;
    private TypeTransaction typeTransaction;
    private String rutDestino;
    private String cuentaDestino;
    private String rutOrigen;
    private String cuentaOrigen;
}
