package org.tarjetamish.user.mapper.impl;

import org.springframework.stereotype.Component;
import org.tarjetamish.user.dto.UserDTO;
import org.tarjetamish.user.mapper.IUserConverter;
import org.tarjetamish.user.model.User;

@Component
public class UserConverter implements IUserConverter {
    public UserDTO toUserDTO(User user) {
        return new UserDTO(user.getId(), user.getRut(), user.getName(), user.getEmail(), user.getPin());
    }
    public User toUserEntity(UserDTO userDTO) {
        return new User(userDTO.id(), userDTO.rut(), userDTO.name(), userDTO.email(), userDTO.pin());
    }
}
