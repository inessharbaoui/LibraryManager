<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, model.Reservation" %>
<%
    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");
    String message = (String) request.getAttribute("message");
%>

<h2>Gestion des réservations</h2>

<% if (message != null && !message.isEmpty()) { %>
    <p style="color: <%= message.contains("Erreur") ? "red" : "green" %>;">
        <%= message %>
    </p>
<% } %>

<form action="ReservationServlet" method="post">
    ID Personne: <input type="text" name="idPers" required>
    ISBN Livre: <input type="text" name="isbn" required>
    <button type="submit">Réserver</button>
</form>

<br>

<table border="1" cellpadding="5" cellspacing="0">
<tr>
    <th>ID Réservation</th>
    <th>Personne</th>
    <th>Livre</th>
    <th>Date</th>
    <th>Actions</th>
</tr>

<%
if (reservations != null) {
    for (Reservation r : reservations) {
%>
<tr>
    <td><%= r.getIdRes() %></td>
    <td><%= (r.getNomPrenom() != null ? r.getNomPrenom() : "Inconnu") %> 
        (ID: <%= r.getIdPers() %>)</td>
    <td><%= (r.getTitreLivre() != null ? r.getTitreLivre() : "Livre supprimé") %> 
        (ISBN: <%= r.getIsbn() %>)</td>
    <td><%= r.getDateRes() %></td>
    <td>
        <a href="ReservationServlet?action=delete&id=<%= r.getIdRes() %>"
           onclick="return confirm('Annuler la réservation ?')">Annuler</a>
    </td>
</tr>
<%
    }
}
%>
</table>
