package org.tarjetamish.expense.notebook.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.expense.notebook.dto.ExpenseNotebookDTO;
import org.tarjetamish.expense.notebook.service.ExpenseNotebookService;

import java.util.List;

@RestController
@RequestMapping("api/expensenotebook")
@AllArgsConstructor
public class ExpenseNotebookController {
    private final ExpenseNotebookService expenseNotebookService;

    @GetMapping
    public ResponseEntity<List<ExpenseNotebookDTO>> list() {
        return ResponseEntity.ok(expenseNotebookService.list());
    }

    @GetMapping("/category/{category}")
    public ResponseEntity<ExpenseNotebookDTO> getExpenseNotebookByCategory(@PathVariable String category) {
        return expenseNotebookService.findByCategory(category)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity createExpenseNotebook(@RequestBody ExpenseNotebookDTO expenseNotebookDTO) {
        return ResponseEntity.ok(expenseNotebookService.save(expenseNotebookDTO));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity deleteExpenseNotebook(@PathVariable Long id) {
        expenseNotebookService.deleteExpenseNotebook(id);
        return ResponseEntity.ok().build();
    }
}
