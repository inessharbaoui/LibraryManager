<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Reservation" %>

<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("user");
    String typeUtilisateur = (String) session.getAttribute("typeUtilisateur");

    if (!"bibliothecaire".equals(typeUtilisateur)) {
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
</head>
<body>
<h2>Gestion des Réservations - Bibliothécaire</h2>
<p>Bonjour <b><%= userName %></b> (Profil : Bibliothécaire)</p>

<% if (message != null) { %>
    <p style="color:green;"><%= message %></p>
<% } %>

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
        <td><%= r.getStatus() %></td>
        <td>
            <% if ("Pending".equalsIgnoreCase(r.getStatus())) { %>
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

<br/>
<a href="<%= request.getContextPath() %>/jsp/livres.jsp">Retour à la gestion des livres</a>
</body>
</html>
