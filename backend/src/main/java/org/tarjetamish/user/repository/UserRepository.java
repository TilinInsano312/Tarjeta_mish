package org.tarjetamish.user.repository;

import org.tarjetamish.user.model.User;

import java.util.List;
import java.util.Optional;

public interface UserRepository {

    List<User> findAll();

    Optional<User> findById(Long id);

    User save(User user);

    void deleteById(Long id);

    Optional<User> findByRut(String rut);

    boolean existByRut(String rut);
}
