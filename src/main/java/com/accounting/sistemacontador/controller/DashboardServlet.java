
package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.TransactionDAO;
import com.accounting.sistemacontador.model.Transaction;
import com.accounting.sistemacontador.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        TransactionDAO transactionDAO = new TransactionDAO();

        if (user == null) {
            response.sendRedirect("views/auth/login.jsp");
            return;
        }
        
        //resumen de las transacciones totales del usuario(ingresos,gastos,balance)
        double[] summary = transactionDAO.getSummaryByUser(user.getUserId());
        request.setAttribute("ingresos", summary[0]);
        request.setAttribute("gastos", summary[1]);
        request.setAttribute("balance", summary[2]);
            
        //ultimos movimientos del usuario
        List<Transaction> ultimosMovimientos = transactionDAO.getLastMovementsByUser(user.getUserId());
        request.setAttribute("ultimosMovimientos", ultimosMovimientos);
        request.getRequestDispatcher("views/dashboard.jsp").forward(request, response);
    }
}