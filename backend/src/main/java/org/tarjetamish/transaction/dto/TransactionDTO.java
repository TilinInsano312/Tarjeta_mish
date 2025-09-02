package org.tarjetamish.transaction.dto;

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
                             Integer typeTransaction,
                             Integer bank,
                             Long idAccount) {

}
