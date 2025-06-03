package org.tarjetamish.contact.dto;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.account.model.enums.TypeAccount;

public record ContactDTO(Long id,
                         String name,
                         int accountNumber,
                         String email,
                         String alias,
                         TypeAccount typeAccount,
                         Bank bank,
                         Long idUser) {
}
