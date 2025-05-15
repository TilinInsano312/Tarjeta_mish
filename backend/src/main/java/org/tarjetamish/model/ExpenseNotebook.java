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

public class ExpenseNotebook {
    private Long id;
    private String description;
    private Long idCategoryBook;
    private Long idTransaction;
    private Long idUser;
    private String name;
}
