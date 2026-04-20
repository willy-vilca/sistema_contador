package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.ClientDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteClient")
public class DeleteClientServlet extends HttpServlet {

    ClientDAO dao = new ClientDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        dao.delete(id);

        response.sendRedirect(request.getContextPath() + "/clients");
    }
}
