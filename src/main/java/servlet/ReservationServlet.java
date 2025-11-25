package servlet;

import dao.ReservationDAO;
import model.Reservation;
import util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Date;
import java.util.List;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String action = request.getParameter("action");
	    String message = (String) request.getSession().getAttribute("message");

	    if (message != null) {
	        request.setAttribute("message", message);
	        request.getSession().removeAttribute("message");
	    }

	    try (Connection conn = DBConnection.getConnection()) {
	        ReservationDAO dao = new ReservationDAO(conn);

	        // DELETE reservation
	        if ("delete".equals(action)) {
	            int id = Integer.parseInt(request.getParameter("id"));
	            boolean deleted = dao.deleteReservation(id);
	            request.getSession().setAttribute("message",
	                    deleted ? "Réservation annulée avec succès !" : "Erreur lors de l'annulation !");
	            response.sendRedirect("ReservationServlet");
	            return;
	        }

	        // LIST all reservations
	        List<Reservation> list = dao.getAllReservations();
	        request.setAttribute("reservations", list);
	        request.getRequestDispatcher("/jsp/reservations.jsp").forward(request, response);

	    } catch (Exception e) {
	        e.printStackTrace();
	        // Show error on the same page instead of redirecting
	        request.setAttribute("message", "Erreur : " + e.getMessage());
	        request.getRequestDispatcher("/jsp/reservations.jsp").forward(request, response);
	    }
	}


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message;
        boolean success;

        try (Connection conn = DBConnection.getConnection()) {
            ReservationDAO dao = new ReservationDAO(conn);

            // Create new reservation
            Reservation r = new Reservation();
            r.setIsbn(request.getParameter("isbn"));
            r.setIdPers(Integer.parseInt(request.getParameter("idPers")));
            r.setDateRes(new Date()); // current datetime

            success = dao.addReservation(r);
            message = success ? "Réservation ajoutée !" : "Erreur lors de la réservation !";

        } catch (Exception e) {
            success = false;
            message = "Erreur : " + e.getMessage();
            e.printStackTrace();
        }

        request.getSession().setAttribute("message", message);
        response.sendRedirect("ReservationServlet");
    }
}
