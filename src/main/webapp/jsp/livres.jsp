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
</head>
<body>
<h2>Gestion des livres </h2>
<p>Bonjour <b><%= userName %> 

<% if (message != null) { %>
    <p style="color:green;"><%= message %></p>
<% } %>

<!-- Button to view reservations -->
<!-- Buttons for bibliothécaire actions -->
<form style="margin-bottom:20px;">
    <input type="button" value="Voir les réservations" 
           onclick="window.location.href='<%= request.getContextPath() %>/ReservationServlet'"/>
<button type="button" 
        onclick="window.location.href='<%= request.getContextPath() %>/EmpruntServlet'">
    Voir tous les emprunts
</button>


  
</form>


<!-- Add/Edit form -->
<h3><%= (editLivre != null) ? "Modifier le livre" : "Ajouter un nouveau livre" %></h3>
<form method="post" action="<%= request.getContextPath() %>/LivreServlet">
    <input type="hidden" name="action" value="<%= (editLivre != null) ? "update" : "add" %>">
    <label>ISBN: </label>
    <input type="text" name="isbn" value="<%= (editLivre != null) ? editLivre.getISBN() : "" %>" 
           <%= (editLivre != null) ? "readonly" : "" %> required><br/>
    <label>Titre: </label>
    <input type="text" name="titre" value="<%= (editLivre != null) ? editLivre.getTitre() : "" %>" required><br/>
    <label>Auteurs: </label>
    <input type="text" name="auteurs" value="<%= (editLivre != null) ? editLivre.getAuteurs() : "" %>" required><br/>
    <input type="submit" value="<%= (editLivre != null) ? "Mettre à jour" : "Ajouter" %>">
</form>

<hr/>

<!-- Books list -->
<h3>Liste des livres</h3>
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

<br/>
<a href="<%= request.getContextPath() %>/jsp/home.jsp">Retour</a>
</body>
</html>
