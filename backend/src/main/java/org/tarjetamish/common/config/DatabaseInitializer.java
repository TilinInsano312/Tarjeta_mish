package org.tarjetamish.common.config;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.core.JdbcTemplate;
import org.tarjetamish.account.model.enums.Bank;
import org.tarjetamish.account.model.enums.TypeAccount;

@Configuration
@RequiredArgsConstructor
@Slf4j
public class DatabaseInitializer {

    private final JdbcTemplate jdbcTemplate;

    @Bean
    public ApplicationRunner initializeReferenceData() {
        return args -> {
            log.info("Inicializando datos de referencia...");
            initializeTypeAccounts();
            initializeBanks();
            log.info("Datos de referencia inicializados correctamente");
        };
    }

    private void initializeTypeAccounts() {
        try {
            // Verificar si ya existen datos
            Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM tarjeta_mish.typeaccount", Integer.class);

            if (count != null && count == 0) {
                log.info("Insertando tipos de cuenta...");

                // Usar MERGE para compatibilidad con H2 y PostgreSQL
                try {
                    jdbcTemplate.update("INSERT INTO tarjeta_mish.typeaccount (idtypeaccount, type) VALUES (?, ?)", 1, TypeAccount.CUENTA_CORRIENTE.name());
                    jdbcTemplate.update("INSERT INTO tarjeta_mish.typeaccount (idtypeaccount, type) VALUES (?, ?)", 2, TypeAccount.CUENTA_VISTA.name());
                    jdbcTemplate.update("INSERT INTO tarjeta_mish.typeaccount (idtypeaccount, type) VALUES (?, ?)", 3, TypeAccount.CUENTA_DE_AHORRO.name());
                    jdbcTemplate.update("INSERT INTO tarjeta_mish.typeaccount (idtypeaccount, type) VALUES (?, ?)", 4, TypeAccount.CUENTA_RUT.name());
                } catch (Exception insertException) {
                    // Si falla el insert, probablemente los datos ya existen
                    log.debug("Los tipos de cuenta ya existen: {}", insertException.getMessage());
                }

                log.info("Tipos de cuenta inicializados correctamente");
            }
        } catch (Exception e) {
            log.warn("Error al inicializar tipos de cuenta: {}", e.getMessage());
        }
    }

    private void initializeBanks() {
        try {
            // Verificar si ya existen datos
            Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM tarjeta_mish.bank", Integer.class);

            if (count != null && count == 0) {
                log.info("Insertando bancos...");

                Bank[] banks = Bank.values();
                for (int i = 0; i < banks.length; i++) {
                    try {
                        jdbcTemplate.update("INSERT INTO tarjeta_mish.bank (idbank, bank) VALUES (?, ?)", i + 1, banks[i].name());
                    } catch (Exception insertException) {
                        // Si falla el insert, probablemente los datos ya existen
                        log.debug("El banco {} ya existe: {}", banks[i].name(), insertException.getMessage());
                    }
                }

                log.info("Bancos inicializados correctamente");
            }
        } catch (Exception e) {
            log.warn("Error al inicializar bancos: {}", e.getMessage());
        }
    }
}
