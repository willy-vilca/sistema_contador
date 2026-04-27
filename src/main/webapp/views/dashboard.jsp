<%@page import="com.accounting.sistemacontador.model.User"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Dashboard</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dashboard.css">
    </head>

    <body>
        <!-- Mobile Header -->
        <div class="mobile-header">
            <button class="hamburger-btn" onclick="toggleSidebar()">&#9776;</button>
            <span class="mobile-title">Dashboard</span>
        </div>
        <div class="sidebar-overlay" onclick="toggleSidebar()"></div>

        <div class="container-fluid">
            <div class="row">

                <!-- SIDEBAR -->
                <div class="col-md-2 sidebar d-flex flex-column justify-content-between">
                    <div>
                        <h3>Contador</h3>
                        <hr>
                        <a href="<%= request.getContextPath() %>/dashboard">Dashboard</a>
                        <a href="<%= request.getContextPath() %>/clients">Clientes</a>
                        <a href="<%= request.getContextPath() %>/movements">Movimientos</a>
                        <a href="<%= request.getContextPath() %>/reports">Reportes</a>
                    </div>
                    <div class="logout-container">
                        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">
                            Cerrar sesión
                        </a>
                    </div>
                </div>

                <!-- CONTENIDO -->
                <div class="col-md-10 main-content ps-4">
                    <%  
                        User user = (User) session.getAttribute("user");
                        String nombreCompleto = user.getFullName();
                        String primerNombre = nombreCompleto.split(" ")[0];
                    %>
                    <nav class="navbar page-header py-4 px-2 mb-4">
                        <h3>Bienvenido al sistema, <%= primerNombre %></h3>
                    </nav>

                    <!-- CARDS -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="card card-income p-3 shadow mb-3 mb-md-0">
                                <h5>Ingresos Totales</h5>
                                <h3>S/. ${ingresos}</h3>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card card-expense p-3 shadow mb-3 mb-md-0">
                                <h5>Gastos Totales</h5>
                                <h3>S/. ${gastos}</h3>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card card-balance p-3 shadow">
                                <h5>Balance Total</h5>
                                <h3>S/. ${balance}</h3>
                            </div>
                        </div>
                    </div>
                            
                    <div class="navbar py-1 mb-2"></div>

                    <!-- TABLA -->
                    <div class="card p-3">
                        <h5>Últimos movimientos</h5>
                        <div class="table-responsive-mobile">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Tipo</th>
                                        <th>Cliente</th>
                                        <th>Monto</th>
                                        <th>Fecha</th>
                                        <th>Descripción</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="m" items="${ultimosMovimientos}">
                                        <tr>
                                            <td>
                                                <span class="badge 
                                                    ${m.type == 'INGRESO' ? 'bg-success' : 'bg-danger'}">
                                                    ${m.type}
                                                </span>
                                            </td>
                                            <td><strong>${m.clientName}</strong></td>
                                            <td>${m.amount}</td>
                                            <td>${m.transactionDate}</td>
                                            <td>${m.description}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            function toggleSidebar() {
                document.querySelector('.sidebar').classList.toggle('active');
                document.querySelector('.sidebar-overlay').classList.toggle('active');
            }
        </script>
    </body>
</html>
