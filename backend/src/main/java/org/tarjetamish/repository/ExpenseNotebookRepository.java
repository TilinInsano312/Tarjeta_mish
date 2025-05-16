package org.tarjetamish.repository;

import org.tarjetamish.model.ExpenseNotebook;

import java.util.List;
import java.util.Optional;

public interface ExpenseNotebookRepository {
    List<ExpenseNotebook> findAll();
    Optional<ExpenseNotebook> findByCategory(String category);
    ExpenseNotebook save(ExpenseNotebook expenseNotebook);
    void deleteById(Long id);
}
