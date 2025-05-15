package org.tarjetamish.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class User {
    private Long id;
    private int rut;
    private String name;
    private String email;
    private int pin;
    private Long idAccount;
}
