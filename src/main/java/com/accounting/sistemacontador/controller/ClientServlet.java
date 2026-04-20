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
        
        //validación del número de teléfono
        String telefono = request.getParameter("phone");
        if (telefono != null && !telefono.matches("\\d{9}")) {
            //si el campo no es valido se retorna a la pagína y se envia un mensaje de error
            request.setAttribute("error", "El número de teléfono debe tener exactamente 9 dígitos");
            List<Client> clients = dao.getClientsByUser(user.getUserId());
            request.setAttribute("clients", clients);
            request.getRequestDispatcher("views/clients.jsp").forward(request, response);
            return;
        }
        
        //validación del número de documento
        String tipoDoc = request.getParameter("documentType");
        String numDoc = request.getParameter("documentNumber");
        if ("DNI".equals(tipoDoc) && !numDoc.matches("\\d{8}")) {
            //si el campo no es valido se retorna a la pagína y se envia un mensaje de error
            request.setAttribute("error", "El número del DNI debe tener exactamente 8 dígitos");
            List<Client> clients = dao.getClientsByUser(user.getUserId());
            request.setAttribute("clients", clients);
            request.getRequestDispatcher("views/clients.jsp").forward(request, response);
            return;
        }
        if ("RUC".equals(tipoDoc) && !numDoc.matches("\\d{11}")) {
            //si el campo no es valido se retorna a la pagína y se envia un mensaje de error
            request.setAttribute("error", "El número del RUC debe tener exactamente 11 dígitos");
            List<Client> clients = dao.getClientsByUser(user.getUserId());
            request.setAttribute("clients", clients);
            request.getRequestDispatcher("views/clients.jsp").forward(request, response);
            return;
        }

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
