package org.tarjetamish.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UserRegisterDTO {

    @NotBlank(message = "Rut cannot be empty.")
    private String rut;
    @NotBlank(message = "Name cannot be empty.")
    @Size(max = 20, message = "Name must be less than 20 characters.")
    private String name;
    @NotBlank(message = "Email cannot be empty.")
    @Size(max = 80, message = "Email must be less than 80 characters.")
    private String email;
    @NotBlank(message = "Pin cannot be empty.")
    @Size(max = 4, message = "Pin must be less than 4 characters.")
    private int pin;
}
