package org.tarjetamish.security.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.dto.request.LoginRequestDTO;
import org.tarjetamish.security.auth.service.IAuthService;

import java.util.concurrent.ConcurrentHashMap;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final IAuthService authService;
    private final ConcurrentHashMap<String, String> tokenCache = new ConcurrentHashMap<>();

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody LoginRequestDTO loginRequestDTO) {
        String token = authService.login(loginRequestDTO.getRut(), loginRequestDTO.getPin());
        if (token == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Login failed");
        }
        tokenCache.put(loginRequestDTO.getRut(), token);
        return ResponseEntity.ok(token);
    }

    @GetMapping("/test")
    public ResponseEntity<String> test() {
        return ResponseEntity.ok("Test endpoint");
    }
}
