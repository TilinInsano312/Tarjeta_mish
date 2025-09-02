package org.tarjetamish.common.utils;

import org.springframework.stereotype.Component;

import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@Component
public class RegisterUtils {
    private final SecureRandom random = new SecureRandom();

    public String generateCardNumber() {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 4; i++) {
            int block = random.nextInt(10_000);
            sb.append(String.format("%04d", block));
        }
        return sb.toString();
    }

    public Date generateExpirationDate() {
        LocalDate expiry = LocalDate.now().plusYears(5);
        return Date.from(expiry.atStartOfDay(ZoneId.systemDefault()).toInstant());
    }

    public String generateAccountNumber() {
        // Generar un número de cuenta de 16 dígitos como String
        StringBuilder sb = new StringBuilder();
        // Primer dígito no puede ser 0
        sb.append(random.nextInt(9) + 1);
        // Los siguientes 15 dígitos pueden ser cualquier número
        for (int i = 0; i < 15; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }

    public String generateCvv() {
        return String.format("%03d", random.nextInt(1000));
    }
}
