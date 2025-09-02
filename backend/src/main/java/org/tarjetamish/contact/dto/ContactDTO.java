package org.tarjetamish.contact.dto;

public record ContactDTO(Long id,
                         String name,
                         String accountNumber,
                         String email,
                         String alias,
                         Integer idTypeAccount,
                         Integer idBank,
                         Long idUser) {
}
