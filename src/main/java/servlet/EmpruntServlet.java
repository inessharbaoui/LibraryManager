package servlet;

import dao.EmpruntDAO;
import util.DBConnection;
import model.Emprunt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/EmpruntServlet")
public class EmpruntServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Display any message from session
        String message = (String) request.getSession().getAttribute("message");
        if (message != null) {
            request.setAttribute("message", message);
            request.getSession().removeAttribute("message");
        }

        try (Connection conn = DBConnection.getConnection()) {
            EmpruntDAO dao = new EmpruntDAO(conn);

            // Action: return book
            if ("retourner".equals(action)) {
                int idEmp = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.retournerEmprunt(idEmp);
                request.getSession().setAttribute("message",
                        ok ? "Livre retourné avec succès !" : "Erreur lors du retour !");
                response.sendRedirect("EmpruntServlet");
                return;
            }

            // Action: delete (optional)
            if ("delete".equals(action)) {
                int idEmp = Integer.parseInt(request.getParameter("id"));
                boolean ok = dao.deleteEmprunt(idEmp);
                request.getSession().setAttribute("message",
                        ok ? "Emprunt supprimé !" : "Erreur lors de la suppression !");
                response.sendRedirect("EmpruntServlet");
                return;
            }

            // Default: list all
            List<Emprunt> emprunts = dao.getAllEmprunts();
            request.setAttribute("emprunts", emprunts);
            request.getRequestDispatcher("/jsp/emprunts.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Erreur : " + e.getMessage());
            request.getRequestDispatcher("/jsp/emprunts.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message;

        try (Connection conn = DBConnection.getConnection()) {
            EmpruntDAO dao = new EmpruntDAO(conn);

            int idRes = Integer.parseInt(request.getParameter("idRes"));
            boolean ok = dao.addEmprunt(idRes);

            message = ok ? "Emprunt ajouté avec succès !" : "Erreur lors de l'ajout !";

        } catch (Exception e) {
            message = "Erreur : " + e.getMessage();
            e.printStackTrace();
        }

        request.getSession().setAttribute("message", message);
        response.sendRedirect("EmpruntServlet");
    }
}
