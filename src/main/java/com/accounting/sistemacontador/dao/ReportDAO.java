package com.accounting.sistemacontador.dao;

import com.accounting.sistemacontador.config.DatabaseConnection;
import com.accounting.sistemacontador.model.Transaction;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    // 🔹 1. LISTA DE MOVIMIENTOS FILTRADOS
    public List<Transaction> getTransactions(int clientId, String start, String end) {

        List<Transaction> list = new ArrayList<>();

        String sql = "SELECT t.*, c.name AS category_name " +
                "FROM transactions t " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE t.client_id = ? AND t.transaction_date BETWEEN ? AND ? " +
                "ORDER BY t.transaction_date DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setDate(2, Date.valueOf(start));
            ps.setDate(3, Date.valueOf(end));

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Transaction t = new Transaction();

                t.setTransactionId(rs.getInt("transaction_id"));
                t.setType(rs.getString("type"));
                t.setAmount(rs.getDouble("amount"));
                t.setTransactionDate(rs.getDate("transaction_date"));
                t.setDescription(rs.getString("description"));
                t.setCategoryId(rs.getInt("category_id"));

                list.add(t);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔹 2. RESUMEN (INGRESOS / GASTOS)
    public double[] getSummary(int clientId, String start, String end) {

        double ingresos = 0;
        double gastos = 0;

        String sql = "SELECT type, COALESCE(SUM(amount),0) total " +
                "FROM transactions " +
                "WHERE client_id = ? AND transaction_date BETWEEN ? AND ? " +
                "GROUP BY type";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setDate(2, Date.valueOf(start));
            ps.setDate(3, Date.valueOf(end));

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String type = rs.getString("type");
                double total = rs.getDouble("total");

                if ("INGRESO".equalsIgnoreCase(type)) ingresos = total;
                if ("GASTO".equalsIgnoreCase(type)) gastos = total;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new double[]{ingresos, gastos, ingresos - gastos};
    }

    // 🔹 3. RESUMEN POR CATEGORÍAS
    public Map<String, Double> getCategorySummary(int clientId, String start, String end) {

        Map<String, Double> map = new LinkedHashMap<>();

        String sql = "SELECT c.name, COALESCE(SUM(t.amount),0) total " +
                "FROM transactions t " +
                "LEFT JOIN categories c ON t.category_id = c.category_id " +
                "WHERE t.client_id = ? AND t.transaction_date BETWEEN ? AND ? " +
                "GROUP BY c.name ORDER BY total DESC";

        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, clientId);
            ps.setDate(2, Date.valueOf(start));
            ps.setDate(3, Date.valueOf(end));

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                map.put(rs.getString("name"), rs.getDouble("total"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }
}
