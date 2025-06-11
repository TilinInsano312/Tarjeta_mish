package org.tarjetamish.auth.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.java.Log;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.tarjetamish.auth.dto.request.UserRegisterDTO;
import org.tarjetamish.auth.exception.InvalidCredentialsException;
import org.tarjetamish.auth.exception.UserAlreadyExistException;
import org.tarjetamish.auth.exception.UserNotFoundException;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;
import org.tarjetamish.auth.jwt.JwtProvider;

@RequiredArgsConstructor
@Log
@Service
public class AuthServiceImpl implements IAuthService {
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtProvider jwtProvider;

    @Override
    public String login(String rut, int pin) {
        User user = userRepository.findByRut(rut)
                .orElseThrow(() -> new UserNotFoundException(rut));
        if (String.valueOf(pin).equals(String.valueOf(user.getPin()))) {
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
        String encodedPassword = passwordEncoder.encode(String.valueOf(userRegisterDTO.pin()));
        user.setRut(userRegisterDTO.rut());
        user.setName(userRegisterDTO.name());
        user.setEmail(userRegisterDTO.email());
        user.setPin(encodedPassword);
        userRepository.save(user);
    }
}
