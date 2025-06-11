package org.tarjetamish.user.repository;

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
        int ok = userRepository.save(user);
        assertEquals(1, ok, "Usuario debe ser agregado correctamente");
    }
    @Test
    void deleteUser() {
        String rut = "111111111";
        assertEquals(1, userRepository.deleteByRut(rut), "Usuario debe ser eliminado correctamente");
    }
}