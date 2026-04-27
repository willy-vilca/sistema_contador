<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Movimientos</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
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
                                <select name="clientId" onchange="this.form.submit()" class="form-control w-auto mb-3 border border-dark-subtle">
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
                                <select name="type" class="form-control border border-dark-subtle">
                                    <option value="INGRESO">Ingreso</option>
                                    <option value="GASTO">Gasto</option>
                                </select>
                            </div>

                            <div class="col-md-2">
                                <input type="number" step="0.5" min="0.5" name="amount" class="form-control border border-dark-subtle" placeholder="Monto" required="true">
                            </div>

                            <div class="col-md-3">
                                <div class="input-group">
                                    <select name="categoryId" class="form-control border border-dark-subtle" required>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}">
                                                ${cat.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <!-- BOTÓN PARA AGREGAR CATEGORIAS -->
                                    <button type="button" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#categoryModal" title="Gestionar Categorías">
                                        +
                                    </button>
                                </div>
                            </div>

                            <div class="col-md-2">
                                <input type="date" name="date" class="form-control border border-dark-subtle" required="true">
                            </div>

                            <div class="col-md-3">
                                <input name="description" class="form-control border border-dark-subtle" placeholder="Descripción" required="true">
                            </div>

                            <div class="col-md-2 mt-3">
                                <button class="btn btn-primary w-100">Agregar</button>
                            </div>

                        </form>
                    </div>   
                    
                    <!-- FILTRO DE MOVIMIENTOS -->       
                    <div class="card p-3 mb-3 shadow-sm">
                        <h5 class="mb-3">Filtrar Movimientos</h5>
                        <div class="row g-2">
                            <!-- FILTRO TIPO -->
                            <div class="col-md-2 me-5">
                                <label class="fw-bold">Por Tipo:</label>
                                <select id="filterType" class="form-control border border-dark-subtle">
                                    <option value="ALL">Todos</option>
                                    <option value="INGRESO">Ingresos</option>
                                    <option value="GASTO">Gastos</option>
                                </select>
                            </div>
                            <!-- FILTRO CATEGORÍA -->
                            <div class="col-md-2">
                                <label class="fw-bold">Por Categoría:</label>
                                <select id="filterCategory" class="form-control border border-dark-subtle">
                                    <option value="ALL">Todas</option>

                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.categoryId}">
                                            ${cat.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
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
                                <tr class="movement-row" data-type="${m.type}" data-category="${m.categoryId}">
                                    <td>
                                        <span class="badge 
                                            ${m.type == 'INGRESO' ? 'bg-success' : 'bg-danger'}">
                                            ${m.type}
                                        </span>
                                    </td>
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
                            
        <!-- MODAL NUEVA CATEGORÍA -->
        <div class="modal fade" id="categoryModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Nueva Categoría</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="<%= request.getContextPath() %>/categories" method="post">
                        <input type="hidden" name="action" value="create">
                        <div class="modal-body">
                            <div class="mb-3">
                                <label>Nombre</label>
                                <input type="text" name="name" class="form-control" placeholder="Nombre de la nueva categoría..." required>
                            </div>
                            <div class="mb-3">
                                <label>Tipo</label>
                                <select name="type" class="form-control">
                                    <option value="INGRESO">INGRESO</option>
                                    <option value="GASTO">GASTO</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label>Descripción</label>
                                <input type="text" name="description" class="form-control" placeholder="(Opcional)">
                            </div>
                        </div>
                        <div class="modal-footer d-flex justify-content-between">
                            <!-- BOTÓN GESTIONAR CATEGORIAS -->
                            <button type="button" class="btn btn-outline-secondary"
                                    data-bs-dismiss="modal"
                                    data-bs-toggle="modal"
                                    data-bs-target="#manageCategoryModal">
                                Gestionar categorías
                            </button>
                            <div>
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                    Cancelar
                                </button>
                                <button type="submit" class="btn btn-primary">
                                    Guardar
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- MODAL GESTIONAR CATEGORIAS -->
        <div class="modal fade" id="manageCategoryModal" tabindex="-1">

            <div class="modal-dialog modal-lg modal-dialog-centered">

                <div class="modal-content">

                    <div class="modal-header bg-dark text-white">
                        <h5 class="modal-title">Gestionar Categorías</h5>
                        <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">

                        <div class="table-responsive-mobile">

                            <table class="table table-hover align-middle">

                                <thead class="table-light">
                                    <tr>
                                        <th>Nombre</th>
                                        <th>Tipo</th>
                                        <th>Descripción</th>
                                        <th class="text-center">Acciones</th>
                                    </tr>
                                </thead>

                                <tbody>

                                    <c:forEach var="cat" items="${categories}">

                                        <tr>
                                            <td>${cat.name}</td>
                                            <td>
                                                <span class="badge 
                                                    ${cat.type == 'INGRESO' ? 'bg-success' : 'bg-danger'}">
                                                    ${cat.type}
                                                </span>
                                            </td>
                                            <td>${cat.description}</td>

                                            <td class="text-center">

                                                <!-- EDITAR -->
                                                <button class="btn btn-sm btn-warning"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#editCategoryModal${cat.categoryId}">
                                                    <i class="bi bi-pencil"></i>
                                                </button>

                                                <!-- ELIMINAR -->
                                                <button class="btn btn-sm btn-danger"
                                                        data-bs-toggle="modal"
                                                        data-bs-target="#deleteCategoryModal${cat.categoryId}">
                                                    <i class="bi bi-trash3"></i>
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
        
        <!-- MODAL EDITAR CATEGORIAS -->
        <c:forEach var="cat" items="${categories}">

            <div class="modal fade" id="editCategoryModal${cat.categoryId}" tabindex="-1">

                <div class="modal-dialog modal-dialog-centered">

                    <div class="modal-content">

                        <div class="modal-header bg-warning">
                            <h5 class="modal-title">Editar Categoría</h5>
                            <button class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <form action="<%= request.getContextPath() %>/categories" method="post">

                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="categoryId" value="${cat.categoryId}">

                            <div class="modal-body">

                                <div class="mb-3">
                                    <label>Nombre</label>
                                    <input type="text" name="name" value="${cat.name}" class="form-control" required>
                                </div>

                                <div class="mb-3">
                                    <label>Tipo</label>
                                    <select name="type" class="form-control">
                                        <option value="INGRESO" ${cat.type == 'INGRESO' ? 'selected' : ''}>Ingreso</option>
                                        <option value="GASTO" ${cat.type == 'GASTO' ? 'selected' : ''}>Gasto</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label>Descripción</label>
                                    <input type="text" name="description" value="${cat.description}" class="form-control">
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
        </c:forEach>
        
        <!-- MODAL ELIMINAR CATEGORIAS -->
        <c:forEach var="cat" items="${categories}">

            <div class="modal fade" id="deleteCategoryModal${cat.categoryId}" tabindex="-1">

                <div class="modal-dialog modal-dialog-centered">

                    <div class="modal-content">

                        <div class="modal-header bg-danger text-white">
                            <h5 class="modal-title">Eliminar Categoría</h5>
                            <button class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body text-center">

                            <p>¿Seguro que deseas eliminar esta categoría?</p>
                            <strong>${cat.name}</strong>

                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>

                            <a href="<%= request.getContextPath() %>/categories?action=delete&id=${cat.categoryId}"
                               class="btn btn-danger">
                                Eliminar
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <script>
            document.addEventListener("DOMContentLoaded", function () {
                const typeFilter = document.getElementById("filterType");
                const categoryFilter = document.getElementById("filterCategory");
                const rows = document.querySelectorAll(".movement-row");

                function filterMovements() {
                    const selectedType = typeFilter.value;
                    const selectedCategory = categoryFilter.value;

                    rows.forEach(row => {
                        const rowType = row.getAttribute("data-type");
                        const rowCategory = row.getAttribute("data-category");
                        let show = true;
                        
                        // FILTRO TIPO
                        if (selectedType !== "ALL" && rowType !== selectedType) {
                            show = false;
                        }
                        // FILTRO CATEGORÍA
                        if (selectedCategory !== "ALL" && rowCategory !== selectedCategory) {
                            show = false;
                        }
                        // MOSTRAR / OCULTAR
                        row.style.display = show ? "" : "none";
                    });
                }

                // EVENTOS
                typeFilter.addEventListener("change", filterMovements);
                categoryFilter.addEventListener("change", filterMovements);
            });
        </script>

        <script src="<%= request.getContextPath() %>/assets/js/movements.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
