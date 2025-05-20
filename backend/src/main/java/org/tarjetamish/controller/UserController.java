package org.tarjetamish.controller;

import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.tarjetamish.dto.UserDTO;
import org.tarjetamish.service.UserService;

import java.util.List;

@RestController
@RequestMapping("/user")
@AllArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping
    public List<UserDTO> list() {
        return userService.list();
    }

    @GetMapping("/{id}")
    public UserDTO getUserById(@PathVariable Long id) {
        return userService.findById(id).orElse(null);
    }

    @PostMapping
    public void createUser(@RequestBody UserDTO userDTO) {
        userService.save(userDTO);
    }

    @DeleteMapping("/{id}")
    public void deleteUser(@PathVariable Long id) {
        userService.deleteUser(id);
    }
}
