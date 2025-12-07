<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Inscription - Bibliothèque</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script>
        function toggleExtraFields() {
            var type = document.getElementById("typeUtilisateur").value;
            document.getElementById("etudiantFields").style.display = (type === "etudiant") ? "block" : "none";
            document.getElementById("enseignantFields").style.display = (type === "enseignant") ? "block" : "none";
        }
    </script>
</head>
<body>
    <h2>Créer un compte</h2>

    <%
        if(request.getParameter("error") != null) {
            out.println("<div>Une erreur s'est produite lors de l'inscription</div>");
        }
        if(request.getParameter("success") != null) {
            out.println("<div>Inscription réussie ! Vous pouvez maintenant vous connecter</div>");
        }
    %>

<form action="<%= request.getContextPath() %>/InscriptionServlet" method="post">
        <div>
            <label for="typeUtilisateur">Type d'utilisateur</label>
            <select id="typeUtilisateur" name="typeUtilisateur" required onchange="toggleExtraFields()">
                <option value="">Sélectionnez votre profil</option>
                <option value="administrateur">Administrateur</option>
                <option value="bibliothecaire">Bibliothécaire</option>
                <option value="etudiant">Étudiant</option>
                <option value="enseignant">Enseignant</option>
            </select>
        </div>

        <div>
            <label for="nom">Nom</label>
            <input type="text" id="nom" name="nom" required />
        </div>

        <div>
            <label for="prenom">Prénom</label>
            <input type="text" id="prenom" name="prenom" required />
        </div>

        <div>
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required />
        </div>

        <div>
            <label for="adresse">Adresse</label>
            <input type="text" id="adresse" name="adresse" />
        </div>

        <div>
            <label for="telephone">Téléphone</label>
            <input type="text" id="telephone" name="telephone" />
        </div>

        <div>
            <label for="login">Login</label>
            <input type="text" id="login" name="login" required />
        </div>

        <div>
            <label for="pass">Mot de passe</label>
            <input type="password" id="pass" name="pass" required />
        </div>

        <!-- Étudiant extra field -->
        <div id="etudiantFields" style="display:none;">
            <label for="classe">Classe</label>
            <input type="text" id="classe" name="classe" />
        </div>

        <!-- Enseignant extra fields -->
        <div id="enseignantFields" style="display:none;">
            <label for="grade">Grade</label>
            <input type="text" id="grade" name="grade" />
            
            <label for="departement">Département</label>
            <input type="text" id="departement" name="departement" />
        </div>

        <button type="submit">S'inscrire</button>
    </form>
</body>
</html>
