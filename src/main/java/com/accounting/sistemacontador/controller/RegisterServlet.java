package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.UserDAO;
import com.accounting.sistemacontador.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    UserDAO dao = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirmPassword");

        // VALIDAR CONTRASEÑAS
        if (!password.equals(confirm)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        // VALIDAR EMAIL
        if (dao.emailExists(email)) {
            request.setAttribute("error", "El correo ya está en uso");
            request.getRequestDispatcher("views/auth/register.jsp").forward(request, response);
            return;
        }

        // CREAR USUARIO
        User user = new User();
        user.setFullName(name);
        user.setEmail(email);
        user.setPassword(password);

        user = dao.register(user);

        // LOGIN AUTOMÁTICO
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
