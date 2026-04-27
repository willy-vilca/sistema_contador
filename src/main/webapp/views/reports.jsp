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
        <script src="https://cdn.jsdelivr.net/npm/jspdf@2.5.1/dist/jspdf.umd.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/jspdf-autotable@3.8.2/dist/jspdf.plugin.autotable.min.js"></script>
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
                    <form method="get" action="<%= request.getContextPath() %>/reports" class="row g-2 mb-2" id="reportForm">

                        <div class="col-md-2">
                            <select name="clientId" class="form-control border border-dark-subtle">
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
                                    <input type="date" name="startDate" value="${startDate}" class="form-control border border-dark-subtle" required>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-3">
                            <div class="row g-3 align-items-center">
                                <div class="col-auto">
                                  <label class="col-form-label fw-bold">Fecha Final: </label>
                                </div>
                                <div class="col-auto">
                                  <input type="date" name="endDate" value="${endDate}" class="form-control border border-dark-subtle" required>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Generar reporte</button>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" name="action" value="download" class="btn btn-outline-danger w-100">Descargar PDF</button>
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

                                    <tbody id="movementsTableBody">
                                        <c:forEach var="m" items="${movements}">
                                            <tr>
                                                <td>
                                                    <span class="badge 
                                                        ${m.type == 'INGRESO' ? 'bg-success' : 'bg-danger'}">
                                                        ${m.type}
                                                    </span>
                                                </td>
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

                                <tbody id="categoriesTableBody">
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
            //Funcion para agregar los datos a los gráficos
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
            //funcionalidad del menú hamburguesa
            function toggleSidebar() {
                document.querySelector('.sidebar').classList.toggle('active');
                document.querySelector('.sidebar-overlay').classList.toggle('active');
            }
        </script>
        
        <script>
            (function () {
                const form = document.getElementById('reportForm');

                if (!form) {
                    return;
                }

                form.addEventListener('submit', function (event) {
                    if (!event.submitter || event.submitter.name !== 'action' || event.submitter.value !== 'download') {
                        return;
                    }

                    event.preventDefault();
                    downloadVisibleReport();
                });

                function downloadVisibleReport() {
                    const reportData = collectReportData();
                    exportPdf(reportData);
                }

                function collectReportData() {
                    const clientSelect = form.querySelector('[name="clientId"]');
                    const selectedOption = clientSelect.options[clientSelect.selectedIndex];
                    const clientName = selectedOption ? selectedOption.text.trim() : 'Cliente';
                    const startDate = form.querySelector('[name="startDate"]').value;
                    const endDate = form.querySelector('[name="endDate"]').value;
                    const summaries = Array.from(document.querySelectorAll('.report-card')).map(function (card) {
                        const label = card.querySelector('h5') ? card.querySelector('h5').textContent.trim() : '';
                        const value = card.querySelector('h3') ? card.querySelector('h3').textContent.trim() : '';
                        return [label, value];
                    });

                    return {
                        clientName: clientName,
                        startDate: startDate,
                        endDate: endDate,
                        summaries: summaries,
                        movements: readTableRows('movementsTableBody'),
                        categories: readTableRows('categoriesTableBody'),
                        pieChartImage: readChartImage('pieChart'),
                        barChartImage: readChartImage('barChart')
                    };
                }

                function readTableRows(bodyId) {
                    return Array.from(document.querySelectorAll('#' + bodyId + ' tr')).map(function (row) {
                        return Array.from(row.querySelectorAll('td')).map(function (cell) {
                            return cell.textContent.trim();
                        });
                    });
                }

                function readChartImage(chartId) {
                    const chart = document.getElementById(chartId);
                    return chart ? chart.toDataURL('image/png', 1.0) : null;
                }

                function exportPdf(reportData) {
                    const jsPDF = window.jspdf.jsPDF;
                    const doc = new jsPDF({ unit: 'mm', format: 'a4' });
                    const pageWidth = doc.internal.pageSize.getWidth();
                    const pageHeight = doc.internal.pageSize.getHeight();
                    const margin = 14;
                    const contentWidth = pageWidth - (margin * 2);
                    const accentColor = [33, 150, 243];
                    const darkColor = [31, 41, 55];
                    const mutedColor = [107, 114, 128];
                    const summaryColors = [[40, 167, 69], [220, 53, 69], [76, 161, 175]];

                    addHeader();
                    addSummaryCards(reportData.summaries);
                    addSectionTitle('Graficos principales', 88);
                    addCharts(reportData);
                    addMovementTable(reportData);
                    addCategoryTable(reportData);
                    addFooter();

                    doc.save(buildFileName(reportData.clientName, 'pdf'));

                    function addHeader() {
                        doc.setFillColor(accentColor[0], accentColor[1], accentColor[2]);
                        doc.roundedRect(margin, 12, contentWidth, 28, 3, 3, 'F');
                        doc.setTextColor(255, 255, 255);
                        doc.setFont('helvetica', 'bold');
                        doc.setFontSize(20);
                        doc.text('Reporte financiero del cliente', margin + 4, 23);
                        doc.setFont('helvetica', 'normal');
                        doc.setFontSize(10);
                        doc.text('Cliente: ' + reportData.clientName, margin + 4, 31);
                        doc.text('Periodo: ' + reportData.startDate + ' al ' + reportData.endDate, margin + 4, 36);
                        doc.setTextColor(darkColor[0], darkColor[1], darkColor[2]);
                    }

                    function addSummaryCards(summaries) {
                        const cardWidth = (contentWidth - 8) / 3;
                        const cardY = 48;

                        summaries.forEach(function (item, index) {
                            const cardX = margin + (index * (cardWidth + 4));
                            const color = summaryColors[index] || accentColor;

                            doc.setFillColor(color[0], color[1], color[2]);
                            doc.roundedRect(cardX, cardY, cardWidth, 24, 3, 3, 'F');
                            doc.setTextColor(255, 255, 255);
                            doc.setFont('helvetica', 'bold');
                            doc.setFontSize(11);
                            doc.text(item[0], cardX + 4, cardY + 8);
                            doc.setFontSize(14);
                            doc.text(item[1], cardX + 4, cardY + 17);
                        });

                        doc.setTextColor(darkColor[0], darkColor[1], darkColor[2]);
                    }

                    function addSectionTitle(title, y) {
                        doc.setFillColor(239, 246, 255);
                        doc.roundedRect(margin, y, contentWidth, 9, 2, 2, 'F');
                        doc.setFont('helvetica', 'bold');
                        doc.setFontSize(12);
                        doc.setTextColor(accentColor[0], accentColor[1], accentColor[2]);
                        doc.text(title, margin + 4, y + 6);
                        doc.setTextColor(darkColor[0], darkColor[1], darkColor[2]);
                    }

                    function addCharts(data) {
                        const chartY = 101;
                        doc.setFont('helvetica', 'bold');
                        doc.setFontSize(10);

                        if (data.pieChartImage) {
                            doc.text('Ingresos vs gastos', margin, chartY);
                            doc.addImage(data.pieChartImage, 'PNG', margin, chartY + 4, 62, 62);
                        }

                        if (data.barChartImage) {
                            doc.text('Movimientos por categoria', margin + 72, chartY);
                            doc.addImage(data.barChartImage, 'PNG', margin + 72, chartY + 4, 110, 62);
                        }
                    }

                    function addMovementTable(data) {
                        addSectionTitle('Resumen de movimientos', 172);
                        doc.autoTable({
                            startY: 184,
                            head: [['Tipo', 'Monto', 'Fecha', 'Descripcion']],
                            body: data.movements.length ? data.movements : [['Sin movimientos', '-', '-', '-']],
                            margin: { left: margin, right: margin },
                            styles: { fontSize: 9, cellPadding: 3, textColor: darkColor },
                            headStyles: { fillColor: accentColor, textColor: [255, 255, 255], fontStyle: 'bold' },
                            alternateRowStyles: { fillColor: [248, 250, 252] },
                            bodyStyles: { valign: 'middle' }
                        });
                    }

                    function addCategoryTable(data) {
                        const nextY = doc.lastAutoTable.finalY + 10;

                        if (nextY > pageHeight - 45) {
                            doc.addPage();
                            addSectionTitle('Resumen de movimientos por categoria', 20);
                            renderCategoryTable(32, data);
                            return;
                        }

                        addSectionTitle('Resumen de movimientos por categoria', nextY);
                        renderCategoryTable(nextY + 12, data);
                    }

                    function renderCategoryTable(startY, data) {
                        doc.autoTable({
                            startY: startY,
                            head: [['Categoria', 'Total']],
                            body: data.categories.length ? data.categories : [['Sin categorias', '-']],
                            margin: { left: margin, right: margin },
                            styles: { fontSize: 9, cellPadding: 3, textColor: darkColor },
                            headStyles: { fillColor: [76, 161, 175], textColor: [255, 255, 255], fontStyle: 'bold' },
                            alternateRowStyles: { fillColor: [248, 250, 252] }
                        });
                    }

                    function addFooter() {
                        const pageCount = doc.getNumberOfPages();

                        for (let page = 1; page <= pageCount; page++) {
                            doc.setPage(page);
                            doc.setDrawColor(226, 232, 240);
                            doc.line(margin, pageHeight - 10, pageWidth - margin, pageHeight - 10);
                            doc.setFont('helvetica', 'normal');
                            doc.setFontSize(8);
                            doc.setTextColor(mutedColor[0], mutedColor[1], mutedColor[2]);
                            doc.text('Sistema Contador', margin, pageHeight - 6);
                            doc.text('Pagina ' + page + ' de ' + pageCount, pageWidth - margin - 22, pageHeight - 6);
                        }
                    }
                }

                function buildFileName(clientName, extension) {
                    const safeName = (clientName || 'cliente')
                        .normalize('NFD')
                        .replace(/[\u0300-\u036f]/g, '')
                        .replace(/[^a-zA-Z0-9-_]+/g, '-')
                        .replace(/-+/g, '-')
                        .replace(/^-|-$/g, '')
                        .toLowerCase();

                    return 'reporte-' + (safeName || 'cliente') + '.' + extension;
                }
            }());
        </script>
    </body>
</html>
