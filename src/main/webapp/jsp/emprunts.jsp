<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Emprunt" %>

<%
    // Secured session check
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    List<Emprunt> emprunts = (List<Emprunt>) request.getAttribute("emprunts");
    String message = (String) request.getAttribute("message");
%>

<html>
<head>
    <title>Gestion des emprunts</title>
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
        }

        .page-header h2 {
            font-size: 28px;
            color: #6b5b95;
            display: flex;
            align-items: center;
            gap: 12px;
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

        .form-section form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
            flex: 1;
            min-width: 200px;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 600;
            color: #6b5b95;
        }

        .form-group input[type="number"] {
            padding: 12px 15px;
            border: 2px solid #e0c3fc;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s ease;
            background: #faf8ff;
            color: #6b5b95;
        }

        .form-group input[type="number"]:focus {
            outline: none;
            border-color: #b8a4e8;
            background: white;
            box-shadow: 0 0 0 4px rgba(184, 164, 232, 0.15);
        }

        .form-section button {
            padding: 12px 28px;
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
        }

        .form-section button:hover {
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

        table td a {
            color: #8b7ba8;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.3s ease;
            display: inline-block;
            margin-right: 10px;
        }

        table td a:hover {
            color: #6b5b95;
        }

        .red {
            color: #d64d6d;
            font-weight: 600;
        }

        .green {
            color: #28a745;
            font-weight: 600;
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
            .form-section form {
                flex-direction: column;
            }

            .form-group {
                width: 100%;
            }

            .form-section button {
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
        <h2><i class="fas fa-handshake"></i> Gestion des emprunts</h2>
    </div>

    <!-- Message feedback -->
    <% if (message != null && !message.isEmpty()) { %>
        <div class="message-box <%= message.contains("Erreur") ? "error" : "success" %>">
            <i class="fas fa-<%= message.contains("Erreur") ? "exclamation-circle" : "check-circle" %>"></i>
            <%= message %>
        </div>
    <% } %>



    <div class="table-section">
        <table>
        <tr>
            <th>ID Emprunt</th>
            <th>Personne</th>
            <th>Livre</th>
            <th>Date emprunt</th>
            <th>Date retour</th>
            <th>Actions</th>
        </tr>

        <%
        if (emprunts != null && !emprunts.isEmpty()) {
            for (Emprunt e : emprunts) {
        %>
        <tr>
            <td><%= e.getIdEmp() %></td>
            <td>
                <%= (e.getNomPrenom() != null && !e.getNomPrenom().isEmpty() ? e.getNomPrenom() : "Inconnu") %>
                <br>(ID Rés.: <%= e.getIdRes() %>)
            </td>
            <td><%= (e.getTitreLivre() != null ? e.getTitreLivre() : "Livre supprimé") %></td>
            <td><%= e.getDateEmp() %></td>
            <td>
                <%= (e.getDateRetour() != null ? e.getDateRetour() : "<span class='red'>Non retourné</span>") %>
            </td>
            <td>
                <% if (e.getDateRetour() == null) { %>
                    <a href="<%= request.getContextPath() %>/EmpruntServlet?action=retourner&id=<%= e.getIdEmp() %>"
                       onclick="return confirm('Confirmer le retour du livre ?');">Retourner</a><br>
                <% } %>
                <a href="<%= request.getContextPath() %>/EmpruntServlet?action=delete&id=<%= e.getIdEmp() %>"
                   onclick="return confirm('Supprimer cet emprunt ?');">Supprimer</a>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr>
            <td colspan="6" style="text-align:center;">Aucun emprunt trouvé</td>
        </tr>
        <%
        }
        %>
        </table>
    </div>

<a href="javascript:history.back()" class="back-link">
    <i class="fas fa-arrow-left"></i>
                Retour à la gestion des livres

</a>

</div>

</body>
</html>