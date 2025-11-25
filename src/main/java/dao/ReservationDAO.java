package dao;

import model.Reservation;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {
    private Connection conn;

    public ReservationDAO(Connection conn) { this.conn = conn; }

    // Lister toutes les réservations avec details de la personne et livre
    public List<Reservation> getAllReservations() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT r.IDRES, r.DATERES, r.ISBN, r.IDPERS, " +
                     "p.NOM, p.PRENOM, l.TITRE AS titreLivre " +
                     "FROM reservation r " +
                     "LEFT JOIN personne p ON r.IDPERS = p.IDPERS " +
                     "LEFT JOIN livre l ON r.ISBN = l.ISBN";

        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Reservation r = new Reservation();
                r.setIdRes(rs.getInt("IDRES"));
                r.setDateRes(rs.getTimestamp("DATERES"));
                r.setIsbn(rs.getString("ISBN"));
                r.setIdPers(rs.getInt("IDPERS"));
                String nom = rs.getString("NOM");
                String prenom = rs.getString("PRENOM");

                if (nom == null) nom = "";
                if (prenom == null) prenom = "";

                r.setNomPrenom(nom + (nom.isEmpty() || prenom.isEmpty() ? "" : " ") + prenom);
                r.setTitreLivre(rs.getString("titreLivre"));
                list.add(r);
            }
        }
        return list;
    }

    // Ajouter réservation
    public boolean addReservation(Reservation r) throws SQLException {
        String sql = "INSERT INTO reservation (DATERES, ISBN, IDPERS) VALUES (?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(r.getDateRes().getTime()));
            ps.setString(2, r.getIsbn());
            ps.setInt(3, r.getIdPers());
            return ps.executeUpdate() > 0;
        }
    }

    // Supprimer réservation
    public boolean deleteReservation(int idRes) throws SQLException {
        String sql = "DELETE FROM reservation WHERE IDRES=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idRes);
            return ps.executeUpdate() > 0;
        }
    }
}
