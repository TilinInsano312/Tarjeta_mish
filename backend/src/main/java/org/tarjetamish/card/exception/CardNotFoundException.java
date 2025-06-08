package org.tarjetamish.card.exception;

import org.tarjetamish.common.exception.ApplicationException;

public class CardNotFoundException extends ApplicationException {
    public CardNotFoundException() {
        super("Card not found", org.springframework.http.HttpStatus.NOT_FOUND);
    }

}
