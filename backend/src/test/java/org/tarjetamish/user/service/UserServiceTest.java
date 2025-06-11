package org.tarjetamish.user.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.tarjetamish.user.dto.UserDTO;
import org.tarjetamish.user.service.UserService;

import static org.junit.jupiter.api.Assertions.*;
@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserServiceTest {

    @Autowired
    private UserService userService;

    @Test
    void testListUsers() {
        assertNotNull(userService.list(), "User list should not be null");
    }

    @Test
    void testFindById() {
        assertTrue(userService.findById(1L).isPresent(), "User with ID 1 should exist");
    }

    @Test
    void testFindByRut() {
        String rut = "123456789";
        assertTrue(userService.findByRut(rut).isPresent(), "User with RUT " + rut + " should exist");
    }

    @Test
    void testSaveUser() {
        int result = userService.save(new UserDTO(0L, "111111111", "Test", "User", "1234"));
        assertEquals(1, result, "User should be saved successfully");
    }

    @Test
    void testDeleteUser() {
        String rut = "111111111";
        assertEquals(1, userService.deleteUser(rut), "User should be deleted successfully");
    }
}
