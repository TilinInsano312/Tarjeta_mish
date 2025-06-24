package org.tarjetamish.contact.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.tarjetamish.auth.jwt.JwtProvider;
import org.tarjetamish.user.model.User;

@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class ContactControllerTest {

    private String token;
    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private JwtProvider jwtProvider;

    @BeforeEach
    void setUp() {
        User user = new User(0L,"123456789", "hola","hola", "1234");
        token = jwtProvider.generateToken(user);
    }

    @Test
    void testShowAllContacts() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/api/contact")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content().contentType("application/json"));
    }
    @Test
    void testShowContactsByIdUser() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/api/contact/user/1")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content().contentType("application/json"));
    }
    @Test
    void testShowContactByName() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/api/contact/name/pepe")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content().contentType("application/json"));
    }
    @Test
    void testShowContactByAlias() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/api/contact/alias/jose")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk())
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.content().contentType("application/json"));
    }
    @Test
    void testSaveContact() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post("/api/contact")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json")
                .content("{\"name\": \"pepe\", \"accountnumber\": \"123123123\", \"email\": \"test@example.com\", \"alias\": \"jose\", \"idtypeaccount\": \"1\", \"idbank\": \"1\", \"iduser\": \"1\"}"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isCreated());
    }
    @Test
    void testDeleteContact() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete("/api/contact/2")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk());
    }
}
