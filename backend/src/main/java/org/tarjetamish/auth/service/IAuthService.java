package org.tarjetamish.auth.service;

import org.tarjetamish.account.dto.request.UserRegisterDTO;

public interface IAuthService {
    String login(String rut, int pin);

    boolean validateSession(String token);

    void register(UserRegisterDTO userRegisterDTO);
}
