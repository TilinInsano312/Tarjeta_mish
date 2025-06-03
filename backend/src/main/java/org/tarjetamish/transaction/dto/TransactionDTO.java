package org.tarjetamish.transaction.dto;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.transaction.model.enums.TypeTransaction;

import java.util.Date;
public record TransactionDTO(Long id,
                             int amount,
                             String name,
                             Date date,
                             String description,
                             String rutDestination,
                             String accountDestination,
                             String rutOrigin,
                             String accountOrigin,
                             TypeTransaction typeTransaction,
                             Bank bank,
                             Long idAccount) {

}
