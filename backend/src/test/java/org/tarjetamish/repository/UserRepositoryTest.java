package org.tarjetamish.repository;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;

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

    @Test
    void addUser(){
        String rut = "111111111";
        User user = new User(0L, rut, "Test", "User", "1234");
        User savedUser = userRepository.save(user);
        assertNotNull(savedUser, "Usuario debe ser guardado correctamente");
    }
    @Test
    void deleteUser() {
        String rut = "111111111";
        userRepository.deleteByRut(rut);
        Optional<User> userOpt = userRepository.findByRut(rut);
        assertFalse(userOpt.isPresent(), "Usuario con rut debe haber sido eliminado");
    }
}