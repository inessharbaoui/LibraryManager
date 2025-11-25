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

        try (Connection conn = DBConnection.getConnection()) {
            EtudiantDAO dao = new EtudiantDAO(conn);

            // RECHERCHE
            if (search != null && !search.isEmpty()) {
                List<Etudiant> res = dao.search(search);
                request.setAttribute("etudiants", res);
                request.getRequestDispatcher("/jsp/etudiants.jsp").forward(request, response);
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
                if (deleted) {
                    request.getSession().setAttribute("message", "Supprimé avec succès !");
                } else {
                    request.getSession().setAttribute("message", "Erreur lors de la suppression !");
                }
                response.sendRedirect("EtudiantServlet");
                return;
            }

            // LISTER
            List<Etudiant> list = dao.getAllEtudiants();
            request.setAttribute("etudiants", list);
            request.getRequestDispatcher("/jsp/etudiants.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Erreur : " + e.getMessage());
            response.sendRedirect("EtudiantServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = "";
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

            // MODIFIER
            if (idStr != null && !idStr.isEmpty()) {
                e.setIdPers(Integer.parseInt(idStr));
                success = dao.updateEtudiant(e);
                message = success ? "Modifié avec succès !" : "Erreur lors de la modification.";
            }
            // AJOUTER
            else {
                success = dao.addEtudiant(e);
                message = success ? "Ajouté avec succès !" : "Erreur lors de l'ajout.";
            }

        } catch (Exception ex) {
            success = false;
            message = "Erreur : " + ex.getMessage();
            ex.printStackTrace();
        }

        request.getSession().setAttribute("message", message);
        response.sendRedirect("EtudiantServlet");
    }
}
