package org.tarjetamish.expenseNotebook.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.tarjetamish.expenseNotebook.model.enums.CategoryBook;
import org.tarjetamish.transaction.model.enums.TypeTransaction;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor

public class ExpenseNotebook {
    private Long id;
    private String description;
    private CategoryBook categoryBook;
    private TypeTransaction transaction;
    private Long idUser;
    private String name;
}
