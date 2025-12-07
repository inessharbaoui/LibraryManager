package servlet;

import dao.LivreDAO;
import dao.ReservationDAO;
import model.Livre;
import model.Reservation;
import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/LivreServlet")
public class LivreServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String userType = (String) session.getAttribute("typeUtilisateur");
        Integer userId = (Integer) session.getAttribute("userId");
        String action = request.getParameter("action");
        String isbn = request.getParameter("isbn");
        String keyword = request.getParameter("keyword");

        try (Connection conn = DBConnection.getConnection()) {
            LivreDAO livreDAO = new LivreDAO(conn);

            // Only bibliothécaire/admin can delete or edit books
            if (("bibliothecaire".equals(userType) || "admin".equals(userType))) {
                if ("delete".equals(action) && isbn != null) {
                    livreDAO.deleteLivre(isbn);
                    session.setAttribute("message", "Livre supprimé avec succès !");
                }
                if ("edit".equals(action) && isbn != null) {
                    Livre editLivre = livreDAO.getLivreByISBN(isbn);
                    request.setAttribute("editLivre", editLivre);
                }
            }

            // Fetch books list
            List<Livre> livres;
            if (keyword != null && !keyword.trim().isEmpty()) {
                livres = livreDAO.searchByTitleOrAuthor(keyword);
            } else {
                livres = livreDAO.getAllLivres();
            }
            request.setAttribute("livres", livres);

            // Forward based on user type
            if ("bibliothecaire".equals(userType) || "admin".equals(userType)) {
                request.getRequestDispatcher("/jsp/livres.jsp").forward(request, response);
            } else {
                if (userId != null) {
                    ReservationDAO resDAO = new ReservationDAO(conn);
                    List<Reservation> userReservations = resDAO.getReservationsByUser(userId);
                    request.setAttribute("userReservations", userReservations);
                }
                request.getRequestDispatcher("/jsp/listeLivres.jsp").forward(request, response);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Erreur lors de la récupération des livres : " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String userType = (String) session.getAttribute("typeUtilisateur");
        if (!"bibliothecaire".equals(userType) && !"admin".equals(userType)) {
            response.sendRedirect(request.getContextPath() + "/LivreServlet");
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
                session.setAttribute("message", "Livre ajouté avec succès !");
            } else if ("update".equals(action)) {
                livreDAO.updateLivre(l);
                session.setAttribute("message", "Livre mis à jour avec succès !");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "Erreur lors de l'opération sur le livre : " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/LivreServlet");
    }
}
