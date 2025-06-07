package org.tarjetamish.user.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.tarjetamish.user.dto.UserDTO;
import org.tarjetamish.user.mapper.IUserConverter;

import org.tarjetamish.user.repository.UserRepository;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final IUserConverter userConverter;

    public List<UserDTO> list() {
        return userRepository.findAll().stream()
                .map(userConverter::toUserDTO)
                .toList();
    }

    public Optional<UserDTO> findById(Long id) {
        return Optional.of(userRepository.findById(id).map(userConverter::toUserDTO).orElse(null));
    }

    public UserDTO save(UserDTO userDTO) {
        return userConverter.toUserDTO(
                userRepository.save(userConverter.toUserEntity(userDTO))
        );
    }

    public void deleteUser(Long id) {
        userRepository.deleteById(id);
    }
}
