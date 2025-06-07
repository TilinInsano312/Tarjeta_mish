package org.tarjetamish.expenseNotebook.dto;

import org.tarjetamish.expenseNotebook.model.enums.CategoryBook;
import org.tarjetamish.transaction.model.enums.TypeTransaction;

public record ExpenseNotebookDTO(Long id,
                                 String description,
                                 CategoryBook categoryBook,
                                 TypeTransaction transaction,
                                 Long idUser,
                                 String name) {

}
