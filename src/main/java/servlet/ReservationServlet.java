package servlet;

import dao.ReservationDAO;
import model.Reservation;
import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String userType = (String) session.getAttribute("typeUtilisateur");

        try (Connection conn = DBConnection.getConnection()) {
            ReservationDAO dao = new ReservationDAO(conn);

            if ("bibliothecaire".equals(userType)) {
                // Bibliothécaire sees all reservations
                List<Reservation> allReservations = dao.getAllReservations();
                request.setAttribute("reservations", allReservations);
                request.getRequestDispatcher("/jsp/reservations.jsp").forward(request, response);
            } else {
                // Student/teacher sees only their reservations
                Integer userId = (Integer) session.getAttribute("userId");
                List<Reservation> userReservations = dao.getReservationsByUser(userId);
                request.setAttribute("userReservations", userReservations);
                request.getRequestDispatcher("/jsp/listeLivres.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("message", "Erreur : " + e.getMessage());
            if ("bibliothecaire".equals(session.getAttribute("typeUtilisateur"))) {
                request.getRequestDispatcher("/jsp/reservations.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/jsp/listeLivres.jsp").forward(request, response);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("user") == null) {
            session.setAttribute("message", "Vous devez être connecté pour effectuer cette action.");
            response.sendRedirect(request.getContextPath() + "/jsp/login.jsp");
            return;
        }

        String userType = (String) session.getAttribute("typeUtilisateur");
        Integer userIdObj = (Integer) session.getAttribute("userId");
        int userId = userIdObj != null ? userIdObj : 0;

        String isbn = request.getParameter("isbn");           // Student/teacher new reservation
        String cancelIdStr = request.getParameter("cancelId"); // Student/teacher cancel
        String resIdStr = request.getParameter("resId");       // Bibliothécaire approve/reject
        String action = request.getParameter("action");        // approve/reject

        try (Connection conn = DBConnection.getConnection()) {
            ReservationDAO dao = new ReservationDAO(conn);

            if ("bibliothecaire".equals(userType) && resIdStr != null && action != null) {
                // Bibliothécaire approves or rejects
                int resId = Integer.parseInt(resIdStr);
                if ("approve".equalsIgnoreCase(action)) {
                    dao.updateReservationStatus(resId, "Approved");
                    session.setAttribute("message", "Réservation validée !");

                    // ======= Automatically create emprunt =======
                    dao.createEmpruntForApprovedReservation(resId, conn); // See note below

                } else if ("reject".equalsIgnoreCase(action)) {
                    dao.updateReservationStatus(resId, "Rejected");
                    session.setAttribute("message", "Réservation refusée !");
                }

            } else if (isbn != null) {
                // Student/teacher new reservation
                if (dao.reservationExists(isbn, userId)) {
                    session.setAttribute("message", "Vous avez déjà réservé ce livre !");
                } else {
                    Reservation r = new Reservation();
                    r.setIsbn(isbn);
                    r.setIdPers(userId);
                    r.setDateRes(new java.util.Date());
                    r.setStatus("Pending");
                    dao.addReservation(r);
                    session.setAttribute("message", "Réservation ajoutée ! Statut : Pending");
                }

            } else if (cancelIdStr != null) {
                // Student/teacher cancel reservation
                int cancelId = Integer.parseInt(cancelIdStr);
                boolean deleted = dao.deleteReservation(cancelId, userId);
                session.setAttribute("message", deleted ? "Réservation annulée !" : "Impossible d'annuler !");
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("message", "Erreur : " + e.getMessage());
        }

        // Redirect depending on role
        if ("bibliothecaire".equals(userType)) {
            response.sendRedirect("ReservationServlet"); // Show reservations.jsp
        } else {
            response.sendRedirect("LivreServlet");       // Student/teacher flow
        }
    }

}
