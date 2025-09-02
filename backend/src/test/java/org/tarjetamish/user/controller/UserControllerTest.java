package org.tarjetamish.user.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.tarjetamish.auth.jwt.JwtProvider;
import org.tarjetamish.user.model.User;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private String token;
    @Autowired
    private JwtProvider jwtProvider;
    @BeforeEach
    void setUp() {
        User user = new User(0L,"123456789", "hola","hola", "1234");
        token = jwtProvider.generateToken(user);
    }


    @Test
    void testShowAllUsers() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/user").header("Authorization", "Bearer " + token).contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers
                .content()
                .contentType("application/json"));
    }

    @Test
    void testShowUserById() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/user/1").header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers
                .content()
                .contentType("application/json"));
    }

    @Test
    void testShowUserByRut() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/user/rut/123456789").header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(status().isOk());
    }

    @Test
    void testCreateUser() throws Exception{
        mockMvc.perform(MockMvcRequestBuilders.post("/api/user").header("Authorization", "Bearer " + token)
                .contentType("application/json")
                .content("{\"rut\": \"111111111\", \"name\": \"test\", \"email\": \"test@example.com\", \"pin\": \"1234\"}"))
                .andExpect(status().isCreated());

    }
    @Test
    void testDeleteUser() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/user/111111111")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(status().isNoContent());
    }
}
