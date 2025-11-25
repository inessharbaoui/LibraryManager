<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Enseignant" %>
<%
    List<Enseignant> enseignants = (List<Enseignant>) request.getAttribute("enseignants");
    Enseignant edit = (Enseignant) request.getAttribute("editEnseignant");
    String message = (String) request.getAttribute("message");
%>

<html>
<body>

<h2>Gestion des enseignants</h2>

<% if (message != null && !message.isEmpty()) { %>
    <p style="color: <%= message.contains("Erreur") ? "red" : "green" %>;">
        <%= message %>
    </p>
<% } %>

<form action="${pageContext.request.contextPath}/EnseignantServlet" method="post">
    <input type="hidden" name="idPers" value="<%= (edit != null) ? edit.getIdPers() : "" %>">

    Nom: <input type="text" name="nom" value="<%= (edit != null)? edit.getNom() : "" %>" required>
    Prénom: <input type="text" name="prenom" value="<%= (edit != null)? edit.getPrenom() : "" %>" required>
    Email: <input type="email" name="email" value="<%= (edit != null)? edit.getEmail() : "" %>" required>
    Adresse: <input type="text" name="adresse" value="<%= (edit != null)? edit.getAdresse() : "" %>">
    Téléphone: <input type="text" name="telephone" value="<%= (edit != null)? edit.getTelephone() : "" %>">
    Grade: <input type="text" name="grade" value="<%= (edit != null)? edit.getGrade() : "" %>" required>
    Département: <input type="text" name="departement" value="<%= (edit != null)? edit.getDepartement() : "" %>">

    <button type="submit"><%= (edit != null)? "Modifier" : "Ajouter" %></button>
</form>

<br><br>

<form action="EnseignantServlet" method="get">
    <input type="text" name="search" placeholder="Nom, Grade ou Département">
    <input type="submit" value="Rechercher">
</form>

<br>

<table border="1">
<tr>
    <th>ID</th><th>Nom</th><th>Prénom</th><th>Email</th><th>Adresse</th><th>Téléphone</th><th>Grade</th><th>Département</th><th>Actions</th>
</tr>

<%
if (enseignants != null) {
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
    <td>
        <a href="EnseignantServlet?action=edit&id=<%= e.getIdPers() %>">Modifier</a>
        |
        <a href="EnseignantServlet?action=delete&id=<%= e.getIdPers() %>"
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
