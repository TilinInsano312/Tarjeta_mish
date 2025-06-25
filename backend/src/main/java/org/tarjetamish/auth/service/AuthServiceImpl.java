package org.tarjetamish.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.java.Log;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.tarjetamish.account.model.Account;
import org.tarjetamish.account.repository.AccountRepository;
import org.tarjetamish.auth.dto.request.UserRegisterDTO;
import org.tarjetamish.auth.exception.InvalidCredentialsException;
import org.tarjetamish.auth.exception.UserAlreadyExistException;
import org.tarjetamish.auth.exception.UserNotFoundException;
import org.tarjetamish.card.model.Card;
import org.tarjetamish.card.repository.CardRepository;
import org.tarjetamish.common.utils.RegisterUtils;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;
import org.tarjetamish.auth.jwt.JwtProvider;

@RequiredArgsConstructor
@Log
@Service
public class AuthServiceImpl implements IAuthService {
    private final UserRepository userRepository;
    private final CardRepository cardRepository;
    private final AccountRepository accountRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;
    private final RegisterUtils registerUtils;

    @Override
    public String login(String rut, String pin) {
        User user = userRepository.findByRut(rut)
                .orElseThrow(() -> new UserNotFoundException(rut));
        if (passwordEncoder.matches(pin, user.getPin())) {
            return jwtProvider.generateToken(user);
        }
        throw new InvalidCredentialsException("Invalid credentials");
    }

    @Override
    public boolean validateSession(String token) {
        return false;
    }

    @Override
    public void register(UserRegisterDTO userRegisterDTO) {
        if (userRepository.existByRut(userRegisterDTO.rut())) {
            throw new UserAlreadyExistException(userRegisterDTO.rut());
        }
        User user = new User();
        String encodedPassword = passwordEncoder.encode(userRegisterDTO.pin());
        user.setRut(userRegisterDTO.rut());
        user.setName(userRegisterDTO.name());
        user.setEmail(userRegisterDTO.email());
        user.setPin(encodedPassword);
        userRepository.save(user);

        Card card = new Card();
        card.setCardHolderName(user.getName());
        card.setNumber(registerUtils.generateCardNumber());
        card.setCvv(registerUtils.generateCvv());
        card.setExpirationDate(registerUtils.generateExpirationDate());
        cardRepository.save(card);

        Account account = new Account();
        account.setBalance(0);
        account.setAccountNumber(registerUtils.generateAccountNumber());
        account.setIdUser(user.getId());
        account.setIdCard(card.getId());
        accountRepository.save(account);

    }
}
