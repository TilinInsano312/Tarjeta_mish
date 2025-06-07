package org.tarjetamish.account.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.account.dto.AccountDTO;
import org.tarjetamish.account.mapper.IAccountConverter;
import org.tarjetamish.account.model.Account;

@Component
public class AccountConverter implements IAccountConverter {

    public Account toAccount(AccountDTO cardDTO) {
        return new Account(cardDTO.id(), cardDTO.accountNumber(), cardDTO.balance(), cardDTO.idCard(), cardDTO.idUser());
    }
    public AccountDTO toAccountDTO(Account account) {
        return new AccountDTO(account.getId(), account.getBalance(), account.getAccountNumber(), account.getIdCard(), account.getIdUser());
    }

}
