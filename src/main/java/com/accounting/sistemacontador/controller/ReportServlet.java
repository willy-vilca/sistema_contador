package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.*;
import com.accounting.sistemacontador.model.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.time.LocalDate;
import java.util.*;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    ReportDAO reportDAO = new ReportDAO();
    ClientDAO clientDAO = new ClientDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("views/auth/login.jsp");
            return;
        }

        int clientId = 0;

        String start = request.getParameter("startDate");
        String end = request.getParameter("endDate");

        List<Client> clients = clientDAO.getClientsByUser(user.getUserId());

        // Cliente por defecto
        if (!clients.isEmpty()) {
            if (request.getParameter("clientId") != null) {
                clientId = Integer.parseInt(request.getParameter("clientId"));
            } else {
                clientId = clients.get(0).getClientId();
            }
        }

        // Fechas por defecto
        if (start == null) start = LocalDate.now().minusMonths(1).toString();
        if (end == null) end = LocalDate.now().toString();

        List<Transaction> movements = reportDAO.getTransactions(clientId, start, end);
        double[] summary = reportDAO.getSummary(clientId, start, end);
        Map<String, Double> categories = reportDAO.getCategorySummary(clientId, start, end);


        request.setAttribute("clients", clients);
        request.setAttribute("movements", movements);
        request.setAttribute("ingresos", summary[0]);
        request.setAttribute("gastos", summary[1]);
        request.setAttribute("balance", summary[2]);
        request.setAttribute("categories", categories);

        request.setAttribute("selectedClient", clientId);
        request.setAttribute("startDate", start);
        request.setAttribute("endDate", end);

        request.getRequestDispatcher("views/reports.jsp").forward(request, response);
    }
}
