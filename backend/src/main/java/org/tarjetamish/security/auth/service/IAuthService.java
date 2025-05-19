package org.tarjetamish.security.auth.service;

import org.tarjetamish.dto.request.UserRegisterDTO;

public interface IAuthService {
    String login(String rut, int pin);

    boolean validateSession(String token);

    void register(UserRegisterDTO userRegisterDTO);
}
