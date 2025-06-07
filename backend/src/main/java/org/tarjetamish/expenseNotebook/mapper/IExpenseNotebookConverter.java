package org.tarjetamish.expenseNotebook.mapper;

import org.tarjetamish.expenseNotebook.dto.ExpenseNotebookDTO;
import org.tarjetamish.expenseNotebook.model.ExpenseNotebook;

public interface IExpenseNotebookConverter {
    ExpenseNotebookDTO toExpenseNotebookDTO(ExpenseNotebook expenseNotebook);
    ExpenseNotebook toExpenseNotebook(ExpenseNotebookDTO expenseNotebookDTO);
}
