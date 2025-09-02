package org.tarjetamish.auth.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.tarjetamish.auth.exception.InvalidCredentialsException;
import org.tarjetamish.auth.exception.UserNotFoundException;
import org.tarjetamish.auth.jwt.JwtProvider;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;


@ExtendWith(MockitoExtension.class)
class AuthServiceImplTest {
    @Mock
    UserRepository userRepository;
    @Mock
    JwtProvider jwtProvider;
    @InjectMocks
    AuthServiceImpl authService;

    @Test
    void login_success() {
        String rut = "123456789";
        String pin = "1234";
        User user = new User();
        user.setRut(rut);
        user.setPin(pin);

        when(userRepository.findByRut(rut)).thenReturn(Optional.of(user));
        when(jwtProvider.generateToken(user)).thenReturn("mockedToken");

        String token = authService.login(rut, pin);

        assertEquals("mockedToken", token);
        verify(jwtProvider).generateToken(user);

    }

    @Test
    void login_userNotFound() {
        when(userRepository.findByRut(anyString())).thenReturn(Optional.empty());
        assertThrows(UserNotFoundException.class, () -> authService.login("invalidRut", "1234"));
    }

    @Test
    void login_invalidCredentials() {
        String rut = "123456789";
        String pin = "1234";
        User user = new User();
        user.setRut(rut);
        user.setPin("4321");

        when(userRepository.findByRut(rut)).thenReturn(Optional.of(user));

        assertThrows(InvalidCredentialsException.class, () -> authService.login(rut, pin));
    }
}