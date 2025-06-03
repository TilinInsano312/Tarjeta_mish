package org.tarjetamish.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
public record UserRegisterDTO (
        @NotBlank(message = "Rut is mandatory")
        String rut,

        @NotBlank(message = "Name is mandatory")
        String name,

        @NotBlank(message = "Email is mandatory")
        String email,

        @NotBlank(message = "Pin is mandatory")
        @Size(min = 4, max = 4, message = "Pin must be exactly 4 digits")
        String pin
) {}
