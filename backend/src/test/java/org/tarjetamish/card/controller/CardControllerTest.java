package org.tarjetamish.card.controller;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import org.springframework.test.web.servlet.result.MockMvcResultMatchers;
import org.tarjetamish.auth.jwt.JwtProvider;
import org.tarjetamish.user.model.User;

@ActiveProfiles("test")
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class CardControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private String token;
    @Autowired
    private JwtProvider jwtProvider;

    @BeforeEach
    void setUp() {
        User user = new User(0L, "123456789", "Vicente Salazar", "vicentesalazar@ufromail.cl", "1234");
        token = jwtProvider.generateToken(user);
    }

    @Test
    void testShowAllCards() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/card")
        .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.content()
                .contentType("application/json"));

    }

    @Test
    void testShowCardByNumber() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.get("/api/card/number/123456789010256")
                .header("Authorization", "Bearer " + token))
                .andExpect(status().isOk())
                .andExpect(MockMvcResultMatchers.content()
                .contentType("application/json"));
    }

    @Test
    void createCard() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.post("/api/card")
                        .header("Authorization", "Bearer " + token)
                        .contentType("application/json")
                        .content("{\"number\":\"1234567890123456\",\"cvv\":\"123\",\"expirationDate\":\"2030-10-20\",\"cardHolderName\":\"Vicente Salazar\"}"))
                .andExpect(status().isCreated());
    }


    @Test
    void deleteCard() throws Exception {
        mockMvc.perform(MockMvcRequestBuilders.delete("/api/card/number/1234567890123456")
        .header("Authorization", "Bearer " + token)
        .contentType("application/json"))
        .andExpect(status().isNoContent());
    }
}