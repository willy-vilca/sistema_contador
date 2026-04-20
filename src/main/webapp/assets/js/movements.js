//Función para el boton de confirmacion al eliminar un movimiento
function setDeleteMovement(id, clientId) {
    const btn = document.getElementById("confirmDeleteMovement");
    btn.href = "http://localhost:8080/SistemaContador/deleteMovement?id=" + id + "&clientId=" + clientId;
}

//cargar data en el form de modificar movimiento
function loadMovementData(id, type, amount, date, description, categoryId) {
    document.getElementById("editId").value = id;
    document.getElementById("editType").value = type;
    document.getElementById("editAmount").value = amount;
    document.getElementById("editDate").value = date;
    document.getElementById("editDescription").value = description;
    document.getElementById("editCategory").value = categoryId;
}

//funcionalidad del menú hamburguesa
function toggleSidebar() {
    document.querySelector('.sidebar').classList.toggle('active');
    document.querySelector('.sidebar-overlay').classList.toggle('active');
}


