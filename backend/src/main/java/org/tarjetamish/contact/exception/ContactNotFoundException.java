package org.tarjetamish.contact.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class ContactNotFoundException extends ApplicationException {
    public ContactNotFoundException() {
        super("Contact not found", org.springframework.http.HttpStatus.NOT_FOUND);
    }
}
