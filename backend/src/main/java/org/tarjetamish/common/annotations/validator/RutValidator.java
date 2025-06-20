package org.tarjetamish.common.annotations.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.tarjetamish.common.annotations.Rut;

public class RutValidator implements ConstraintValidator<Rut, String> {

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        if (value == null || value.isBlank()) return false;

        String rut = value.replaceAll("[^0-9Kk]", "").toUpperCase();

        if (!rut.matches("\\d{7,8}[0-9K]")) return false;


        String body = rut.substring(0, rut.length() - 1);
        char checkDigit = rut.charAt(rut.length() - 1);

        int sum = 0;
        int factor = 2;

        for (int i = body.length() - 1; i >= 0; i--) {
            sum += Character.getNumericValue(body.charAt(i)) * factor;
            factor = factor == 7 ? 2 : factor + 1;
        }

        int remainder = 11 - (sum % 11);
        char expectedCheckDigit;

        switch (remainder) {
            case 11 -> expectedCheckDigit = '0';
            case 10 -> expectedCheckDigit = 'K';
            default -> expectedCheckDigit = (char) ('0' + remainder);
        }

        return checkDigit == expectedCheckDigit;
    }
}
