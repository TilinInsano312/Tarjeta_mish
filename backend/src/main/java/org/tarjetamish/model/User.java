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
    private int rut;
    private String name;
    private String correo;
    private int pin;
    private Account account;
    private List<Contact> contacts;
}
