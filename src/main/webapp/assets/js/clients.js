//Función para el boton de confirmacion al eliminar un cliente
function setDeleteId(id) {
    const btn = document.getElementById("confirmDeleteBtn");
    btn.href = "http://localhost:8080/SistemaContador/deleteClient?id=" + id;
}

//cargar data en el form de modificar cliente
function loadClientData(id, name, docType, docNum, email, phone, address, company) {
document.getElementById("editClientId").value = id;
document.getElementById("editFullName").value = name;
document.getElementById("editDocumentType").value = docType;
document.getElementById("editDocumentNumber").value = docNum;
document.getElementById("editEmail").value = email;
document.getElementById("editPhone").value = phone;
document.getElementById("editAddress").value = address;
document.getElementById("editCompanyName").value = company;
}

//funcionalidad del menú hamburguesa
function toggleSidebar() {
    document.querySelector('.sidebar').classList.toggle('active');
    document.querySelector('.sidebar-overlay').classList.toggle('active');
}


