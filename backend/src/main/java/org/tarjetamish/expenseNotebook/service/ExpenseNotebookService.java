package org.tarjetamish.expenseNotebook.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.expenseNotebook.dto.ExpenseNotebookDTO;
import org.tarjetamish.expenseNotebook.mapper.IExpenseNotebookConverter;
import org.tarjetamish.expenseNotebook.repository.ExpenseNotebookRepository;

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
        return Optional.ofNullable(expenseNotebookRepository.findByCategory(category).map(expenseNotebookConverter::toExpenseNotebookDTO).orElse(null));
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
