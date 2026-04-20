package com.accounting.sistemacontador.dao;

import com.accounting.sistemacontador.config.DatabaseConnection;
import com.accounting.sistemacontador.model.Client;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientDAO {

    public List<Client> getClientsByUser(int userId) {
        List<Client> list = new ArrayList<>();

        String sql = "SELECT * FROM clients WHERE user_id = ? AND status = true";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Client c = new Client();
                c.setClientId(rs.getInt("client_id"));
                c.setFullName(rs.getString("full_name"));
                c.setDocumentType(rs.getString("document_type"));
                c.setDocumentNumber(rs.getString("document_number"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setAddress(rs.getString("address"));
                c.setCompanyName(rs.getString("company_name"));
                c.setStatus(rs.getBoolean("status"));

                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insert(Client c) {
        String sql = "INSERT INTO clients (user_id, full_name, document_type, document_number, email, phone, address, company_name) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, c.getUserId());
            ps.setString(2, c.getFullName());
            ps.setString(3, c.getDocumentType());
            ps.setString(4, c.getDocumentNumber());
            ps.setString(5, c.getEmail());
            ps.setString(6, c.getPhone());
            ps.setString(7, c.getAddress());
            ps.setString(8, c.getCompanyName());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Client c) {
        String sql = "UPDATE clients SET full_name=?, document_type=?, document_number=?, email=?, phone=?, address=?, company_name=? WHERE client_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, c.getFullName());
            ps.setString(2, c.getDocumentType());
            ps.setString(3, c.getDocumentNumber());
            ps.setString(4, c.getEmail());
            ps.setString(5, c.getPhone());
            ps.setString(6, c.getAddress());
            ps.setString(7, c.getCompanyName());
            ps.setInt(8, c.getClientId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void delete(int id) {
        String sql = "UPDATE clients SET status = false WHERE client_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
