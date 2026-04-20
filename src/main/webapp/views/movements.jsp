<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Movimientos</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dashboard.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/movements.css">
    </head>

    <body>
        <!-- Mobile Header -->
        <div class="mobile-header">
            <button class="hamburger-btn" onclick="toggleSidebar()">&#9776;</button>
            <span class="mobile-title">Movimientos</span>
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

                <div class="col-md-10 p-4 main-content">
                    <nav class="navbar page-header py-1 px-2 mb-4">
                        <h3 class="mb-3">Movimientos</h3>
                    </nav>
                    <!-- SELECT CLIENTE -->
                    <form action="<%= request.getContextPath() %>/movements" method="get">
                        <div class="mb-2 row">
                            <label class="col-sm-2 col-form-label fw-bold ms-1">Seleccione un Cliente:</label>
                            <div class="col-sm-10">
                                <select name="clientId" onchange="this.form.submit()" class="form-control w-auto mb-3">
                                    <c:forEach var="c" items="${clients}">
                                        <option value="${c.clientId}" ${c.clientId == selectedClient ? 'selected' : ''}>
                                            ${c.fullName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </form>

                    <!-- BALANCE DEL CLIENTE -->    
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="summary-card card-income shadow mb-3 mb-md-0">
                                <h5>Ingresos</h5>
                                <h3>S/. ${ingresos}</h3>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="summary-card card-expense shadow mb-3 mb-md-0">
                                <h5>Gastos</h5>
                                <h3>S/. ${gastos}</h3>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="summary-card card-balance shadow">
                                <h5>Balance</h5>
                                <h3>S/. ${balance}</h3>
                            </div>
                        </div>
                    </div>
                    <div class="navbar py-1 mb-2"></div>        
                    <!-- FORM -->
                    <div class="card p-3 mb-3 shadow-sm">
                        <h5 class="mb-3">Agregar nuevo movimiento</h5>
                        <form action="<%= request.getContextPath() %>/movements" method="post" class="row g-2 mb-4">

                            <input type="hidden" name="clientId" value="${selectedClient}">

                            <div class="col-md-2">
                                <select name="type" class="form-control">
                                    <option value="INGRESO">Ingreso</option>
                                    <option value="GASTO">Gasto</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <input type="number" step="0.5" min="0.5" name="amount" class="form-control" placeholder="Monto" required="true">
                            </div>

                            <div class="col-md-3">
                                <select name="categoryId" class="form-control" required="true">
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}">
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <input type="date" name="date" class="form-control" required="true">
                            </div>

                            <div class="col-md-3">
                                <input name="description" class="form-control" placeholder="Descripción" required="true">
                            </div>

                            <div class="col-md-2 mt-3">
                                <button class="btn btn-primary w-100">Agregar</button>
                            </div>

                        </form>
                    </div>   
                    <!-- TABLA -->
                    <div class="table-responsive-mobile">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>Tipo</th>
                                <th>Monto</th>
                                <th>Fecha</th>
                                <th>Descripción</th>
                                <th>Categoría</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="m" items="${movements}">
                                <tr>
                                    <td>${m.type}</td>
                                    <td>${m.amount}</td>
                                    <td>${m.transactionDate}</td>
                                    <td>${m.description}</td>
                                    <td>${m.categoryName}</td>
                                    <td>
                                        <button class="btn btn-warning btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editModal"
                                            onclick="loadMovementData(
                                                ${m.transactionId},
                                                '${m.type}',
                                                ${m.amount},
                                                '${m.transactionDate}',
                                                '${m.description}',
                                                ${m.categoryId}
                                            )">
                                            Editar
                                        </button>
                                        <button class="btn btn-danger btn-sm"
                                            data-bs-toggle="modal"
                                            data-bs-target="#deleteModal"
                                            onclick="setDeleteMovement(${m.transactionId}, ${selectedClient})">
                                            Eliminar
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                    </div>
                </div>
            </div>
        </div>

            <!-- MODAL ELIMINAR -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Eliminar movimiento</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body text-center">
                        <p>¿Estás seguro que deseas eliminar este movimiento?</p>
                        <small class="text-muted">
                            Esta acción no se puede deshacer.
                        </small>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Cancelar
                        </button>

                        <a id="confirmDeleteMovement" class="btn btn-danger">
                            Sí, eliminar
                        </a>
                    </div>

                </div>
            </div>
        </div>

        <!-- MODAL EDITAR -->
        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-warning">
                        <h5 class="modal-title">Editar Movimiento</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <form action="<%= request.getContextPath() %>/movements" method="post">

                        <div class="modal-body">

                            <input type="hidden" name="transactionId" id="editId">
                            <input type="hidden" name="clientId" value="${selectedClient}">
                            <input type="hidden" name="action" value="update">

                            <div class="row g-2">

                                <div class="col-md-3">
                                    <select id="editType" name="type" class="form-control">
                                        <option value="INGRESO">Ingreso</option>
                                        <option value="GASTO">Gasto</option>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <input type="number" step="0.5" min="0.5" id="editAmount" name="amount" class="form-control" required>
                                </div>

                                <div class="col-md-3">
                                    <select id="editCategory" name="categoryId" class="form-control">
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}">
                                                ${cat.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <input type="date" id="editDate" name="date" class="form-control" required>
                                </div>

                                <div class="col-md-12">
                                    <input id="editDescription" name="description" class="form-control" placeholder="Descripción" required>
                                </div>

                            </div>

                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <button type="submit" class="btn btn-warning">Guardar cambios</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script src="<%= request.getContextPath() %>/assets/js/movements.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
