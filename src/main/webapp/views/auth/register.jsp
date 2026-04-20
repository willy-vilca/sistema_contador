<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Registro - Sistema Contable</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/login.css">
    </head>

    <body>

        <div class="container login-container d-flex justify-content-center align-items-center">

            <div class="card shadow-lg login-card" style="width: 900px;">
                <div class="row g-0">

                    <!-- PANEL IZQUIERDO -->
                    <div class="col-md-6 left-panel d-flex flex-column justify-content-center">
                        <h2>Únete al sistema</h2>
                        <p class="mt-3">
                            Crea tu cuenta y comienza a gestionar tu información contable de manera eficiente.
                        </p>

                        <hr class="bg-light">

                        <p>
                            ✔ Control total de clientes<br>
                            ✔ Registro de ingresos y gastos<br>
                            ✔ Reportes profesionales
                        </p>
                    </div>

                    <!-- FORMULARIO -->
                    <div class="col-md-6 p-4 bg-white">

                        <h3 class="text-center mb-4">Crear cuenta</h3>

                        <form action="<%= request.getContextPath() %>/register" method="post">

                            <div class="mb-3">
                                <label>Nombre completo</label>
                                <input type="text" name="fullName" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label>Correo</label>
                                <input type="email" name="email" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label>Contraseña</label>
                                <input type="password" name="password" class="form-control" required>
                            </div>

                            <div class="mb-3">
                                <label>Confirmar contraseña</label>
                                <input type="password" name="confirmPassword" class="form-control" required>
                            </div>

                            <button class="btn btn-primary w-100">Registrarse</button>

                            <!-- ERROR -->
                            <%
                                String error = (String) request.getAttribute("error");
                                if (error != null) {
                            %>
                                <div class="alert alert-danger mt-3 text-center">
                                    <%= error %>
                                </div>
                            <%
                                }
                            %>

                            <!-- LINK LOGIN -->
                            <div class="text-center mt-3">
                                <small>
                                    ¿Ya tienes cuenta? 
                                    <a href="<%= request.getContextPath() %>/views/auth/login.jsp">
                                        Inicia sesión
                                    </a>
                                </small>
                            </div>

                        </form>

                    </div>

                </div>
            </div>

        </div>

    </body>
</html>