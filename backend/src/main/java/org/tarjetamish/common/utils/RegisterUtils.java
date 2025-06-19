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

    public int generateAccountNumber() {
        return 100_000_000 + random.nextInt(900_000_000);
    }

    public String generateCvv() {
        return String.format("%03d", random.nextInt(1000));
    }
}
