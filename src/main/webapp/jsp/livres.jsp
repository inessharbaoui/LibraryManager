<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Livre" %>
<%
    List<Livre> livres = (List<Livre>) request.getAttribute("livres");
    Livre editLivre = (Livre) request.getAttribute("editLivre");
%>
<html>
<head>
    <title>Gestion des livres</title>
</head>
<body>
    <h2>Liste des livres</h2>
    <table border="1">
        <tr>
            <th>ISBN</th>
            <th>Titre</th>
            <th>Auteurs</th>
            <th>Actions</th>
        </tr>
        <%
            if (livres != null) {
                for (Livre l : livres) {
        %>
        <tr>
            <td><%= l.getISBN() %></td>
            <td><%= l.getTitre() %></td>
            <td><%= l.getAuteurs() %></td>
            <td>
                <a href="LivreServlet?action=edit&isbn=<%= l.getISBN() %>">Modifier</a> |
                <a href="LivreServlet?action=delete&isbn=<%= l.getISBN() %>">Supprimer</a>
            </td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="4">Aucun livre disponible</td>
        </tr>
        <% } %>
    </table>

    <h2><%= (editLivre != null) ? "Modifier le livre" : "Ajouter un livre" %></h2>
    <form method="post" action="LivreServlet">
        <input type="hidden" name="action" value="<%= (editLivre != null) ? "update" : "add" %>">
        ISBN: <input type="text" name="isbn" value="<%= (editLivre != null) ? editLivre.getISBN() : "" %>" <%= (editLivre != null) ? "readonly" : "" %> required><br>
        Titre: <input type="text" name="titre" value="<%= (editLivre != null) ? editLivre.getTitre() : "" %>" required><br>
        Auteurs: <input type="text" name="auteurs" value="<%= (editLivre != null) ? editLivre.getAuteurs() : "" %>" required><br>
        <input type="submit" value="<%= (editLivre != null) ? "Mettre à jour" : "Ajouter" %>">
    </form>

    <p><a href="<%= request.getContextPath() %>/home.jsp">Retour à l'accueil</a></p>
</body>
</html>
