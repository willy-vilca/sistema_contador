<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Reportes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dashboard.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/reports.css">

        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>

    <body>
        <!-- Mobile Header -->
        <div class="mobile-header">
            <button class="hamburger-btn" onclick="toggleSidebar()">&#9776;</button>
            <span class="mobile-title">Reportes</span>
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

                <div class="col-md-10 main-content p-4">
                    <nav class="navbar page-header pb-4 pt-1 mb-4">
                    <h3>Reportes</h3>
                    </nav>
                    <!-- FILTROS -->
                    <form method="get" action="<%= request.getContextPath() %>/reports" class="row g-2 mb-2">

                        <div class="col-md-3">
                            <select name="clientId" class="form-control">
                                <c:forEach var="c" items="${clients}">
                                    <option value="${c.clientId}" ${c.clientId == selectedClient ? 'selected' : ''}>
                                        ${c.fullName}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="row g-3 align-items-center">
                                <div class="col-auto">
                                  <label class="col-form-label fw-bold">Fecha Inicial: </label>
                                </div>
                                <div class="col-auto">
                                    <input type="date" name="startDate" value="${startDate}" class="form-control" required>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="row g-3 align-items-center">
                                <div class="col-auto">
                                  <label class="col-form-label fw-bold">Fecha Final: </label>
                                </div>
                                <div class="col-auto">
                                  <input type="date" name="endDate" value="${endDate}" class="form-control" required>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <button type="submit" class="btn btn-primary w-100">Generar reporte</button>
                        </div>

                    </form>
                    <div class="navbar py-2 mb-5"></div>            
                    <!-- CARDS -->
                    <div class="row mb-4">

                        <div class="col-md-4">
                            <div class="report-card card-income shadow mb-3 mb-md-0">
                                <h5>Ingresos</h5>
                                <h3>S/. ${ingresos}</h3>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="report-card card-expense shadow mb-3 mb-md-0">
                                <h5>Gastos</h5>
                                <h3>S/. ${gastos}</h3>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="report-card card-balance shadow">
                                <h5>Balance</h5>
                                <h3>S/. ${balance}</h3>
                            </div>
                        </div>

                    </div>
                    <div class="navbar py-2 mb-4"></div>       

                    <div class="row justify-content-around">
                        <!-- GRÁFICO -->
                        <div class="col-md-3 chart-container mb-4">
                            <h5 class="mb-4">Ingresos vs Gastos</h5>
                            <canvas id="pieChart"></canvas>
                        </div>
                        <!--TABLA MOVIMIENTOS -->
                        <div class="col-md-8 chart-container mb-4">
                            <h5 class="mb-3">Movimientos</h5>
                            <div class="table-responsive-mobile">
                                <table class="table table-hover align-middle">
                                    <thead>
                                        <tr>
                                            <th>Tipo</th>
                                            <th>Monto</th>
                                            <th>Fecha</th>
                                            <th>Descripción</th>
                                        </tr>
                                    </thead>

                                    <tbody>
                                        <c:forEach var="m" items="${movements}">
                                            <tr>
                                                <td>${m.type}</td>
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
                    <div class="navbar py-2 mb-4"></div> 
                    <!-- Categorias -->
                    <div class="row justify-content-around">

                        <!-- TABLA -->
                        <div class="col-md-5 chart-container">
                            <h5>Resumen por Categorías</h5>

                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Categoría</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="entry" items="${categories}">
                                        <tr>
                                            <td>${entry.key}</td>
                                            <td>${entry.value}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>

                        <!-- GRÁFICO -->
                        <div class="col-md-6 chart-container">
                            <h5>Gráfico por Categorías</h5>
                            <canvas id="barChart"></canvas>
                        </div>

                    </div>    
                </div>
            </div>
        </div>                
        <script>

        new Chart(document.getElementById("pieChart"), {
            type: 'pie',
            data: {
                labels: ['Ingresos', 'Gastos'],
                datasets: [{
                    data: [${ingresos}, ${gastos}],
                    backgroundColor: ['#28a745', '#dc3545']
                }]
            }
        });

        const labels = [
            <c:forEach var="entry" items="${categories}">
                '${entry.key}',
            </c:forEach>
        ];

        const data = [
            <c:forEach var="entry" items="${categories}">
                ${entry.value},
            </c:forEach>
        ];

        new Chart(document.getElementById("barChart"), {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: 'Total',
                    data: data
                }]
            }
        });

        </script>

        <script>
        function toggleSidebar() {
            document.querySelector('.sidebar').classList.toggle('active');
            document.querySelector('.sidebar-overlay').classList.toggle('active');
        }
        </script>
    </body>
</html>
