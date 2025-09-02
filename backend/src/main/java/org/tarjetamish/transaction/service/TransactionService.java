package org.tarjetamish.transaction.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.tarjetamish.account.service.AccountService;
import org.tarjetamish.account.dto.AccountDTO;
import org.tarjetamish.transaction.dto.TransactionDTO;
import org.tarjetamish.transaction.exception.TransactionNotFoundException;
import org.tarjetamish.transaction.exception.TransferException;
import org.tarjetamish.transaction.mapper.ITransactionConverter;
import org.tarjetamish.transaction.repository.TransactionRepository;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepository transactionRepository;
    private final ITransactionConverter transactionConverter;
    private final AccountService accountService;

    public List<TransactionDTO> list() {
        return transactionRepository.findAll().stream()
                .map(transactionConverter::toTransactionDTO)
                .toList();
    }

    public Optional<TransactionDTO> findById(Long id) {
        return Optional.ofNullable(transactionRepository.findById(id).map(transactionConverter::toTransactionDTO).orElseThrow(TransactionNotFoundException::new));
    }

    public int save(TransactionDTO transactionDTO) {
        return transactionRepository.save(transactionConverter.toTransaction(transactionDTO));
    }

    /**
     * Procesa una transferencia descontando dinero de la cuenta origen
     * y añadiéndolo a la cuenta destino.
     */
    @Transactional
    public int processTransferWithBalanceUpdate(TransactionDTO transactionDTO) {
        // Validaciones básicas
        if (transactionDTO.amount() <= 0) {
            throw new TransferException("El monto debe ser mayor a cero");
        }

        if (transactionDTO.accountOrigin() == null || transactionDTO.accountOrigin().trim().isEmpty()) {
            throw new TransferException("La cuenta origen es requerida");
        }

        if (transactionDTO.accountDestination() == null || transactionDTO.accountDestination().trim().isEmpty()) {
            throw new TransferException("La cuenta destino es requerida");
        }

        // Validar que las cuentas existen
        Optional<AccountDTO> originAccount;
        Optional<AccountDTO> destinationAccount;

        originAccount = accountService.findByAccountNumber(transactionDTO.accountOrigin());
        destinationAccount = accountService.findByAccountNumber(transactionDTO.accountDestination());

        if (originAccount.isEmpty()) {
            throw new TransferException("Cuenta origen no encontrada: " + transactionDTO.accountOrigin());
        }

        if (destinationAccount.isEmpty()) {
            throw new TransferException("Cuenta destino no encontrada: " + transactionDTO.accountDestination());
        }

        // Verificar que no sea la misma cuenta
        if (originAccount.get().id().equals(destinationAccount.get().id())) {
            throw new TransferException("No se puede transferir a la misma cuenta");
        }

        try {
            // 1. Descontar dinero de la cuenta origen
            accountService.deductBalance(originAccount.get().id(), transactionDTO.amount());

            // 2. Añadir dinero a la cuenta destino
            accountService.addBalance(destinationAccount.get().id(), transactionDTO.amount());

            // 3. Registrar la transacción
            TransactionDTO transferTransaction = new TransactionDTO(
                null, // ID será generado automáticamente
                transactionDTO.amount(),
                transactionDTO.name() != null ? transactionDTO.name() : "Usuario",
                new Date(),
                transactionDTO.description() != null ? transactionDTO.description() : "Transferencia entre cuentas",
                transactionDTO.rutDestination(),
                transactionDTO.accountDestination(),
                transactionDTO.rutOrigin(),
                transactionDTO.accountOrigin(),
                1, // TRANSFERENCIA = ID 1
                transactionDTO.bank(),
                originAccount.get().id()
            );

            return transactionRepository.save(transactionConverter.toTransaction(transferTransaction));

        } catch (RuntimeException e) {
            // Si hay error en el balance, lanzar excepción específica
            throw new TransferException("Error al procesar la transferencia: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new TransferException("Error interno al procesar la transferencia: " + e.getMessage(), e);
        }
    }

    /**
     * Procesa una transferencia sin descontar dinero de la cuenta origen.
     * Solo registra la transacción en el sistema.
     */
    public int processTransferWithoutDeduction(TransactionDTO transactionDTO) {
        // Validaciones básicas
        if (transactionDTO.amount() <= 0) {
            throw new TransferException("El monto debe ser mayor a cero");
        }

        if (transactionDTO.accountOrigin() == null || transactionDTO.accountOrigin().trim().isEmpty()) {
            throw new TransferException("La cuenta origen es requerida");
        }

        if (transactionDTO.accountDestination() == null || transactionDTO.accountDestination().trim().isEmpty()) {
            throw new TransferException("La cuenta destino es requerida");
        }

        // Validar que la cuenta origen existe
        Optional<AccountDTO> originAccount;

        originAccount = accountService.findByAccountNumber(transactionDTO.accountOrigin());

        if (originAccount.isEmpty()) {
            throw new TransferException("Cuenta origen no encontrada: " + transactionDTO.accountOrigin());
        }

        // Configurar la transacción como transferencia
        TransactionDTO transferTransaction = new TransactionDTO(
            null, // ID será generado automáticamente
            transactionDTO.amount(),
            transactionDTO.name() != null ? transactionDTO.name() : "Usuario",
            new Date(),
            transactionDTO.description() != null ? transactionDTO.description() : "Transferencia sin descuento de balance",
            transactionDTO.rutDestination(),
            transactionDTO.accountDestination(),
            transactionDTO.rutOrigin(),
            transactionDTO.accountOrigin(),
            1, // TRANSFERENCIA = ID 1
            transactionDTO.bank(),
            originAccount.get().id()
        );

        try {
            // Solo registrar la transacción sin afectar el balance
            return transactionRepository.save(transactionConverter.toTransaction(transferTransaction));
        } catch (Exception e) {
            throw new TransferException("Error al procesar la transferencia: " + e.getMessage(), e);
        }
    }

    public int deleteTransaction(Long id) {
       return transactionRepository.deleteById(id);
    }
}
