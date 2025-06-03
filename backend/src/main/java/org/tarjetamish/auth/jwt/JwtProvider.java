package org.tarjetamish.auth.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.extern.java.Log;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.tarjetamish.user.model.User;

import javax.crypto.SecretKey;
import java.security.Key;
import java.util.Date;
import java.util.function.Function;

@Log
@Component
public class JwtProvider {
    private final Long expiration;
    private final Key key;


    public JwtProvider(@Value("${jwt.secret}") String secret,
                       @Value("${jwt.expiration}") Long expiration) {
        this.expiration = expiration;
        this.key = Keys.hmacShaKeyFor(secret.getBytes());
    }

    public String generateToken(User user) {
        return Jwts.builder()
                .subject(String.valueOf(user.getId()))
                .claim("rut", user.getRut())
                .issuedAt(new Date())
                .expiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(key)
                .compact();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser()
                    .verifyWith((SecretKey) key)
                    .build()
                    .parseSignedClaims(token);
            return true;
        } catch (Exception e) {
            log.warning("Invalid token");
            return false;
        }
    }

    //Extract specific claim from the token
    public <T> T getClaim(String token, Function<Claims, T> claimsTFunction) {
        return claimsTFunction.apply(extractAllClaims(token));
    }

    //Extract all claims from the token
    private Claims extractAllClaims(String token) {
        return Jwts.parser()
                .verifyWith((SecretKey) key)
                .build()
                .parseSignedClaims(token)
                .getPayload();

    }

    //Extract user id from the token
    private Long getUserId(String token) {
        return getClaim(token, claims -> Long.valueOf(claims.getSubject()));
    }

    //Extract user rut from the token
    public String getUserRut(String token) {
        return getClaim(token, claims -> claims.get("rut", String.class));
    }

    //Extract userName from the token
    public String getUserName(String token) {
        return getClaim(token, claims -> claims.get("name", String.class));
    }




}
