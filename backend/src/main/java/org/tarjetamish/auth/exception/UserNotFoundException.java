package org.tarjetamish.auth.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class UserNotFoundException extends ApplicationException {

    public UserNotFoundException(String rut) {
        super( "User with rut " + rut + " not found.", org.springframework.http.HttpStatus.NOT_FOUND);
    }
}
