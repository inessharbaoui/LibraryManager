<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Livre" %>

<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("user");
    String typeUtilisateur = (String) session.getAttribute("typeUtilisateur");

    if (!"bibliothecaire".equals(typeUtilisateur) && !"admin".equals(typeUtilisateur)) {
        response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");
        return;
    }

    List<Livre> livres = (List<Livre>) request.getAttribute("livres");
    Livre editLivre = (Livre) request.getAttribute("editLivre");

    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>

<html>
<head>
    <title>Gestion des livres</title>
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
        }

        .header-content h2 {
            font-size: 28px;
            color: #6b5b95;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header-content p {
            font-size: 14px;
            color: #a393c9;
        }

        .header-content p b {
            color: #6b5b95;
        }

        .success-message {
            background: #d4edda;
            color: #155724;
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 4px solid #28a745;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.5s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .action-buttons {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 16px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
            border: 2px solid rgba(255, 255, 255, 0.8);
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .action-buttons input[type="button"],
        .action-buttons button {
            padding: 12px 24px;
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            color: #6b5b95;
            border: none;
            border-radius: 10px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .action-buttons input[type="button"]:hover,
        .action-buttons button:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(224, 195, 252, 0.4);
            background: linear-gradient(135deg, #d4b3f0 0%, #ffcce0 100%);
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
            font-size: 22px;
            color: #6b5b95;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .form-section form {
            display: grid;
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #6b5b95;
        }

        .form-group input[type="text"] {
            padding: 12px 15px;
            border: 2px solid #e0c3fc;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #faf8ff;
            color: #6b5b95;
        }

        .form-group input[type="text"]:focus {
            outline: none;
            border-color: #b8a4e8;
            background: white;
            box-shadow: 0 0 0 4px rgba(184, 164, 232, 0.15);
        }

        .form-group input[type="text"][readonly] {
            background: #f0f0f0;
            cursor: not-allowed;
        }

        .form-section input[type="submit"] {
            padding: 14px 28px;
            background: linear-gradient(135deg, #e0c3fc 0%, #ffd6e8 100%);
            color: #6b5b95;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            justify-self: start;
        }

        .form-section input[type="submit"]:hover {
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

        .table-section h3 {
            font-size: 22px;
            color: #6b5b95;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
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
        }

        table td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            color: #6b5b95;
            font-size: 14px;
        }

        table tr:last-child td {
            border-bottom: none;
        }

        table tr:hover {
            background: #faf8ff;
        }

        table td a {
            color: #8b7ba8;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
        }

        table td a:hover {
            color: #6b5b95;
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

        @media (max-width: 768px) {
            .page-header {
                flex-direction: column;
                gap: 15px;
                text-align: center;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons input[type="button"],
            .action-buttons button {
                width: 100%;
                justify-content: center;
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
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <div class="page-header">
        <div class="header-content">
            <h2><i class="fas fa-book"></i> Gestion des livres</h2>
            <p>Bonjour <b><%= userName %></b></p>
        </div>
    </div>

    <% if (message != null) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            <%= message %>
        </div>
    <% } %>

    <!-- Button to view reservations -->
    <!-- Buttons for bibliothécaire actions -->
<form style="margin-bottom:20px;">
    <div class="action-buttons">
        <input type="button" value="Voir les réservations"
               onclick="window.location.href='<%= request.getContextPath() %>/ReservationServlet'"/>

        <input type="button" value="Voir tous les emprunts"
               onclick="window.location.href='<%= request.getContextPath() %>/EmpruntServlet'"/>
    </div>
</form>


    <!-- Add/Edit form -->
    <div class="form-section">
        <h3>
            <i class="fas fa-<%= (editLivre != null) ? "edit" : "plus-circle" %>"></i>
            <%= (editLivre != null) ? "Modifier le livre" : "Ajouter un nouveau livre" %>
        </h3>
        <form method="post" action="<%= request.getContextPath() %>/LivreServlet">
            <input type="hidden" name="action" value="<%= (editLivre != null) ? "update" : "add" %>">
            
            <div class="form-group">
                <label>ISBN:</label>
                <input type="text" name="isbn" value="<%= (editLivre != null) ? editLivre.getISBN() : "" %>" 
                       <%= (editLivre != null) ? "readonly" : "" %> required>
            </div>
            
            <div class="form-group">
                <label>Titre:</label>
                <input type="text" name="titre" value="<%= (editLivre != null) ? editLivre.getTitre() : "" %>" required>
            </div>
            
            <div class="form-group">
                <label>Auteurs:</label>
                <input type="text" name="auteurs" value="<%= (editLivre != null) ? editLivre.getAuteurs() : "" %>" required>
            </div>
            
            <input type="submit" value="<%= (editLivre != null) ? "Mettre à jour" : "Ajouter" %>">
        </form>
    </div>

    <!-- Books list -->
    <div class="table-section">
        <h3><i class="fas fa-list"></i> Liste des livres</h3>
        <table border="1" cellpadding="5">
            <tr>
                <th>ISBN</th>
                <th>Titre</th>
                <th>Auteurs</th>
                <th>Actions</th>
            </tr>
        <%
            if (livres != null && !livres.isEmpty()) {
                for (Livre l : livres) {
        %>
            <tr>
                <td><%= l.getISBN() %></td>
                <td><%= l.getTitre() %></td>
                <td><%= l.getAuteurs() %></td>
                <td>
                    <a href="<%= request.getContextPath() %>/LivreServlet?action=edit&isbn=<%= l.getISBN() %>">Modifier</a> |
                    <a href="<%= request.getContextPath() %>/LivreServlet?action=delete&isbn=<%= l.getISBN() %>" 
                       onclick="return confirm('Voulez-vous vraiment supprimer ce livre ?');">Supprimer</a>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="4">Aucun livre trouvé</td>
            </tr>
        <%
            }
        %>
        </table>
    </div>

 <a href="javascript:history.back()" class="back-link">
    <i class="fas fa-arrow-left"></i>
    Retour
</a>

</div>
</body>
</html>