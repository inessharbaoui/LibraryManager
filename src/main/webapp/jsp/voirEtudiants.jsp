<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Etudiant" %>
<%
    List<Etudiant> etudiants = (List<Etudiant>) request.getAttribute("etudiants");
%>

<html>
<body>

<h2>Liste des étudiants</h2>

<table border="1">
<tr>
    <th>ID</th><th>Nom</th><th>Prénom</th><th>Email</th><th>Adresse</th>
    <th>Téléphone</th><th>Classe</th>
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
</tr>
<%
    }
}
%>

</table>

</body>
</html>
