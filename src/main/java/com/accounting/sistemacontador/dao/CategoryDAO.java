package com.accounting.sistemacontador.dao;

import com.accounting.sistemacontador.config.DatabaseConnection;
import com.accounting.sistemacontador.model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public List<Category> getAll() {
        List<Category> list = new ArrayList<>();

        String sql = "SELECT * FROM categories";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setType(rs.getString("type"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
