package org.tarjetamish.rowMapper;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import org.tarjetamish.model.User;

import java.sql.ResultSet;
import java.sql.SQLException;

@Component
public class UserRowMapper implements RowMapper<User> {
    @Override
    public User mapRow(ResultSet rs, int rowNum) throws SQLException {
        User user = new User();
        user.setId(rs.getLong("iduser"));
        user.setRut(rs.getString("rut"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPin(rs.getString("pin"));
        return user;
    }

}
