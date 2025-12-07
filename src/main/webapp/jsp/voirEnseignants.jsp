<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Enseignant" %>
<%
    List<Enseignant> enseignants = (List<Enseignant>) request.getAttribute("enseignants");
    String message = (String) request.getAttribute("message");
    
    // Pagination variables
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer totalRecords = (Integer) request.getAttribute("totalRecords");
    
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (totalRecords == null) totalRecords = (enseignants != null) ? enseignants.size() : 0;
    
    String searchQuery = request.getParameter("search");
    if (searchQuery == null) searchQuery = "";
%>

<html>
<head>
    <title>Liste des enseignants</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #ffd6e8 0%, #e0c3fc 50%, #c3e0fc 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .page-wrapper {
            max-width: 1400px;
            margin: 0 auto;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .page-header {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px 35px;
            margin-bottom: 25px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .page-header h2 {
            font-size: 28px;
            color: #6b5b95;
            display: flex;
            align-items: center;
            gap: 12px;
        }
.refresh-btn {
            padding: 12px 24px;
            background: linear-gradient(135deg, #c3e0fc 0%, #a8d5ff 100%);
            color: #4a7ba7;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .refresh-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(195, 224, 252, 0.4);
            background: linear-gradient(135deg, #b3d6f7 0%, #98ccff 100%);
        }

        .refresh-btn:active {
            transform: translateY(0);
        }

        .refresh-btn i {
            transition: transform 0.3s ease;
        }

        .refresh-btn:hover i {
            transform: rotate(180deg);
        }


        .message-box {
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.5s ease;
        }

        .message-box.success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .message-box.error {
            background: #ffe0e6;
            color: #d64d6d;
            border-left: 4px solid #ffb3c6;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .search-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
            border: 2px solid rgba(255, 255, 255, 0.8);
        }

        .search-section form {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .search-section input[type="text"] {
            flex: 1;
            min-width: 250px;
            padding: 12px 15px;
            border: 2px solid #e0c3fc;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #faf8ff;
            color: #6b5b95;
        }

        .search-section input[type="text"]:focus {
            outline: none;
            border-color: #b8a4e8;
            background: white;
            box-shadow: 0 0 0 4px rgba(184, 164, 232, 0.15);
        }

        .search-section input[type="submit"] {
            padding: 12px 28px;
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            color: #6b5b95;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .search-section input[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(224, 195, 252, 0.4);
            background: linear-gradient(135deg, #d4b3f0 0%, #ffcce0 100%);
        }

        .table-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.8);
            overflow-x: auto;
        }

        .records-info {
            margin-bottom: 20px;
            color: #6b5b95;
            font-size: 14px;
            font-weight: 500;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
        }

        table th {
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            color: #6b5b95;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            border: none;
        }

        table td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            color: #6b5b95;
            font-size: 14px;
            border: none;
        }

        table tr:last-child td {
            border-bottom: none;
        }

        table tr:hover {
            background: #faf8ff;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-top: 25px;
            flex-wrap: wrap;
        }

        .pagination a,
        .pagination span {
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            color: #6b5b95;
            background: rgba(224, 195, 252, 0.3);
            border: 2px solid transparent;
            transition: all 0.3s ease;
            font-weight: 500;
            font-size: 14px;
        }

        .pagination a:hover {
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(224, 195, 252, 0.4);
        }

        .pagination .active {
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            border-color: #d4b3f0;
            font-weight: 700;
        }

        .pagination .disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .pagination-info {
            color: #6b5b95;
            font-size: 14px;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: flex-start;
            }

            .refresh-btn {
                width: 100%;
                justify-content: center;
            }

            .search-section form {
                flex-direction: column;
            }

            .search-section input[type="text"] {
                width: 100%;
            }

            .search-section input[type="submit"] {
                width: 100%;
            }

            .table-section {
                padding: 20px 15px;
            }

            table {
                font-size: 12px;
            }

            table th, table td {
                padding: 10px 8px;
            }

            .pagination {
                gap: 5px;
            }

            .pagination a,
            .pagination span {
                padding: 8px 12px;
                font-size: 13px;
            }
        }
        
        
        
        
        .refresh-btn,
.refresh-btn:visited,
.refresh-btn:hover,
.refresh-btn:active {
    text-decoration: none !important;
}
    
    
    
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            background: white;
            color: #6b5b95;
            border: 2px solid #e0c3fc;
            border-radius: 10px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .back-link:hover {
            background: #faf8ff;
            border-color: #b8a4e8;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(224, 195, 252, 0.3);
        }    
    </style>
</head>
<body>

<div class="page-wrapper">
    <div class="page-header">
        <h2><i class="fas fa-chalkboard-teacher"></i> Liste des enseignants</h2>
        <a href="EnseignantServlet" class="refresh-btn">
            <i class="fas fa-sync-alt"></i> Rafraîchir
        </a>
    </div>

    <% if (message != null && !message.isEmpty()) { %>
        <div class="message-box <%= message.contains("Erreur") ? "error" : "success" %>">
            <i class="fas fa-<%= message.contains("Erreur") ? "exclamation-circle" : "check-circle" %>"></i>
            <%= message %>
        </div>
    <% } %>

    <!-- Search form -->
    <div class="search-section">
        <form action="EnseignantServlet" method="get">
            <input type="text" name="search" placeholder="Nom, Grade ou Département" value="<%= searchQuery %>">
            <input type="submit" value="Rechercher">
        </form>
    </div>

    <div class="table-section">
        <div class="records-info">
            <i class="fas fa-info-circle"></i> 
            Total: <%= totalRecords %> enseignant(s) | Page <%= currentPage %> sur <%= totalPages %>
        </div>

        <table border="1">
        <tr>
            <th>ID</th><th>Nom</th><th>Prénom</th><th>Email</th><th>Adresse</th><th>Téléphone</th><th>Grade</th><th>Département</th>
        </tr>

        <%
        if (enseignants != null && !enseignants.isEmpty()) {
            for (Enseignant e : enseignants) {
        %>
        <tr>
            <td><%= e.getIdPers() %></td>
            <td><%= e.getNom() %></td>
            <td><%= e.getPrenom() %></td>
            <td><%= e.getEmail() %></td>
            <td><%= e.getAdresse() %></td>
            <td><%= e.getTelephone() %></td>
            <td><%= e.getGrade() %></td>
            <td><%= e.getDepartement() %></td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="8" style="text-align: center; padding: 30px; color: #999;">
                <i class="fas fa-inbox"></i><br><br>
                Aucun enseignant trouvé
            </td>
        </tr>
        <%
        }
        %>
        </table>

        <!-- Pagination -->
        <% if (totalPages > 1) { %>
        <div class="pagination">
            <!-- Previous button -->
            <% if (currentPage > 1) { %>
                <a href="EnseignantServlet?page=<%= currentPage - 1 %><%= !searchQuery.isEmpty() ? "&search=" + searchQuery : "" %>">
                    <i class="fas fa-chevron-left"></i> Précédent
                </a>
            <% } else { %>
                <span class="disabled">
                    <i class="fas fa-chevron-left"></i> Précédent
                </span>
            <% } %>

            <!-- Page numbers -->
            <%
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                
                if (startPage > 1) {
            %>
                <a href="EnseignantServlet?page=1<%= !searchQuery.isEmpty() ? "&search=" + searchQuery : "" %>">1</a>
                <% if (startPage > 2) { %>
                    <span>...</span>
                <% } %>
            <% } %>

            <% for (int i = startPage; i <= endPage; i++) { %>
                <% if (i == currentPage) { %>
                    <span class="active"><%= i %></span>
                <% } else { %>
                    <a href="EnseignantServlet?page=<%= i %><%= !searchQuery.isEmpty() ? "&search=" + searchQuery : "" %>"><%= i %></a>
                <% } %>
            <% } %>

            <%
                if (endPage < totalPages) {
                    if (endPage < totalPages - 1) {
            %>
                    <span>...</span>
            <%      } %>
                <a href="EnseignantServlet?page=<%= totalPages %><%= !searchQuery.isEmpty() ? "&search=" + searchQuery : "" %>"><%= totalPages %></a>
            <% } %>

            <!-- Next button -->
            <% if (currentPage < totalPages) { %>
                <a href="EnseignantServlet?page=<%= currentPage + 1 %><%= !searchQuery.isEmpty() ? "&search=" + searchQuery : "" %>">
                    Suivant <i class="fas fa-chevron-right"></i>
                </a>
            <% } else { %>
                <span class="disabled">
                    Suivant <i class="fas fa-chevron-right"></i>
                </span>
            <% } %>
        </div>
        <% } %>
    </div>
</div>


<a href="javascript:history.back()" class="back-link">
    <i class="fas fa-arrow-left"></i>
                Retour

</a>
</body>
</html>