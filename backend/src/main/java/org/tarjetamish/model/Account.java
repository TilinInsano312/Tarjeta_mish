package org.tarjetamish.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Account {
    private int balance;
    private int accountNumber;
    private Card card;
    private List<Transaction> transactions;
    private User user;
}
