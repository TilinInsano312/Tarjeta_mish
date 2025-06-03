package org.tarjetamish.auth.jwt;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.tarjetamish.user.model.User;
import org.tarjetamish.user.repository.UserRepository;

@RequiredArgsConstructor
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;


    @Override
    public UserDetails loadUserByUsername(String rut) throws UsernameNotFoundException {
        User user = userRepository.findByRut(rut)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with rut: " + rut));
        return new CustomUserDetails(
                user.getId(),
                user.getRut(),
                user.getName(),
                user.getEmail(),
                user.getPin()
        );
    }
}
