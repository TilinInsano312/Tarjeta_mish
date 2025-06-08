package org.tarjetamish.transaction.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class TransactionNotFoundException extends ApplicationException {
    public TransactionNotFoundException() {
        super("Transaction not found", org.springframework.http.HttpStatus.NOT_FOUND);
    }
}
