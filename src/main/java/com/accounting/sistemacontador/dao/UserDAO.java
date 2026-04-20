
package com.accounting.sistemacontador.dao;

import com.accounting.sistemacontador.config.DatabaseConnection;
import com.accounting.sistemacontador.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class UserDAO {

    public User login(User user) {
        User loggedUser = null;

        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                loggedUser = new User();
                loggedUser.setUserId(rs.getInt("user_id"));
                loggedUser.setFullName(rs.getString("full_name"));
                loggedUser.setEmail(rs.getString("email"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return loggedUser;
    }
    
    public boolean emailExists(String email) {

        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    public User register(User user) {

        String sql = "INSERT INTO users (full_name, email, password) VALUES (?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                user.setUserId(rs.getInt(1));
            }

            return user;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
