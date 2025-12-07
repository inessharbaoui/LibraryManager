<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Enseignant" %>
<%
    List<Enseignant> enseignants = (List<Enseignant>) request.getAttribute("enseignants");
    String message = (String) request.getAttribute("message");
%>

<html>
<body>

<h2>Liste des enseignants</h2>

<% if (message != null && !message.isEmpty()) { %>
    <p style="color: <%= message.contains("Erreur") ? "red" : "green" %>;">
        <%= message %>
    </p>
<% } %>

<!-- Search form -->
<form action="EnseignantServlet" method="get">
    <input type="text" name="search" placeholder="Nom, Grade ou Département">
    <input type="submit" value="Rechercher">
</form>

<br>

<table border="1">
<tr>
    <th>ID</th><th>Nom</th><th>Prénom</th><th>Email</th><th>Adresse</th><th>Téléphone</th><th>Grade</th><th>Département</th>
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
</tr>
<%
    }
}
%>

</table>

</body>
</html>
