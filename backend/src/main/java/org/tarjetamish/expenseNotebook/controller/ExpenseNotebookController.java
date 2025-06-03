package org.tarjetamish.expenseNotebook.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.expenseNotebook.dto.ExpenseNotebookDTO;
import org.tarjetamish.expenseNotebook.service.ExpenseNotebookService;

import java.util.List;

@RestController
@RequestMapping("/expensenotebook")
@AllArgsConstructor
public class ExpenseNotebookController {
    private final ExpenseNotebookService expenseNotebookService;

    @GetMapping
    public List<ExpenseNotebookDTO> list() {
        return expenseNotebookService.list();
    }

    @GetMapping("/category/{category}")
    public ExpenseNotebookDTO getExpenseNotebookByCategory(@PathVariable String category) {
        return expenseNotebookService.findByCategory(category).orElse(null);
    }

    @PostMapping
    public void createExpenseNotebook(@RequestBody ExpenseNotebookDTO expenseNotebookDTO) {
        expenseNotebookService.save(expenseNotebookDTO);
    }

    @DeleteMapping("/{id}")
    public void deleteExpenseNotebook(@PathVariable Long id) {
        expenseNotebookService.deleteExpenseNotebook(id);
    }
}
