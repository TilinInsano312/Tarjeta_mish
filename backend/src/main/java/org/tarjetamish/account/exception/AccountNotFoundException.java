package org.tarjetamish.account.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class AccountNotFoundException extends ApplicationException {

    public AccountNotFoundException() {
        super("Account not found", org.springframework.http.HttpStatus.NOT_FOUND);
    }
}
