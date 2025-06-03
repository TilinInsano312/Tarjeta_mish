package org.tarjetamish.user.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.user.dto.UserDTO;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public List<UserDTO> list() {
        return userRepository.findAll().stream()
                .map(this::convertToDTO)
                .toList();
    }

    public Optional<UserDTO> findById(Long id) {
        return Optional.of(userRepository.findById(id).map(this::convertToDTO).orElse(null));
    }

    public UserDTO save(UserDTO userDTO) {
        User userEntity = new User(userDTO.id(), userDTO.rut(), userDTO.name(), userDTO.email(), userDTO.pin());
        return convertToDTO(userRepository.save(userEntity));
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    private UserDTO convertToDTO(User user) {
        return new UserDTO(user.getId(), user.getRut(), user.getName(), user.getEmail(), user.getPin());
    }
}
