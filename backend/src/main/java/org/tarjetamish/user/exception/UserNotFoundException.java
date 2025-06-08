package org.tarjetamish.user.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class UserNotFoundException extends ApplicationException {
    public UserNotFoundException() {
        super("User not found", org.springframework.http.HttpStatus.NOT_FOUND);
    }
}
