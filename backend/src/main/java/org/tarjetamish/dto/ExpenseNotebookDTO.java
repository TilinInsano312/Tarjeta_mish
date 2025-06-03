package org.tarjetamish.dto;

import org.tarjetamish.model.enums.CategoryBook;
import org.tarjetamish.model.enums.TypeTransaction;

public record ExpenseNotebookDTO(Long id,
                                 String description,
                                 CategoryBook categoryBook,
                                 TypeTransaction transaction,
                                 Long idUser,
                                 String name) {

}
