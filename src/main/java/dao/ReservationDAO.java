package dao;

import model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {
    private Connection conn;

    public ReservationDAO(Connection conn) {
        this.conn = conn;
    }

    // Add reservation
    public boolean addReservation(Reservation r) throws SQLException {
        String sql = "INSERT INTO reservation (DATERES, ISBN, IDPERS, STATUS) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(r.getDateRes().getTime()));
            ps.setString(2, r.getIsbn());
            ps.setInt(3, r.getIdPers());
            ps.setString(4, r.getStatus());
            return ps.executeUpdate() > 0;
        }
    }

    // Check if reservation exists
    public boolean reservationExists(String isbn, int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservation WHERE ISBN = ? AND IDPERS = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, isbn);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        }
        return false;
    }

    // Get reservations of user
    public List<Reservation> getReservationsByUser(int userId) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.IDRES, r.DATERES, r.ISBN, r.STATUS, l.TITRE AS titreLivre " +
                     "FROM reservation r " +
                     "LEFT JOIN livre l ON r.ISBN = l.ISBN " +
                     "WHERE r.IDPERS = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Reservation r = new Reservation();
                    r.setIdRes(rs.getInt("IDRES"));
                    r.setDateRes(rs.getTimestamp("DATERES"));
                    r.setIsbn(rs.getString("ISBN"));
                    r.setStatus(rs.getString("STATUS"));
                    r.setTitreLivre(rs.getString("titreLivre"));
                    r.setIdPers(userId);
                    list.add(r);
                }
            }
        }
        return list;
    }

    
    
 // Update reservation status (for bibliothécaire)
    public boolean updateReservationStatus(int idRes, String newStatus) throws SQLException {
        String sql = "UPDATE reservation SET STATUS=? WHERE IDRES=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, idRes);
            return ps.executeUpdate() > 0;
        }
    }

    
    
 // Get all reservations (for bibliothécaire)
    public List<Reservation> getAllReservations() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.IDRES, r.DATERES, r.ISBN, r.STATUS, r.IDPERS, " +
                     "p.NOM, p.PRENOM, l.TITRE AS titreLivre " +
                     "FROM reservation r " +
                     "LEFT JOIN personne p ON r.IDPERS = p.IDPERS " +
                     "LEFT JOIN livre l ON r.ISBN = l.ISBN " +
                     "ORDER BY r.DATERES DESC";

        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Reservation r = new Reservation();
                r.setIdRes(rs.getInt("IDRES"));
                r.setDateRes(rs.getTimestamp("DATERES"));
                r.setIsbn(rs.getString("ISBN"));
                r.setStatus(rs.getString("STATUS"));
                r.setIdPers(rs.getInt("IDPERS"));

                String nom = rs.getString("NOM") != null ? rs.getString("NOM") : "";
                String prenom = rs.getString("PRENOM") != null ? rs.getString("PRENOM") : "";
                r.setNomPrenom(nom + (nom.isEmpty() || prenom.isEmpty() ? "" : " ") + prenom);

                r.setTitreLivre(rs.getString("titreLivre"));
                list.add(r);
            }
        }
        return list;
    }

    
    
    
    
    
    
    
    
    
    public void createEmpruntForApprovedReservation(int resId, Connection conn) throws SQLException {
        String sql = "INSERT INTO emprunt (DATEEMP, IDRES) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, resId);
            ps.executeUpdate();
        }
    }
 
    
    
    
    
    
    
    
    
    
    
    
    
    // Delete reservation (only by the owner)
    public boolean deleteReservation(int idRes, int userId) throws SQLException {
        String sql = "DELETE FROM reservation WHERE IDRES=? AND IDPERS=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idRes);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }
}
