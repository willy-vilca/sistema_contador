package com.accounting.sistemacontador.controller;

import com.accounting.sistemacontador.dao.CategoryDAO;
import com.accounting.sistemacontador.model.Category;
import com.accounting.sistemacontador.model.User;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        CategoryDAO dao = new CategoryDAO();
        
        //crear nueva categoria
        if ("create".equals(action)) {

            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String description = request.getParameter("description");
            
            Category category = new Category();
            category.setName(name);
            category.setType(type);
            category.setDescription(description);
            category.setUserId(user.getUserId());

            dao.addCategory(category);
        //editar una categoria    
        } else if ("update".equals(action)) {

            int id = Integer.parseInt(request.getParameter("categoryId"));
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            String description = request.getParameter("description");

            Category category = new Category();
            category.setCategoryId(id);
            category.setName(name);
            category.setType(type);
            category.setDescription(description);
            category.setUserId(user.getUserId());

            dao.updateCategory(category);
        }

        response.sendRedirect(request.getContextPath() + "/movements");
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        CategoryDAO dao = new CategoryDAO();

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteCategory(id, user.getUserId());
        }

        response.sendRedirect(request.getContextPath() + "/movements");
    }
}
