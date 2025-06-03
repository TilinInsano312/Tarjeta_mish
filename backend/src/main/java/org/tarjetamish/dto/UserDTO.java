package org.tarjetamish.dto;
public record UserDTO(Long id,
                      String rut,
                      String name,
                      String email,
                      String pin) {
}
