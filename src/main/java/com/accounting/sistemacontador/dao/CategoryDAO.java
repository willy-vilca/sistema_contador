package com.accounting.sistemacontador.dao;

import com.accounting.sistemacontador.config.DatabaseConnection;
import com.accounting.sistemacontador.model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    public void addCategory(Category category) {

        String sql = "INSERT INTO categories (name, type, description, user_id) VALUES (?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getType());
            ps.setString(3, category.getDescription());
            ps.setInt(4, category.getUserId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public List<Category> getCategoriesByUser(int userId) {

        List<Category> list = new ArrayList<>();

        String sql = "SELECT * FROM categories WHERE user_id = ? OR user_id IS NULL";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("category_id"));
                c.setName(rs.getString("name"));
                c.setType(rs.getString("type"));
                c.setDescription(rs.getString("description"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public void updateCategory(Category category) {

        String sql = "UPDATE categories SET name = ?, type = ?, description = ? WHERE category_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category.getName());
            ps.setString(2, category.getType());
            ps.setString(3, category.getDescription());
            ps.setInt(4, category.getCategoryId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void deleteCategory(int categoryId, int userId) {

        String sql = "DELETE FROM categories WHERE category_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
