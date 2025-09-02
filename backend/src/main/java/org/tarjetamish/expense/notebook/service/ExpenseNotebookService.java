package org.tarjetamish.expense.notebook.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.expense.notebook.dto.ExpenseNotebookDTO;
import org.tarjetamish.expense.notebook.exception.ExpenseNotebookNotFoundException;
import org.tarjetamish.expense.notebook.mapper.IExpenseNotebookConverter;
import org.tarjetamish.expense.notebook.repository.ExpenseNotebookRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ExpenseNotebookService {

    private final ExpenseNotebookRepository expenseNotebookRepository;
    private final IExpenseNotebookConverter expenseNotebookConverter;

    public List<ExpenseNotebookDTO> list() {
        return expenseNotebookRepository.findAll().stream()
                .map(expenseNotebookConverter::toExpenseNotebookDTO)
                .toList();
    }

    public Optional<ExpenseNotebookDTO> findByCategory(String category) {
        return Optional.ofNullable(expenseNotebookRepository.findByCategory(category).map(expenseNotebookConverter::toExpenseNotebookDTO).orElseThrow(ExpenseNotebookNotFoundException::new));
    }

    public ExpenseNotebookDTO save(ExpenseNotebookDTO expenseNotebook) {
        return expenseNotebookConverter.toExpenseNotebookDTO(
                expenseNotebookRepository.save(expenseNotebookConverter.toExpenseNotebook(expenseNotebook))
        );
    }

    public void deleteExpenseNotebook(Long id) {
        expenseNotebookRepository.deleteById(id);
    }


}
