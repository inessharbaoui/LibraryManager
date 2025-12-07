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

        // Get user type from session
        String typeUtilisateur = (String) request.getSession().getAttribute("typeUtilisateur");

        try (Connection conn = DBConnection.getConnection()) {
            EnseignantDAO dao = new EnseignantDAO(conn);

            // SEARCH
            if (search != null && !search.isEmpty()) {
                List<Enseignant> res = dao.search(search);
                request.setAttribute("enseignants", res);

                if ("administrateur".equals(typeUtilisateur)) {
                    request.getRequestDispatcher("/jsp/enseignants.jsp").forward(request, response);
                } else if ("bibliothecaire".equals(typeUtilisateur)) {
                    request.getRequestDispatcher("/jsp/voirEnseignants.jsp").forward(request, response);
                } else {
                    response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");
                }
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

            // LIST ALL
            List<Enseignant> list = dao.getAllEnseignants();
            request.setAttribute("enseignants", list);

            // Forward based on user type
            if ("admin".equals(typeUtilisateur)) {
                request.getRequestDispatcher("/jsp/enseignants.jsp").forward(request, response);
            } else if ("bibliothecaire".equals(typeUtilisateur)) {
                request.getRequestDispatcher("/jsp/voirEnseignants.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/home.jsp");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Erreur : " + e.getMessage());
            response.sendRedirect("EnseignantServlet");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message;
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
            e.setLogin(request.getParameter("login"));
            e.setPass(request.getParameter("pass"));

            String idStr = request.getParameter("idPers");

            // UPDATE
            if (idStr != null && !idStr.isEmpty()) {
                e.setIdPers(Integer.parseInt(idStr));
                success = dao.updateEnseignant(e);
                message = success ? "Modifié avec succès !" : "Erreur lors de la modification.";
            } 
            // ADD
            else {
                success = dao.addEnseignant(e);
                message = success ? "Ajouté avec succès !" : "Erreur lors de l'ajout.";
            }

        } catch (Exception ex) {
            ex.printStackTrace();
            success = false;
            message = "Erreur : " + ex.getMessage();
        }

        request.getSession().setAttribute("message", message);
        response.sendRedirect("EnseignantServlet");
    }
}
