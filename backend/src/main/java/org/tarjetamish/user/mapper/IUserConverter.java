package org.tarjetamish.user.mapper;

import org.tarjetamish.user.dto.UserDTO;
import org.tarjetamish.user.model.User;

public interface IUserConverter {
    UserDTO toUserDTO(User user);
    User toUserEntity(UserDTO userDTO);
}
