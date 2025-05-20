package org.tarjetamish.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.dto.UserDTO;
import org.tarjetamish.model.User;
import org.tarjetamish.repository.UserRepository;

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
        User userEntity = new User(userDTO.getId(), userDTO.getRut(), userDTO.getName(), userDTO.getEmail(), userDTO.getPin());
        return convertToDTO(userRepository.save(userEntity));
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }

    private UserDTO convertToDTO(User user) {
        return new UserDTO(user.getId(), user.getRut(), user.getName(), user.getEmail(), user.getPin());
    }
}
