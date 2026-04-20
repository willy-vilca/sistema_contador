package com.accounting.sistemacontador.dao;

import com.accounting.sistemacontador.config.DatabaseConnection;
import com.accounting.sistemacontador.model.Transaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {
    public List<Transaction> getByClient(int clientId) {
        List<Transaction> list = new ArrayList<>();

        String sql = "SELECT t.*, c.name AS category_name FROM transactions t " +
                     "LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE client_id = ? ORDER BY transaction_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setTransactionId(rs.getInt("transaction_id"));
                t.setType(rs.getString("type"));
                t.setAmount(rs.getDouble("amount"));
                t.setTransactionDate(rs.getDate("transaction_date"));
                t.setDescription(rs.getString("description"));
                t.setCategoryId(rs.getInt("category_id"));
                t.setCategoryName(rs.getString("category_name"));
                
                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public List<Transaction> getLastMovementsByUser(int userId) {
        List<Transaction> list = new ArrayList<>();

        String sql = "select c.full_name as nameClient, t.type, t.amount, t.transaction_date, t.description from transactions as t " +
                     "inner join clients as c on t.client_id = c.client_id " +
                     "inner join users as u on c.user_id = u.user_id " +
                     "where u.user_id = ? AND c.status = true order by t.transaction_date desc limit 10";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();
                t.setClientName(rs.getString("nameClient"));
                t.setType(rs.getString("type"));
                t.setAmount(rs.getDouble("amount"));
                t.setTransactionDate(rs.getDate("transaction_date"));
                t.setDescription(rs.getString("description"));
                
                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public void insert(Transaction t) {
        String sql = "INSERT INTO transactions (client_id, category_id, type, amount, transaction_date, description) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getClientId());
            ps.setInt(2, t.getCategoryId());
            ps.setString(3, t.getType());
            ps.setDouble(4, t.getAmount());
            ps.setDate(5, new java.sql.Date(t.getTransactionDate().getTime()));
            ps.setString(6, t.getDescription());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public double[] getSummaryByClient(int clientId) {

        double ingresos = 0;
        double gastos = 0;

        String sql = "SELECT type, COALESCE(SUM(amount),0) as total " +
                     "FROM transactions WHERE client_id = ? GROUP BY type";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String type = rs.getString("type");
                double total = rs.getDouble("total");

                if ("INGRESO".equalsIgnoreCase(type)) {
                    ingresos = total;
                } else if ("GASTO".equalsIgnoreCase(type)) {
                    gastos = total;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new double[]{ingresos, gastos, ingresos - gastos};
    }
    
    public double[] getSummaryByUser(int userId) {

        double ingresos = 0;
        double gastos = 0;

        // Total ingresos del usuario
        String ingresosSql = "SELECT COALESCE(SUM(amount),0) FROM transactions t " +
                "JOIN clients c ON t.client_id = c.client_id " +
                "WHERE t.type = 'INGRESO' AND c.status = true AND c.user_id = ?";

        // Total gastos del usuario
        String gastosSql = "SELECT COALESCE(SUM(amount),0) FROM transactions t " +
                "JOIN clients c ON t.client_id = c.client_id " +
                "WHERE t.type = 'GASTO' AND c.status = true AND c.user_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps1 = conn.prepareStatement(ingresosSql);
             PreparedStatement ps2 = conn.prepareStatement(gastosSql)) {

            ps1.setInt(1, userId);
            ps2.setInt(1, userId);
            ResultSet rs1 = ps1.executeQuery();
            ResultSet rs2 = ps2.executeQuery();

            if (rs1.next()) ingresos = rs1.getDouble(1);
            if (rs2.next()) gastos = rs2.getDouble(1);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new double[]{ingresos, gastos, ingresos - gastos};
    }
    
    public void update(Transaction t) {
        String sql = "UPDATE transactions SET category_id=?, type=?, amount=?, transaction_date=?, description=? WHERE transaction_id=?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, t.getCategoryId());
            ps.setString(2, t.getType());
            ps.setDouble(3, t.getAmount());
            ps.setDate(4, new java.sql.Date(t.getTransactionDate().getTime()));
            ps.setString(5, t.getDescription());
            ps.setInt(6, t.getTransactionId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public void delete(int id) {
        String sql = "DELETE FROM transactions WHERE transaction_id = ?";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
