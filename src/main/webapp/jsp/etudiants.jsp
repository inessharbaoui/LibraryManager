<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Etudiant" %>
<%
    List<Etudiant> etudiants = (List<Etudiant>) request.getAttribute("etudiants");
    Etudiant edit = (Etudiant) request.getAttribute("editEtudiant");
    String message = (String) request.getAttribute("message");
%>

<html>
<body>

<h2>Gestion des étudiants</h2>

<% if (message != null && !message.isEmpty()) { %>
    <p style="color: <%= message.contains("Erreur") ? "red" : "green" %>;">
        <%= message %>
    </p>
<% } %>

<form action="${pageContext.request.contextPath}/EtudiantServlet" method="post">
    <input type="hidden" name="idPers" value="<%= (edit != null) ? edit.getIdPers() : "" %>">

    Nom: <input type="text" name="nom" value="<%= (edit != null)? edit.getNom() : "" %>" required>
    Prénom: <input type="text" name="prenom" value="<%= (edit != null)? edit.getPrenom() : "" %>" required>
    Email: <input type="email" name="email" value="<%= (edit != null)? edit.getEmail() : "" %>" required>
    Adresse: <input type="text" name="adresse" value="<%= (edit != null)? edit.getAdresse() : "" %>">
    Téléphone: <input type="text" name="telephone" value="<%= (edit != null)? edit.getTelephone() : "" %>">
    Classe: <input type="text" name="classe" value="<%= (edit != null)? edit.getClasse() : "" %>">

    <button type="submit"><%= (edit != null)? "Modifier" : "Ajouter" %></button>
</form>

<br><br>

<form action="EtudiantServlet" method="get">
    <input type="text" name="search" placeholder="Nom ou Prenom">
    <input type="submit" value="Rechercher">
</form>

<br>

<table border="1">
<tr>
    <th>ID</th><th>Nom</th><th>Prénom</th><th>Email</th><th>Adresse</th>
    <th>Téléphone</th><th>Classe</th><th>Actions</th>
</tr>

<%
if (etudiants != null) {
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
        <a href="EtudiantServlet?action=edit&id=<%= e.getIdPers() %>">Modifier</a>
        |
        <a href="EtudiantServlet?action=delete&id=<%= e.getIdPers() %>"
           onclick="return confirm('Supprimer ?')">Supprimer</a>
    </td>
</tr>
<%
    }
}
%>

</table>

</body>
</html>
