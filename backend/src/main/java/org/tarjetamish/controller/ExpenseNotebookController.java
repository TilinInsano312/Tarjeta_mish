package org.tarjetamish.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.dto.ExpenseNotebookDTO;
import org.tarjetamish.service.ExpenseNotebookService;

import java.util.List;

@RestController
@RequestMapping("/expensenotebook")
@AllArgsConstructor
public class ExpenseNotebookController {
    ExpenseNotebookService expenseNotebookService;

    @GetMapping
    public List<ExpenseNotebookDTO> list() {
        return expenseNotebookService.list();
    }

    @GetMapping("/category/{category}")
    public ExpenseNotebookDTO getExpenseNotebookByCategory(String category) {
        return expenseNotebookService.findByCategory(category).orElse(null);
    }

    @PostMapping
    public void createExpenseNotebook(ExpenseNotebookDTO expenseNotebookDTO) {
        expenseNotebookService.save(expenseNotebookDTO);
    }

    @DeleteMapping
    public void deleteExpenseNotebook(Long id) {
        expenseNotebookService.deleteExpenseNotebook(id);
    }
}
