package org.tarjetamish.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.tarjetamish.model.User;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
@SpringBootTest
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    void findByRut() {
        String rut = "123456789";
        Optional<User> userOpt = userRepository.findByRut(rut);
        assertTrue(userOpt.isPresent(), "Usuario con rut debe existir");
        assertEquals(rut, userOpt.get().getRut());
    }
}