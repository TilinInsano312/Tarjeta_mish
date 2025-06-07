package org.tarjetamish.expenseNotebook.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.expenseNotebook.dto.ExpenseNotebookDTO;
import org.tarjetamish.expenseNotebook.mapper.IExpenseNotebookConverter;
import org.tarjetamish.expenseNotebook.model.ExpenseNotebook;

@Component
public class ExpenseNotebookConverter implements IExpenseNotebookConverter {
    public ExpenseNotebookDTO toExpenseNotebookDTO(ExpenseNotebook expenseNotebook) {
        return new ExpenseNotebookDTO(expenseNotebook.getId(), expenseNotebook.getDescription(), expenseNotebook.getCategoryBook(), expenseNotebook.getTransaction(), expenseNotebook.getIdUser(), expenseNotebook.getName());
    }
    public ExpenseNotebook toExpenseNotebook(ExpenseNotebookDTO expenseNotebookDTO) {
        return new ExpenseNotebook(expenseNotebookDTO.id(), expenseNotebookDTO.description(), expenseNotebookDTO.categoryBook(), expenseNotebookDTO.transaction(), expenseNotebookDTO.idUser(), expenseNotebookDTO.name());
    }
}
