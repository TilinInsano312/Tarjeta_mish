package org.tarjetamish.expense.notebook.mapper;

import org.tarjetamish.expense.notebook.dto.ExpenseNotebookDTO;
import org.tarjetamish.expense.notebook.model.ExpenseNotebook;

public interface IExpenseNotebookConverter {
    ExpenseNotebookDTO toExpenseNotebookDTO(ExpenseNotebook expenseNotebook);
    ExpenseNotebook toExpenseNotebook(ExpenseNotebookDTO expenseNotebookDTO);
}
