package org.tarjetamish.dto;
import org.tarjetamish.model.enums.*;
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
