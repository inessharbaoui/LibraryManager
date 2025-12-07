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
<input type="button" value="Gérer les livres" 
       onclick="window.location.href='<%= request.getContextPath() %>/LivreServlet'"/>
    </p>

<input type="button" value="gerer  les étudiants" 
           onclick="window.location.href='<%= request.getContextPath() %>/EtudiantServlet'"/>
           
           
    <input type="button" value="gerer  les enseignants" 
           onclick="window.location.href='<%= request.getContextPath() %>/EnseignantServlet'"/>
           
         
    
</body>
</html>

