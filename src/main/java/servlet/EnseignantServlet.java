package servlet;

import dao.EnseignantDAO;
import model.Enseignant;
import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/EnseignantServlet")
public class EnseignantServlet extends HttpServlet {

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
            EnseignantDAO dao = new EnseignantDAO(conn);

            // RECHERCHE
            if (search != null && !search.isEmpty()) {
                List<Enseignant> res = dao.search(search);
                request.setAttribute("enseignants", res);
                request.getRequestDispatcher("/jsp/enseignants.jsp").forward(request, response);
                return;
            }

            // EDIT
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                Enseignant e = dao.getById(id);
                request.setAttribute("editEnseignant", e);
            }

            // DELETE
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                boolean deleted = dao.deleteEnseignant(id);
                request.getSession().setAttribute("message",
                        deleted ? "Supprimé avec succès !" : "Erreur lors de la suppression !");
                response.sendRedirect("EnseignantServlet");
                return;
            }

            // LISTER
            List<Enseignant> list = dao.getAllEnseignants();
            request.setAttribute("enseignants", list);
            request.getRequestDispatcher("/jsp/enseignants.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Erreur : " + e.getMessage());
            response.sendRedirect("EnseignantServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = "";
        boolean success = false;

        try (Connection conn = DBConnection.getConnection()) {
            EnseignantDAO dao = new EnseignantDAO(conn);

            Enseignant e = new Enseignant();
            e.setNom(request.getParameter("nom"));
            e.setPrenom(request.getParameter("prenom"));
            e.setEmail(request.getParameter("email"));
            e.setAdresse(request.getParameter("adresse"));
            e.setTelephone(request.getParameter("telephone"));
            e.setGrade(request.getParameter("grade"));
            e.setDepartement(request.getParameter("departement"));

            String idStr = request.getParameter("idPers");

            // MODIFIER
            if (idStr != null && !idStr.isEmpty()) {
                e.setIdPers(Integer.parseInt(idStr));
                success = dao.updateEnseignant(e);
                message = success ? "Modifié avec succès !" : "Erreur lors de la modification.";
            }
            // AJOUTER
            else {
                success = dao.addEnseignant(e);
                message = success ? "Ajouté avec succès !" : "Erreur lors de l'ajout.";
            }

        } catch (Exception ex) {
            success = false;
            message = "Erreur : " + ex.getMessage();
            ex.printStackTrace();
        }

        request.getSession().setAttribute("message", message);
        response.sendRedirect("EnseignantServlet");
    }
}
