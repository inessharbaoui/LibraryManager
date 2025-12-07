<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Etudiant" %>
<%
    List<Etudiant> etudiants = (List<Etudiant>) request.getAttribute("etudiants");
    Etudiant edit = (Etudiant) request.getAttribute("editEtudiant");
    String message = (String) request.getAttribute("message");
    
    // Pagination attributes
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    String searchQuery = (String) request.getAttribute("searchQuery");
    
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
%>

<html>
<head>
    <title>Gestion des étudiants</title>
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
            text-decoration: none;
        }

        .refresh-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(195, 224, 252, 0.4);
            background: linear-gradient(135deg, #b3d6f7 0%, #98ccff 100%);
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

        .form-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            margin-bottom: 25px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
            border: 2px solid rgba(255, 255, 255, 0.8);
        }

        .form-section h3 {
            color: #6b5b95;
            margin-bottom: 20px;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            color: #6b5b95;
            font-weight: 600;
            font-size: 14px;
        }

        .form-group input {
            padding: 12px 15px;
            border: 2px solid #e0c3fc;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #faf8ff;
            color: #6b5b95;
        }

        .form-group input:focus {
            outline: none;
            border-color: #b8a4e8;
            background: white;
            box-shadow: 0 0 0 4px rgba(184, 164, 232, 0.15);
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .btn {
            padding: 12px 28px;
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

        .btn-primary {
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            color: #6b5b95;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(224, 195, 252, 0.4);
            background: linear-gradient(135deg, #d4b3f0 0%, #ffcce0 100%);
        }

        .btn-secondary {
            background: #f0f0f0;
            color: #6b5b95;
        }

        .btn-secondary:hover {
            background: #e0e0e0;
            transform: translateY(-2px);
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

        .action-links {
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .action-links a {
            text-decoration: none;
            color: #6b5b95;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 500;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .action-links a.edit {
            background: #e3f2fd;
            color: #1976d2;
        }

        .action-links a.edit:hover {
            background: #bbdefb;
            transform: translateY(-1px);
        }

        .action-links a.delete {
            background: #ffebee;
            color: #d32f2f;
        }

        .action-links a.delete:hover {
            background: #ffcdd2;
            transform: translateY(-1px);
        }

        .pagination {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
            border: 2px solid rgba(255, 255, 255, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .pagination a,
        .pagination span {
            padding: 10px 16px;
            border-radius: 8px;
            text-decoration: none;
            color: #6b5b95;
            background: #faf8ff;
            border: 2px solid #e0c3fc;
            transition: all 0.3s ease;
            font-weight: 500;
            min-width: 40px;
            text-align: center;
        }

        .pagination a:hover {
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(224, 195, 252, 0.3);
        }

        .pagination .current-page {
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            font-weight: 700;
            border-color: #d4b3f0;
        }

        .pagination .disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }

        .pagination-info {
            color: #6b5b95;
            font-size: 14px;
            margin: 0 10px;
        }

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                align-items: stretch;
            }

            .page-header h2 {
                font-size: 24px;
            }

            .refresh-btn {
                width: 100%;
                justify-content: center;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-actions {
                flex-direction: column;
            }

            .btn {
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

            .action-links {
                flex-direction: column;
                gap: 5px;
            }

            .action-links a {
                width: 100%;
                justify-content: center;
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
        <h2><i class="fas fa-users-cog"></i> Gestion des étudiants</h2>
        <a href="EtudiantServlet" class="refresh-btn">
            <i class="fas fa-sync-alt"></i>
            Rafraîchir
        </a>
    </div>

    <% if (message != null && !message.isEmpty()) { %>
        <div class="message-box <%= message.contains("Erreur") ? "error" : "success" %>">
            <i class="fas fa-<%= message.contains("Erreur") ? "exclamation-circle" : "check-circle" %>"></i>
            <%= message %>
        </div>
    <% } %>

    <!-- Add/Edit Form -->
    <div class="form-section">
        <h3>
            <i class="fas fa-<%= (edit != null) ? "edit" : "plus-circle" %>"></i>
            <%= (edit != null) ? "Modifier l'étudiant" : "Ajouter un étudiant" %>
        </h3>
        <form action="${pageContext.request.contextPath}/EtudiantServlet" method="post">
            <input type="hidden" name="idPers" value="<%= (edit != null) ? edit.getIdPers() : "" %>">

            <div class="form-grid">
                <div class="form-group">
                    <label for="nom">Nom *</label>
                    <input type="text" id="nom" name="nom" value="<%= (edit != null) ? edit.getNom() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="prenom">Prénom *</label>
                    <input type="text" id="prenom" name="prenom" value="<%= (edit != null) ? edit.getPrenom() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" value="<%= (edit != null) ? edit.getEmail() : "" %>" required>
                </div>

                <div class="form-group">
                    <label for="adresse">Adresse</label>
                    <input type="text" id="adresse" name="adresse" value="<%= (edit != null) ? edit.getAdresse() : "" %>">
                </div>

                <div class="form-group">
                    <label for="telephone">Téléphone</label>
                    <input type="text" id="telephone" name="telephone" value="<%= (edit != null) ? edit.getTelephone() : "" %>">
                </div>

                <div class="form-group">
                    <label for="classe">Classe</label>
                    <input type="text" id="classe" name="classe" value="<%= (edit != null) ? edit.getClasse() : "" %>">
                </div>
            </div>

            <div class="form-actions">
                <% if (edit != null) { %>
                    <a href="EtudiantServlet" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Annuler
                    </a>
                <% } %>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-<%= (edit != null) ? "save" : "plus" %>"></i>
                    <%= (edit != null) ? "Modifier" : "Ajouter" %>
                </button>
            </div>
        </form>
    </div>

    <!-- Search form -->
    <div class="search-section">
        <form action="EtudiantServlet" method="get">
            <input type="text" name="search" placeholder="Nom, Prénom ou Classe" value="<%= searchQuery != null ? searchQuery : "" %>">
            <input type="submit" value="Rechercher">
        </form>
    </div>

    <!-- Students Table -->
    <div class="table-section">
        <table>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Email</th>
            <th>Adresse</th>
            <th>Téléphone</th>
            <th>Classe</th>
            <th>Actions</th>
        </tr>

        <%
        if (etudiants != null && !etudiants.isEmpty()) {
            for (Etudiant e : etudiants) {
        %>
        <tr>
            <td><%= e.getIdPers() %></td>
            <td><%= e.getNom() %></td>
            <td><%= e.getPrenom() %></td>
            <td><%= e.getEmail() %></td>
            <td><%= e.getAdresse() %></td>
            <td><%= e.getTelephone() %></td>
            <td><%= e.getClasse() %></td>
            <td>
                <div class="action-links">
                    <a href="EtudiantServlet?action=edit&id=<%= e.getIdPers() %>" class="edit">
                        <i class="fas fa-edit"></i> Modifier
                    </a>
                    <a href="EtudiantServlet?action=delete&id=<%= e.getIdPers() %>" 
                       class="delete"
                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet étudiant ?')">
                        <i class="fas fa-trash"></i> Supprimer
                    </a>
                </div>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="8" style="text-align: center; padding: 30px; color: #999;">
                <i class="fas fa-inbox" style="font-size: 40px; display: block; margin-bottom: 10px;"></i>
                Aucun étudiant trouvé
            </td>
        </tr>
        <%
        }
        %>

        </table>
    </div>

    <!-- Pagination -->
    <% if (totalPages > 1) { %>
    <div class="pagination">
        <!-- Previous button -->
        <% if (currentPage > 1) { %>
            <a href="EtudiantServlet?page=<%= currentPage - 1 %><%= searchQuery != null ? "&search=" + searchQuery : "" %>">
                <i class="fas fa-chevron-left"></i>
            </a>
        <% } else { %>
            <span class="disabled"><i class="fas fa-chevron-left"></i></span>
        <% } %>

        <!-- Page numbers -->
        <% 
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, currentPage + 2);
        
        if (startPage > 1) { %>
            <a href="EtudiantServlet?page=1<%= searchQuery != null ? "&search=" + searchQuery : "" %>">1</a>
            <% if (startPage > 2) { %>
                <span>...</span>
            <% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
            <% if (i == currentPage) { %>
                <span class="current-page"><%= i %></span>
            <% } else { %>
                <a href="EtudiantServlet?page=<%= i %><%= searchQuery != null ? "&search=" + searchQuery : "" %>"><%= i %></a>
            <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
            <% if (endPage < totalPages - 1) { %>
                <span>...</span>
            <% } %>
            <a href="EtudiantServlet?page=<%= totalPages %><%= searchQuery != null ? "&search=" + searchQuery : "" %>"><%= totalPages %></a>
        <% } %>

        <!-- Next button -->
        <% if (currentPage < totalPages) { %>
            <a href="EtudiantServlet?page=<%= currentPage + 1 %><%= searchQuery != null ? "&search=" + searchQuery : "" %>">
                <i class="fas fa-chevron-right"></i>
            </a>
        <% } else { %>
            <span class="disabled"><i class="fas fa-chevron-right"></i></span>
        <% } %>

        <span class="pagination-info">Page <%= currentPage %> sur <%= totalPages %></span>
    </div>
    <% } %>
</div>
<a href="javascript:history.back()" class="back-link">
    <i class="fas fa-arrow-left"></i>
                Retour

</a>
</body>
</html>