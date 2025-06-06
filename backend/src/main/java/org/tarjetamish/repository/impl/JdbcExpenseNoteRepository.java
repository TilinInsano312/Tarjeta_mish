package org.tarjetamish.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.model.ExpenseNotebook;
import org.tarjetamish.repository.ExpenseNotebookRepository;
import org.tarjetamish.rowMapper.ExpenseNotebookRowMapper;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcExpenseNoteRepository implements ExpenseNotebookRepository {

    private final JdbcTemplate jdbc;
    @Override
    public List<ExpenseNotebook> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.expense_notebook";
        return jdbc.query(sql, new ExpenseNotebookRowMapper());
    }
    @Override
    public Optional<ExpenseNotebook> findByCategory(String category) {
        String sql = "SELECT * FROM tarjeta_mish.expense_notebook WHERE category = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, new ExpenseNotebookRowMapper(), category));
    }

    @Override
    public ExpenseNotebook save(ExpenseNotebook expenseNotebook) {
        String sql = "INSERT INTO tarjeta_mish.expensebook (description, idcategorybook, idmovement, iduser, name) VALUES (?, ?, ?, ?, ?)";
        return jdbc.queryForObject(sql, new ExpenseNotebookRowMapper(), expenseNotebook.getDescription(), expenseNotebook.getCategoryBook().name(), expenseNotebook.getTransaction().name(), expenseNotebook.getIdUser(), expenseNotebook.getName());
    }

    @Override
    public void deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.expense_notebook WHERE idexpensebook = ?";
        jdbc.update(sql, id);
    }
}
