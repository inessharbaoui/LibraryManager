<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Reservation" %>

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


    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    String message = (String) session.getAttribute("message");
    if (message != null) {
        session.removeAttribute("message");
    }
%>

<html>
<head>
    <title>Gestion des Réservations</title>
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
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .page-header p {
            font-size: 14px;
            color: #a393c9;
        }

        .page-header p b {
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

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }

        .status-badge.pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.approved {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.rejected {
            background: #ffe0e6;
            color: #d64d6d;
        }

        .action-buttons {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .action-buttons form {
            display: inline;
            margin: 0;
        }

        .action-buttons input[type="submit"] {
            padding: 8px 16px;
            border: none;
            border-radius: 8px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .action-buttons input[type="submit"][value="Valider"] {
            background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
            color: #155724;
        }

        .action-buttons input[type="submit"][value="Valider"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
            background: linear-gradient(135deg, #c3e6cb 0%, #b1dfbb 100%);
        }

        .action-buttons input[type="submit"][value="Refuser"] {
            background: linear-gradient(135deg, #ffe0e6 0%, #ffd1da 100%);
            color: #d64d6d;
        }

        .action-buttons input[type="submit"][value="Refuser"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(214, 77, 109, 0.3);
            background: linear-gradient(135deg, #ffd1da 0%, #ffc2ce 100%);
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
            .table-section {
                padding: 20px 15px;
            }

            table {
                font-size: 12px;
            }

            table th, table td {
                padding: 10px 8px;
            }

            .action-buttons {
                flex-direction: column;
            }

            .action-buttons input[type="submit"] {
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <div class="page-header">
        <h2><i class="fas fa-calendar-check"></i> Gestion des Réservations - Bibliothécaire</h2>
        <p>Bonjour <b><%= userName %></b></p>
    </div>

    <% if (message != null) { %>
        <div class="success-message">
            <i class="fas fa-check-circle"></i>
            <%= message %>
        </div>
    <% } %>

    <div class="table-section">
        <table border="1" cellpadding="5">
            <tr>
                <th>ID Réservation</th>
                <th>Utilisateur</th>
                <th>ISBN</th>
                <th>Titre Livre</th>
                <th>Date Réservation</th>
                <th>Statut</th>
                <th>Actions</th>
            </tr>
        <%
            if (reservations != null && !reservations.isEmpty()) {
                for (Reservation r : reservations) {
        %>
            <tr>
                <td><%= r.getIdRes() %></td>
                <td><%= r.getNomPrenom() %></td>
                <td><%= r.getIsbn() %></td>
                <td><%= r.getTitreLivre() %></td>
                <td><%= r.getDateRes() %></td>
                <td>
                    <span class="status-badge <%= r.getStatus().toLowerCase() %>">
                        <%= r.getStatus() %>
                    </span>
                </td>
                <td>
                    <% if ("Pending".equalsIgnoreCase(r.getStatus())) { %>
                        <div class="action-buttons">
                            <!-- Approve form -->
                            <form method="post" action="<%= request.getContextPath() %>/ReservationServlet" style="display:inline;">
                                <input type="hidden" name="resId" value="<%= r.getIdRes() %>">
                                <input type="hidden" name="action" value="approve">
                                <input type="submit" value="Valider">
                            </form>
                            <!-- Reject form -->
                            <form method="post" action="<%= request.getContextPath() %>/ReservationServlet" style="display:inline;">
                                <input type="hidden" name="resId" value="<%= r.getIdRes() %>">
                                <input type="hidden" name="action" value="reject">
                                <input type="submit" value="Refuser">
                            </form>
                        </div>
                    <% } else { %>
                        -
                    <% } %>
                </td>
            </tr>
        <%
                }
            } else {
        %>
            <tr>
                <td colspan="7">Aucune réservation trouvée</td>
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