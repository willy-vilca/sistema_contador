
package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.UserDAO;
import com.accounting.sistemacontador.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User(email, password);
        UserDAO dao = new UserDAO();

        User loggedUser = dao.login(user);

        HttpSession session = request.getSession();
        if (loggedUser != null) {
            session.setAttribute("user", loggedUser);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            session.setAttribute("error", "Credenciales incorrectas");
            response.sendRedirect("views/auth/login.jsp");
        }
    }
}
