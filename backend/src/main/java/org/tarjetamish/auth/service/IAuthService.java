package org.tarjetamish.auth.service;

import org.tarjetamish.auth.dto.request.UserRegisterDTO;

public interface IAuthService {
    String login(String rut, String pin);

    boolean validateSession(String token);

    void register(UserRegisterDTO userRegisterDTO);
}
