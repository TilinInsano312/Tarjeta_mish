package org.tarjetamish.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.tarjetamish.model.enums.CategoryBook;
import org.tarjetamish.model.enums.TypeTransaction;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class ExpenseNotebookDTO {
    private Long id;
    private String description;
    private CategoryBook categoryBook;
    private TypeTransaction transaction;
    private Long idUser;
    private String name;
}
