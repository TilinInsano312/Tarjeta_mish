package org.tarjetamish.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.dto.ExpenseNotebookDTO;
import org.tarjetamish.model.ExpenseNotebook;
import org.tarjetamish.repository.ExpenseNotebookRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ExpenseNotebookService {

    public final ExpenseNotebookRepository expenseNotebookRepository;

    public List<ExpenseNotebookDTO> list() {
        return expenseNotebookRepository.findAll().stream()
                .map(this::convertToDTO)
                .toList();
    }

    public Optional<ExpenseNotebookDTO> findByCategory(String category) {
        return Optional.ofNullable(expenseNotebookRepository.findByCategory(category).map(this::convertToDTO).orElse(null));
    }

    public ExpenseNotebookDTO save(ExpenseNotebookDTO expenseNotebook) {
        ExpenseNotebook expenseNotebookEntity = new ExpenseNotebook(expenseNotebook.getId(), expenseNotebook.getDescription(), expenseNotebook.getCategoryBook(), expenseNotebook.getTransaction(), expenseNotebook.getIdUser(), expenseNotebook.getName());
        return convertToDTO(expenseNotebookRepository.save(expenseNotebookEntity));
    }

    public void deleteExpenseNotebook(Long id) {
        expenseNotebookRepository.deleteById(id);
    }

    private ExpenseNotebookDTO convertToDTO(ExpenseNotebook expenseNotebook) {
        return new ExpenseNotebookDTO(expenseNotebook.getId(), expenseNotebook.getDescription(), expenseNotebook.getCategoryBook(), expenseNotebook.getTransaction(), expenseNotebook.getIdUser(), expenseNotebook.getName());
    }
}
