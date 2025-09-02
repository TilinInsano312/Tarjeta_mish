package org.tarjetamish.transaction.repository.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import org.tarjetamish.transaction.model.Transaction;
import org.tarjetamish.transaction.repository.TransactionRepository;
import org.tarjetamish.transaction.mapper.impl.TransactionRowMapper;
import org.tarjetamish.common.utils.EnumMappingUtil;

import java.util.List;
import java.util.Optional;

@Repository
@RequiredArgsConstructor
public class JdbcTransactionRepository implements TransactionRepository {

    private final JdbcTemplate jdbc;
    private final TransactionRowMapper transactionRowMapper;
    @Override
    public List<Transaction> findAll() {
        String sql = "SELECT * FROM tarjeta_mish.movement";
        return jdbc.query(sql, transactionRowMapper);
    }

    @Override
    public Optional<Transaction> findById(Long id) {
        String sql = "SELECT * FROM tarjeta_mish.movement WHERE idmovement = ?";
        return Optional.ofNullable(jdbc.queryForObject(sql, transactionRowMapper, id));
    }

    @Override
    public int save(Transaction transaction) {
        String sql = "INSERT INTO tarjeta_mish.movement (amount ,name , date, description, rutdestination, accountdestination, rutorigin, accountorigin, idtypemovement, idbank, idaccount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        // Validar que typeTransaction no sea null
        if (transaction.getTypeTransaction() == null) {
            throw new IllegalArgumentException("El tipo de transacción no puede ser null");
        }

        // Mapear TypeTransaction a ID de BD (TRANSFERENCIA = 1, TARJETA_DEBITO = 2)
        int typeTransactionId = transaction.getTypeTransaction().ordinal() + 1;

        // Mapear Bank usando EnumMappingUtil
        int bankId = EnumMappingUtil.getBankId(transaction.getBank());

        return jdbc.update(sql, transaction.getAmount(), transaction.getName(), transaction.getDate(),
                transaction.getDescription(), transaction.getRutDestination(), transaction.getAccountDestination(),
                transaction.getRutOrigin(), transaction.getAccountOrigin(), typeTransactionId, bankId,
                transaction.getIdAccount());
    }

    @Override
    public int deleteById(Long id) {
        String sql = "DELETE FROM tarjeta_mish.movement WHERE idmovement = ?";
        return jdbc.update(sql, id);
    }
}
