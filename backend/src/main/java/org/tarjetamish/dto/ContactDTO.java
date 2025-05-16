package org.tarjetamish.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import org.tarjetamish.model.enums.*;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ContactDTO {
    private Long id;
    private String name;
    private int accountNumber;
    private String email;
    private String alias;
    private TypeAccount typeAccount;
    private Bank bank;
    private Long idUser;
}
