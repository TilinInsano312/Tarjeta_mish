package org.tarjetamish.user.controller;

import lombok.AllArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.user.dto.UserDTO;
import org.tarjetamish.user.service.UserService;

import java.util.List;

@RestController
@RequestMapping("api/user")
@AllArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping
    public ResponseEntity<List<UserDTO>> list() {
        return ResponseEntity.ok(userService.list());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUserById(@PathVariable Long id) {
        return userService.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity createUser(@RequestBody UserDTO userDTO) {
        return ResponseEntity.ok(userService.save(userDTO));
    }

    @PostMapping("/{rut}")
    public ResponseEntity<UserDTO> getUserByRut(@PathVariable String rut) {
        return userService.findByRut(rut)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{rut}")
    public ResponseEntity deleteUser(@PathVariable String rut) {
        if (!userService.findByRut(rut).isPresent()) {
            return ResponseEntity.notFound().build();
        } else {
            userService.deleteUser(rut);
        }
        return ResponseEntity.noContent().build();
    }
}
