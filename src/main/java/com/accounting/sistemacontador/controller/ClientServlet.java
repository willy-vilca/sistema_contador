package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.ClientDAO;
import com.accounting.sistemacontador.model.Client;
import com.accounting.sistemacontador.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/clients")
public class ClientServlet extends HttpServlet {

    ClientDAO dao = new ClientDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("views/auth/login.jsp");
            return;
        }

        List<Client> clients = dao.getClientsByUser(user.getUserId());

        request.setAttribute("clients", clients);

        request.getRequestDispatcher("views/clients.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");

        Client c = new Client();
        c.setUserId(user.getUserId());
        c.setFullName(request.getParameter("fullName"));
        c.setDocumentType(request.getParameter("documentType"));
        c.setDocumentNumber(request.getParameter("documentNumber"));
        c.setEmail(request.getParameter("email"));
        c.setPhone(request.getParameter("phone"));
        c.setAddress(request.getParameter("address"));
        c.setCompanyName(request.getParameter("companyName"));

        if ("update".equals(action)) {
            c.setClientId(Integer.parseInt(request.getParameter("clientId")));
            dao.update(c);
        } else {
            dao.insert(c);
        }

        response.sendRedirect(request.getContextPath() + "/clients");
    }
}
