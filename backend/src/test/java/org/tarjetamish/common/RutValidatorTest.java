package org.tarjetamish.common;

import static org.junit.jupiter.api.Assertions.*;

import org.junit.jupiter.api.Test;
import org.tarjetamish.common.annotations.validator.RutValidator;

class RutValidatorTest {

    private final RutValidator validator = new RutValidator();

    @Test
    void testValidRut() {
        assertTrue(validator.isValid("216801830", null));
        assertTrue(validator.isValid("21.680.183-0", null));
        assertTrue(validator.isValid("21680183-0", null));
    }

    @Test
    void testInvalidRut() {
        assertFalse(validator.isValid("1234567", null));
        assertFalse(validator.isValid("1234567890", null));
        assertFalse(validator.isValid("12345678A", null));
        assertFalse(validator.isValid("11111111K", null));
    }

    @Test
    void testEmptyRut() {
        assertFalse(validator.isValid("", null));
        assertFalse(validator.isValid(null, null));
    }
}

