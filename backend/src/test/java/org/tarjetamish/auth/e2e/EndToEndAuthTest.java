package org.tarjetamish.auth.e2e;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.client.TestRestTemplate;
import org.springframework.boot.test.web.server.LocalServerPort;
import org.springframework.http.*;
import org.springframework.test.context.ActiveProfiles;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;

import static org.assertj.core.api.AssertionsForClassTypes.assertThat;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@ActiveProfiles("test")
class EndToEndAuthTest {

    @LocalServerPort
    private int port;

    @Autowired
    private TestRestTemplate restTemplate;

    @Autowired
    private UserRepository userRepository;

    private String token;

    @BeforeEach
    void setUp() {

        userRepository.deleteByRut("123456789");
        User testUser = new User();
        testUser.setRut("123456789");
        testUser.setName("Test User");
        testUser.setEmail("test@test.com");
        testUser.setPin("1234");
        userRepository.save(testUser);


        String loginUrl = "http://localhost:" + port + "/api/auth/login";
        String loginBody = "{\"rut\":\"123456789\", \"pin\":\"1234\" }";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        HttpEntity<String> loginRequest = new HttpEntity<>(loginBody, headers);

        ResponseEntity<String> loginResponse = restTemplate.postForEntity(loginUrl, loginRequest, String.class);
        token = loginResponse.getBody();
    }

    @Test
    void accessProtectedEndpoint_shouldReturnOk_WhenTokenIsValid() {
        String protectedUrl = "http://localhost:" + port + "/api/user";

        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + token);

        HttpEntity<String> request = new HttpEntity<>(headers);

        ResponseEntity<String> response = restTemplate.exchange(protectedUrl, HttpMethod.GET, request, String.class);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isNotNull();
    }
}
