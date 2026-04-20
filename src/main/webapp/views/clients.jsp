<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Clientes</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/dashboard.css">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/clients.css">
    </head>

    <body>
        <!-- Mobile Header -->
        <div class="mobile-header">
            <button class="hamburger-btn" onclick="toggleSidebar()">&#9776;</button>
            <span class="mobile-title">Gestión de Clientes</span>
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
                <div class="col-md-10 p-4 main-content">
                    <nav class="navbar page-header py-1 px-2 mb-4">
                        <h3 class="mb-4">Gestión de Clientes</h3>
                    </nav>
                    <!-- FORMULARIO -->
                    <div class="card p-3 mb-4 shadow-sm">
                        <h5 class="mb-3">Agregar nuevo cliente</h5>

                        <form action="<%= request.getContextPath() %>/clients" method="post">

                            <div class="row g-2">

                                <div class="col-md-3">
                                    <input name="fullName" class="form-control" placeholder="Nombre completo" required>
                                </div>

                                <div class="col-md-2">
                                    <select name="documentType" class="form-control" required>
                                        <option value="DNI">DNI</option>
                                        <option value="RUC">RUC</option>
                                    </select>
                                </div>
                                
                                <div class="col-md-2">
                                    <input type="number" name="documentNumber" class="form-control" placeholder="Número documento" required>
                                </div>

                                <div class="col-md-2">
                                    <input type="number" name="phone" class="form-control" placeholder="Teléfono" required>
                                </div>

                                <div class="col-md-3">
                                    <input type="email" name="email" class="form-control" placeholder="Correo electrónico" required>
                                </div>

                                <div class="col-md-4">
                                    <input name="companyName" class="form-control" placeholder="Empresa (opcional)">
                                </div>

                                <div class="col-md-6">
                                    <input name="address" class="form-control" placeholder="Dirección" required>
                                </div>

                                <div class="col-md-2">
                                    <button class="btn btn-custom w-100">Agregar</button>
                                </div>
                            </div>
                        </form>
                    </div>
                    <!-- TABLA -->
                    <div class="table-container shadow-sm">
                        <div class="navbar py-1 mb-4"></div>
                        <h5 class="mb-3">Listado de Clientes</h5>

                        <div class="table-responsive-mobile">
                            <table class="table table-hover align-middle">

                                <thead class="table-light">
                                    <tr>
                                        <th>Nombre</th>
                                        <th>Documento</th>
                                        <th>Empresa</th>
                                        <th>Email</th>
                                        <th>Teléfono</th>
                                        <th>Acciones</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach var="c" items="${clients}">
                                        <tr>
                                            <td><strong>${c.fullName}</strong></td>
                                            <td>${c.documentType} - ${c.documentNumber}</td>
                                            <td>${c.companyName}</td>
                                            <td>${c.email}</td>
                                            <td>${c.phone}</td>
                                            <td>
                                                <button class="btn btn-warning btn-sm"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#editModal"
                                                        onclick="loadClientData(
                                                            ${c.clientId},
                                                            '${c.fullName}',
                                                            '${c.documentType}',
                                                            '${c.documentNumber}',
                                                            '${c.email}',
                                                            '${c.phone}',
                                                            '${c.address}',
                                                            '${c.companyName}'
                                                        )">
                                                    Editar
                                                </button>

                                                <button class="btn btn-danger btn-sm"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#deleteModal"
                                                        onclick="setDeleteId(${c.clientId})">
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
        </div>


        <!-- MODAL EDITAR -->
        <div class="modal fade" id="editModal" tabindex="-1">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-warning text-dark">
                        <h5 class="modal-title">Editar Cliente</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <form action="<%= request.getContextPath() %>/clients" method="post">

                        <div class="modal-body">

                            <input type="hidden" name="clientId" id="editClientId">
                            <input type="hidden" name="action" value="update">

                            <div class="row g-2">

                                <div class="col-md-4">
                                    <input id="editFullName" name="fullName" class="form-control" placeholder="Nombre completo" required="true">
                                </div>

                                <div class="col-md-2">
                                    <select id="editDocumentType" name="documentType" class="form-control" required="true">
                                        <option value="DNI">DNI</option>
                                        <option value="RUC">RUC</option>
                                    </select>
                                </div>

                                <div class="col-md-3">
                                    <input type="number" id="editDocumentNumber" name="documentNumber" class="form-control" required="true">
                                </div>

                                <div class="col-md-3">
                                    <input type="number" id="editPhone" name="phone" class="form-control" required="true">
                                </div>

                                <div class="col-md-4">
                                    <input type="email" id="editEmail" name="email" class="form-control" required="true">
                                </div>

                                <div class="col-md-4">
                                    <input id="editCompanyName" name="companyName" class="form-control" placeholder="Empresa(Opcional)">
                                </div>

                                <div class="col-md-4">
                                    <input id="editAddress" name="address" class="form-control" required="true">
                                </div>

                            </div>

                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-secondary" type="button" data-bs-dismiss="modal">Cancelar</button>
                            <button class="btn btn-warning" type="submit">Guardar cambios</button>
                        </div>

                    </form>

                </div>
            </div>
        </div>

        <!-- MODAL ELIMINAR -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">

                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Confirmar eliminación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body text-center">
                        <p>¿Estás seguro que deseas eliminar este cliente?</p>
                        <small class="text-muted">Esta acción no eliminará los datos permanentemente.</small>
                    </div>

                    <div class="modal-footer">
                        <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>

                        <a id="confirmDeleteBtn" class="btn btn-danger">
                            Sí, eliminar
                        </a>
                    </div>

                </div>
            </div>
        </div>       
        <script src="<%= request.getContextPath() %>/assets/js/clients.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- NOTIFICACION PARA MOSTRAR MENSAJE DE ERROR -->
        <c:if test="${not empty error}">
            <div class="toast-container position-fixed bottom-0 end-0 p-3">
                <div id="errorToast" class="toast align-items-center text-white bg-danger border-0">
                    <div class="d-flex">
                        <div class="toast-body">
                            ${error}
                        </div>

                        <button type="button" class="btn-close btn-close-white me-2 m-auto"
                                data-bs-dismiss="toast"></button>
                    </div>
                </div>
            </div>
            <script>
                const toast = new bootstrap.Toast(document.getElementById('errorToast'));
                toast.show();
            </script>
        </c:if>
    </body>
</html>
