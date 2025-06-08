package org.tarjetamish.expense.notebook.repository;

import org.tarjetamish.expense.notebook.model.ExpenseNotebook;

import java.util.List;
import java.util.Optional;

public interface ExpenseNotebookRepository {
    List<ExpenseNotebook> findAll();

    Optional<ExpenseNotebook> findByCategory(String category);

    ExpenseNotebook save(ExpenseNotebook expenseNotebook);

    void deleteById(Long id);
}
