<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Connexion</title>
</head>
<body>
    <h2>Connexion à la Bibliothèque</h2>
<form action="<%= request.getContextPath() %>/LoginServlet" method="post">
        Login: <input type="text" name="login" required /><br/>
        Mot de passe: <input type="password" name="pass" required /><br/>
        <input type="submit" value="Se connecter" />
    </form>

    <%
        if(request.getParameter("error") != null) {
            out.println("<p style='color:red;'>Login ou mot de passe incorrect</p>");
        }
    %>
</body>
</html>
