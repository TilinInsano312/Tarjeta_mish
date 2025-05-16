package org.tarjetamish.rowMapper;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.tarjetamish.model.ExpenseNotebook;
import org.tarjetamish.model.enums.CategoryBook;
import org.tarjetamish.model.enums.TypeTransaction;

import java.sql.ResultSet;
import java.sql.SQLException;
@Component
public class ExpenseNotebookRowMapper implements RowMapper<ExpenseNotebook>{
    @Override
    public ExpenseNotebook mapRow(ResultSet rs, int rowNum) throws SQLException {
        ExpenseNotebook expenseNotebook = new ExpenseNotebook();
        expenseNotebook.setId(rs.getLong("idexpensebook"));
        expenseNotebook.setDescription(rs.getString("description"));
        String category = rs.getString("idcategory");
        expenseNotebook.setCategoryBook(CategoryBook.valueOf(category));
        String typeTransaction = rs.getString("typetransaction");
        expenseNotebook.setTransaction(TypeTransaction.valueOf(typeTransaction));
        expenseNotebook.setIdUser(rs.getLong("iduser"));
        expenseNotebook.setName(rs.getString("name"));
        return expenseNotebook;
    }
}
