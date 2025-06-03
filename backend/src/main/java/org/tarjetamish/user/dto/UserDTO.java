package org.tarjetamish.user.dto;
public record UserDTO(Long id,
                      String rut,
                      String name,
                      String email,
                      String pin) {
}
