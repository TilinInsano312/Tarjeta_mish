package org.tarjetamish.auth.exception;

import org.springframework.http.HttpStatus;
import org.tarjetamish.common.exception.ApplicationException;

public class AuthException extends ApplicationException {

    public AuthException(String message) {
        super(message, HttpStatus.UNAUTHORIZED);
    }
    public AuthException() {
        super("Authentication failed", HttpStatus.UNAUTHORIZED);
    }
}
