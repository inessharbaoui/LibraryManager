<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Livre, model.Reservation" %>

<%
    if (session == null || session.getAttribute("user") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }

    String userName = (String) session.getAttribute("user");
    String typeUtilisateur = (String) session.getAttribute("typeUtilisateur");
    Integer userId = (Integer) session.getAttribute("userId");

    if (!"etudiant".equals(typeUtilisateur) && !"enseignant".equals(typeUtilisateur)) {
        response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");
        return;
    }

    List<Livre> livres = (List<Livre>) request.getAttribute("livres");
    List<Reservation> userReservations = (List<Reservation>) request.getAttribute("userReservations");
%>

<html>
<head>
    <title>Catalogue des livres</title>
</head>
<body>
<h2>Catalogue des livres</h2>
<p>Bonjour <b><%= userName %></b> (Profil : <%= "etudiant".equals(typeUtilisateur) ? "Étudiant" : "Enseignant" %>)</p>

<% String message = (String) session.getAttribute("message");
   if (message != null) { %>
    <p style="color:green;"><%= message %></p>
<% session.removeAttribute("message"); } %>

<form method="get" action="<%= request.getContextPath() %>/LivreServlet">
    <input type="text" name="keyword" placeholder="Rechercher par titre ou auteur" />
    <input type="submit" value="Rechercher" />
</form>

<br/>

<table border="1" cellpadding="5">
    <tr>
        <th>ISBN</th>
        <th>Titre</th>
        <th>Auteurs</th>
        <th>Statut</th>
        <th>Action</th>
    </tr>
<%
    if (livres != null && !livres.isEmpty()) {
        for (Livre l : livres) {
            Reservation userRes = null;
            if (userReservations != null) {
                for (Reservation r : userReservations) {
                    if (l.getISBN().equals(r.getIsbn())) {
                        userRes = r;
                        break;
                    }
                }
            }
            String status = (userRes != null) ? userRes.getStatus() : "Non réservé";
%>
    <tr>
        <td><%= l.getISBN() %></td>
        <td><%= l.getTitre() %></td>
        <td><%= l.getAuteurs() %></td>
        <td><%= status %></td>
        <td>
            <% if (userRes == null) { %>
                <form method="post" action="<%= request.getContextPath() %>/ReservationServlet">
                    <input type="hidden" name="isbn" value="<%= l.getISBN() %>">
                    <input type="submit" value="Réserver">
                </form>
            <% } else if ("Pending".equals(status)) { %>
                <form method="post" action="<%= request.getContextPath() %>/ReservationServlet">
                    <input type="hidden" name="cancelId" value="<%= userRes.getIdRes() %>">
                    <input type="submit" value="Annuler">
                </form>
            <% } else { %>
                Déjà réservé
            <% } %>
        </td>
    </tr>
<%
        }
    } else {
%>
    <tr>
        <td colspan="5">Aucun livre trouvé</td>
    </tr>
<%
    }
%>
</table>

<br/>
<a href="<%= request.getContextPath() %>/jsp/home.jsp">Retour</a>
</body>
</html>
