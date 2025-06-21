package org.tarjetamish.common.annotations;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;
import org.tarjetamish.common.annotations.validator.RutValidator;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = RutValidator.class)
@Target({ElementType.FIELD, ElementType.PARAMETER})
@Retention(RetentionPolicy.RUNTIME)
public @interface Rut {
String message() default "Invalid RUT format";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
