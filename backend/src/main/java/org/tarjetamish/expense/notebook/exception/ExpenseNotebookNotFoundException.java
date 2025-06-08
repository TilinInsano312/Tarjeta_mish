package org.tarjetamish.expense.notebook.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class ExpenseNotebookNotFoundException extends ApplicationException {
    public ExpenseNotebookNotFoundException() {
        super("Expense notebook not found", org.springframework.http.HttpStatus.NOT_FOUND);
    }
}
