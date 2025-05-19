package org.tarjetamish.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class User {
    private Long id;
    private String rut;
    private String name;
    private String email;
    private String pin;
}
