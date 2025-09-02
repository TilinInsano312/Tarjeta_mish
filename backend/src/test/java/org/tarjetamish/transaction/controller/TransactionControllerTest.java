package org.tarjetamish.transaction.controller;

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
class TransactionControllerTest {
    @Autowired
    private TransactionController transactionController;

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
    void testListTransactions() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/api/transaction")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk());
    }
    @Test
    void testFindById() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get("/api/transaction/2")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk());
    }
    @Test
    void testSaveTransaction() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post("/api/transaction")
                .header("Authorization", "Bearer " + token)
                .contentType("application/json")
                .content("{\"amount\":10000,\"name\":\"pepe\",\"date\":\"2025-06-21\",\"description\":\"transancion test\",\"rutDestination\":\"21715794-3\",\"accountDestination\":\"123456789\",\"rutOrigin\":\"123456789\",\"accountOrigin\":\"123456789\",\"typeTransaction\":\"TARJETA_DEBITO\",\"bank\":\"BANCO_BICE\",\"idAccount\":1}"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isCreated());
    }
    @Test
    void testDeleteTransaction() throws Exception {
        mockMvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete("/api/transaction/1"  )
                .header("Authorization", "Bearer " + token)
                .contentType("application/json"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isNoContent());
    }


}
