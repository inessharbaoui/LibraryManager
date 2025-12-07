package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.EtudiantDAO;
import dao.EnseignantDAO;
import model.Etudiant;
import model.Enseignant;
import util.DBConnection; // Your class to get JDBC connection

@WebServlet("/InscriptionServlet")
public class InscriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String type = request.getParameter("typeUtilisateur");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String adresse = request.getParameter("adresse");
        String telephone = request.getParameter("telephone");
        String login = request.getParameter("login"); // you may include if your DAO supports
        String pass = request.getParameter("pass");   // you may include if your DAO supports

        try (Connection conn = DBConnection.getConnection()) {
            boolean success = false;

            if("etudiant".equals(type)) {
                String classe = request.getParameter("classe");
                Etudiant e = new Etudiant();
                e.setNom(nom);
                e.setPrenom(prenom);
                e.setEmail(email);
                e.setAdresse(adresse);
                e.setTelephone(telephone);
                e.setClasse(classe);
                e.setLogin(login);   // ← add this
                e.setPass(pass);  
                EtudiantDAO etudiantDAO = new EtudiantDAO(conn);
                success = etudiantDAO.addEtudiant(e);

            } else if("enseignant".equals(type)) {
                String grade = request.getParameter("grade");
                String departement = request.getParameter("departement");

                Enseignant ens = new Enseignant();
                ens.setNom(nom);
                ens.setPrenom(prenom);
                ens.setEmail(email);
                ens.setAdresse(adresse);
                ens.setTelephone(telephone);
                ens.setGrade(grade);
                ens.setDepartement(departement);
                ens.setLogin(login);   // ← add this
                ens.setPass(pass);     
                EnseignantDAO enseignantDAO = new EnseignantDAO(conn);
                success = enseignantDAO.addEnseignant(ens);

            }
            else if ("bibliothecaire".equals(type)) {
                // create a Person object for bibliothécaire or reuse Enseignant/Etudiant model if you want
                String sqlP = "INSERT INTO personne (NOM, PRENOM, EMAIL, ADRESSE, TELEPHONE, LOGIN, PASS, typeUtilisateur) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sqlP)) {
                    ps.setString(1, nom);
                    ps.setString(2, prenom);
                    ps.setString(3, email);
                    ps.setString(4, adresse);
                    ps.setString(5, telephone);
                    ps.setString(6, login);
                    ps.setString(7, pass);
                    ps.setString(8, "bibliothecaire"); // type
                    int affected = ps.executeUpdate();
                    success = affected > 0;
                }
            } 

            else {
                // Handle administrateur or bibliothecaire if needed
            }

            if(success) {
                // Redirect based on user type
                if("etudiant".equals(type) || "enseignant".equals(type)) {
                    response.sendRedirect(request.getContextPath() + "/jsp/listeLivres.jsp");
                } else if("bibliothecaire".equals(type)) {
                    response.sendRedirect(request.getContextPath() + "/jsp/livres.jsp");
                } else {
                    // optional fallback
                    response.sendRedirect(request.getContextPath() + "/jsp/inscription.jsp?error=true");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/inscription.jsp?error=true");
            }

        } catch(Exception ex) {
            ex.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/jsp/inscription.jsp?error=true");
        }
    }
}
