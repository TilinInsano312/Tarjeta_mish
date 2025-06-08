package org.tarjetamish.auth.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class UserAlreadyExistException extends ApplicationException {
    public UserAlreadyExistException(String rut) {
        super("User with rut " + rut + " already exists.", org.springframework.http.HttpStatus.CONFLICT);
    }
}
