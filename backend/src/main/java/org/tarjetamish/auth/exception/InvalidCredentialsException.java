package org.tarjetamish.auth.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class InvalidCredentialsException extends ApplicationException {
    public InvalidCredentialsException(String message) {
        super(message, org.springframework.http.HttpStatus.UNAUTHORIZED);
    }

}
