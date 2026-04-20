
package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.config.DatabaseConnection;
import com.accounting.sistemacontador.dao.TransactionDAO;
import com.accounting.sistemacontador.model.Transaction;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Object user = session.getAttribute("user");
        TransactionDAO transactionDAO = new TransactionDAO();

        if (user == null) {
            response.sendRedirect("views/auth/login.jsp");
            return;
        }

        try (Connection conn = DatabaseConnection.getConnection()) {

            // Total ingresos
            String ingresosSql = "SELECT COALESCE(SUM(amount),0) FROM transactions t " +
                    "JOIN clients c ON t.client_id = c.client_id " +
                    "WHERE t.type = 'INGRESO' AND c.user_id = ?";

            // Total gastos
            String gastosSql = "SELECT COALESCE(SUM(amount),0) FROM transactions t " +
                    "JOIN clients c ON t.client_id = c.client_id " +
                    "WHERE t.type = 'GASTO' AND c.user_id = ?";

            PreparedStatement ps1 = conn.prepareStatement(ingresosSql);
            PreparedStatement ps2 = conn.prepareStatement(gastosSql);

            int userId = ((com.accounting.sistemacontador.model.User) user).getUserId();

            ps1.setInt(1, userId);
            ps2.setInt(1, userId);

            ResultSet rs1 = ps1.executeQuery();
            ResultSet rs2 = ps2.executeQuery();

            double ingresos = 0;
            double gastos = 0;

            if (rs1.next()) ingresos = rs1.getDouble(1);
            if (rs2.next()) gastos = rs2.getDouble(1);

            double balance = ingresos - gastos;

            request.setAttribute("ingresos", ingresos);
            request.setAttribute("gastos", gastos);
            request.setAttribute("balance", balance);
            
            //ultimos movimientos del usuario
            List<Transaction> ultimosMovimientos = transactionDAO.getLastMovementsByUser(userId);
            request.setAttribute("ultimosMovimientos", ultimosMovimientos);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("views/dashboard.jsp").forward(request, response);
    }
}