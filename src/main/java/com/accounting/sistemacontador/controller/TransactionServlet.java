package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.ClientDAO;
import com.accounting.sistemacontador.dao.TransactionDAO;
import com.accounting.sistemacontador.dao.CategoryDAO;
import com.accounting.sistemacontador.model.Client;
import com.accounting.sistemacontador.model.User;
import com.accounting.sistemacontador.model.Transaction;
import com.accounting.sistemacontador.model.Category;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/movements")
public class TransactionServlet extends HttpServlet {

    TransactionDAO transactionDAO = new TransactionDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
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

        if (request.getParameter("clientId") != null) {
            clientId = Integer.parseInt(request.getParameter("clientId"));
        }

        List<Client> clients = clientDAO.getClientsByUser(user.getUserId());

        if (clientId == 0 && !clients.isEmpty()) {
            clientId = clients.get(0).getClientId();
        }

        List<Transaction> movements = transactionDAO.getByClient(clientId);
        List<Category> categories = categoryDAO.getAll();

        request.setAttribute("clients", clients);
        request.setAttribute("movements", movements);
        request.setAttribute("categories", categories);
        request.setAttribute("selectedClient", clientId);
        
        //resumen de las transacciones del cliente(ingresos,gastos,balance)
        double[] summary = transactionDAO.getSummaryByClient(clientId);

        request.setAttribute("ingresos", summary[0]);
        request.setAttribute("gastos", summary[1]);
        request.setAttribute("balance", summary[2]);

        request.getRequestDispatcher("views/movements.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        String action = request.getParameter("action");
        
        Transaction t = new Transaction();

        t.setClientId(Integer.parseInt(request.getParameter("clientId")));
        t.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        t.setType(request.getParameter("type"));
        t.setAmount(Double.parseDouble(request.getParameter("amount")));
        t.setTransactionDate(java.sql.Date.valueOf(request.getParameter("date")));
        t.setDescription(request.getParameter("description"));

        if ("update".equals(action)) {
            t.setTransactionId(Integer.parseInt(request.getParameter("transactionId")));
            transactionDAO.update(t);
        } else {
            transactionDAO.insert(t);
        }

        response.sendRedirect(request.getContextPath() + "/movements?clientId=" + t.getClientId());
    }
}
