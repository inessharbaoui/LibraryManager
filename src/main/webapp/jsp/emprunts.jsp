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
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { padding: 8px; border: 1px solid #ccc; text-align: left; }
        th { background-color: #eee; }
        .red { color: red; }
        .green { color: green; }
    </style>
</head>
<body>

<h2>Gestion des emprunts</h2>

<!-- Message feedback -->
<% if (message != null && !message.isEmpty()) { %>
    <p style="padding:10px; color:<%= message.contains("Erreur") ? "red" : "green" %>;">
        <%= message %>
    </p>
<% } %>

<!-- Create a new emprunt -->
<form action="<%= request.getContextPath() %>/EmpruntServlet" method="post" style="margin-bottom:20px;">
    <label>ID Réservation :</label>
    <input type="number" name="idRes" required>
    <button type="submit">Créer emprunt</button>
</form>

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

<br/>
<a href="<%= request.getContextPath() %>/jsp/home.jsp">Retour à l'accueil</a>

</body>
</html>
