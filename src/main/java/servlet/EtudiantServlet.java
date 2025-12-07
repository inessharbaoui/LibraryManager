package servlet;

import dao.EtudiantDAO;
import model.Etudiant;
import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/EtudiantServlet")
public class EtudiantServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String search = request.getParameter("search");

        // Get message from session if exists
        String message = (String) request.getSession().getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            request.getSession().removeAttribute("message");
        }

        // Get user type from session
        String typeUtilisateur = (String) request.getSession().getAttribute("typeUtilisateur");

        try (Connection conn = DBConnection.getConnection()) {
            EtudiantDAO dao = new EtudiantDAO(conn);

            // SEARCH
            if (search != null && !search.isEmpty()) {
                List<Etudiant> res = dao.search(search);
                request.setAttribute("etudiants", res);

                if ("administrateur".equals(typeUtilisateur)) {
                    request.getRequestDispatcher("/jsp/etudiants.jsp").forward(request, response);
                } else if ("bibliothecaire".equals(typeUtilisateur)) {
                    request.getRequestDispatcher("/jsp/voirEtudiants.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");
                }
                return;
            }

            // EDIT
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Etudiant e = dao.getById(id);
                request.setAttribute("editEtudiant", e);
            }

            // DELETE
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean deleted = dao.deleteEtudiant(id);
                request.getSession().setAttribute("message",
                        deleted ? "Supprimé avec succès !" : "Erreur lors de la suppression !");
                response.sendRedirect("EtudiantServlet");
                return;
            }

            // LIST ALL
            List<Etudiant> list = dao.getAllEtudiants();
            request.setAttribute("etudiants", list);

            // Forward based on user type
            if ("admin".equals(typeUtilisateur)) {
                request.getRequestDispatcher("/jsp/etudiants.jsp").forward(request, response);
            } else if ("bibliothecaire".equals(typeUtilisateur)) {
                request.getRequestDispatcher("/jsp/voirEtudiants.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Erreur : " + e.getMessage());
            response.sendRedirect("EtudiantServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message;
        boolean success = false;

        try (Connection conn = DBConnection.getConnection()) {
            EtudiantDAO dao = new EtudiantDAO(conn);

            Etudiant e = new Etudiant();
            e.setNom(request.getParameter("nom"));
            e.setPrenom(request.getParameter("prenom"));
            e.setEmail(request.getParameter("email"));
            e.setAdresse(request.getParameter("adresse"));
            e.setTelephone(request.getParameter("telephone"));
            e.setClasse(request.getParameter("classe"));

            String idStr = request.getParameter("idPers");

            // UPDATE
            if (idStr != null && !idStr.isEmpty()) {
                e.setIdPers(Integer.parseInt(idStr));
                success = dao.updateEtudiant(e);
                message = success ? "Modifié avec succès !" : "Erreur lors de la modification.";
            } 
            // ADD
            else {
                success = dao.addEtudiant(e);
                message = success ? "Ajouté avec succès !" : "Erreur lors de l'ajout.";
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            success = false;
            message = "Erreur : " + ex.getMessage();
        }

        request.getSession().setAttribute("message", message);
        response.sendRedirect("EtudiantServlet");
    }
}
