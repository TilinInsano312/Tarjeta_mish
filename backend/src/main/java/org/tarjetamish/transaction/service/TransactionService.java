package org.tarjetamish.transaction.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.exception.TransactionNotFoundException;
import org.tarjetamish.transaction.mapper.ITransactionConverter;
import org.tarjetamish.transaction.repository.TransactionRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final ITransactionConverter transactionConverter;

    public List<TransactionDTO> list() {
        return transactionRepository.findAll().stream()
                .map(transactionConverter::toTransactionDTO)
                .toList();
    }

    public Optional<TransactionDTO> findById(Long id) {
        return Optional.ofNullable(transactionRepository.findById(id).map(transactionConverter::toTransactionDTO).orElseThrow(TransactionNotFoundException::new));
    }

    public TransactionDTO save(TransactionDTO transactionDTO) {
        return transactionConverter.toTransactionDTO(
                transactionRepository.save(transactionConverter.toTransaction(transactionDTO))
        );
    }

    public void deleteTransaction(Long id) {
        transactionRepository.deleteById(id);
    }
}


