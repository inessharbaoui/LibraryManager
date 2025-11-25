<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session == null || session.getAttribute("user") == null){
        response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Accueil</title>
</head>
<body>
    <h2>Bienvenue, <%= session.getAttribute("user") %> !</h2>
    <p>
        <a href="<%= request.getContextPath() %>/LogoutServlet">Se déconnecter</a>
    </p>
    <p>
        <a href="<%= request.getContextPath() %>/LivreServlet">Voir la liste des livres</a>
    </p>
     <p>
        <a href="<%= request.getContextPath() %>/EtudiantServlet">Gestion des étudiants</a>
    </p>
    <p>
    <a href="<%= request.getContextPath() %>/EnseignantServlet">Gestion des enseignants</a>
</p>
 <p>
    <a href="<%= request.getContextPath() %>/ReservationServlet">Gestion des réservations</a>
</p>
    
    <p>
    <a href="<%= request.getContextPath() %>/EmpruntServlet">Gestion des emprunts</a>
</p>
    
</body>
</html>

