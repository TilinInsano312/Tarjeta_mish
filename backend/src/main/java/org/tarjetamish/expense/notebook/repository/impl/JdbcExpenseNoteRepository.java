package org.tarjetamish.expense.notebook.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.expense.notebook.model.ExpenseNotebook;
import org.tarjetamish.expense.notebook.repository.ExpenseNotebookRepository;
import org.tarjetamish.expense.notebook.mapper.impl.ExpenseNotebookRowMapper;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcExpenseNoteRepository implements ExpenseNotebookRepository {

    private final JdbcTemplate jdbc;
    private final ExpenseNotebookRowMapper expenseNotebookRowMapper;
    @Override
    public List<ExpenseNotebook> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.expense_notebook";
        return jdbc.query(sql, expenseNotebookRowMapper);
    }
    @Override
    public Optional<ExpenseNotebook> findByCategory(String category) {
        String sql = "SELECT * FROM tarjeta_mish.expense_notebook WHERE category = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, expenseNotebookRowMapper, category));
    }

    @Override
    public ExpenseNotebook save(ExpenseNotebook expenseNotebook) {
        String sql = "INSERT INTO tarjeta_mish.expensebook (description, idcategorybook, idmovement, iduser, name) VALUES (?, ?, ?, ?, ?)";
        return jdbc.queryForObject(sql, expenseNotebookRowMapper, expenseNotebook.getDescription(), expenseNotebook.getCategoryBook().name(), expenseNotebook.getTransaction().name(), expenseNotebook.getIdUser(), expenseNotebook.getName());
    }

    @Override
    public void deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.expense_notebook WHERE idexpensebook = ?";
        jdbc.update(sql, id);
    }
}
