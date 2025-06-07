package org.tarjetamish.account.mapper;

import org.tarjetamish.account.dto.AccountDTO;
import org.tarjetamish.account.model.Account;


public interface IAccountConverter {
    AccountDTO toAccountDTO(Account card);
    Account toAccount(AccountDTO cardDTO);
}
