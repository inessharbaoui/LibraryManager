package servlet;

import dao.LivreDAO;
import model.Livre;
import util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LivreServlet")
public class LivreServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String isbn = request.getParameter("isbn");

        try (Connection conn = DBConnection.getConnection()) {
            LivreDAO livreDAO = new LivreDAO(conn);

            if ("delete".equals(action) && isbn != null) {
                livreDAO.deleteLivre(isbn);
            }

            if ("edit".equals(action) && isbn != null) {
                Livre l = livreDAO.getLivreByISBN(isbn);
                request.setAttribute("editLivre", l);
            }

            List<Livre> livres = livreDAO.getAllLivres();
            request.setAttribute("livres", livres);
            request.getRequestDispatcher("/jsp/livres.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la récupération des livres.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String isbn = request.getParameter("isbn");
        String titre = request.getParameter("titre");
        String auteurs = request.getParameter("auteurs");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            LivreDAO livreDAO = new LivreDAO(conn);
            Livre l = new Livre(isbn, titre, auteurs);

            if ("add".equals(action)) {
                livreDAO.addLivre(l);
            } else if ("update".equals(action)) {
                livreDAO.updateLivre(l);
            }

            response.sendRedirect(request.getContextPath() + "/LivreServlet");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de l'opération sur le livre.");
        }
    }
}
