package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.TransactionDAO;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/deleteMovement")
public class DeleteTransactionServlet extends HttpServlet {

    TransactionDAO dao = new TransactionDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        int clientId = Integer.parseInt(request.getParameter("clientId"));

        dao.delete(id);

        response.sendRedirect(request.getContextPath() + "/movements?clientId=" + clientId);
    }
}
