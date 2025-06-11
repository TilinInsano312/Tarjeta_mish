package org.tarjetamish.auth.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.auth.dto.request.LoginRequestDTO;
import org.tarjetamish.auth.service.IAuthService;
import java.util.Map;

@RequiredArgsConstructor
@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final IAuthService authService;

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> login(@RequestBody LoginRequestDTO loginRequestDTO) {
        String token = authService.login(loginRequestDTO.rut(), loginRequestDTO.pin());
        return ResponseEntity.ok(Map.of("token", token));
    }

}
    