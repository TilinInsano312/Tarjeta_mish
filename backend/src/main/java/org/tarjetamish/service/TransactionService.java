package org.tarjetamish.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.dto.TransactionDTO;
import org.tarjetamish.model.Transaction;
import org.tarjetamish.repository.TransactionRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository transactionRepository;

    public List<TransactionDTO> list() {
        return transactionRepository.findAll().stream()
                .map(this::convertToDTO)
                .toList();
    }

    public Optional<TransactionDTO> findById(Long id) {
        return Optional.ofNullable(transactionRepository.findById(id).map(this::convertToDTO).orElse(null));
    }

    public TransactionDTO save(TransactionDTO transactionDTO) {
        Transaction transactionEntity = new Transaction(transactionDTO.id(), transactionDTO.amount(), transactionDTO.name(), transactionDTO.date(), transactionDTO.description(), transactionDTO.rutDestination(), transactionDTO.accountDestination(), transactionDTO.rutOrigin(), transactionDTO.accountOrigin(), transactionDTO.typeTransaction(), transactionDTO.bank(), transactionDTO.idAccount());
        return convertToDTO(transactionRepository.save(transactionEntity));
    }

    public void deleteTransaction(Long id) {
        transactionRepository.deleteById(id);
    }

    private TransactionDTO convertToDTO(Transaction transaction) {
        return new TransactionDTO(transaction.getId(), transaction.getAmount(), transaction.getName(), transaction.getDate(), transaction.getDescription(), transaction.getRutDestination(), transaction.getAccountDestination(), transaction.getRutOrigin(), transaction.getAccountOrigin(), transaction.getTypeTransaction(), transaction.getBank(), transaction.getIdAccount());
    }
}
