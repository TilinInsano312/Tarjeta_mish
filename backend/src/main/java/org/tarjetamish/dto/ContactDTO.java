package org.tarjetamish.dto;
import org.tarjetamish.model.enums.*;
public record ContactDTO(Long id,
                         String name,
                         int accountNumber,
                         String email,
                         String alias,
                         TypeAccount typeAccount,
                         Bank bank,
                         Long idUser) {
}
