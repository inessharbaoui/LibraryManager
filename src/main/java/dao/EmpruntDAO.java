package dao;

import model.Emprunt;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EmpruntDAO {
    private Connection conn;

    public EmpruntDAO(Connection conn) { this.conn = conn; }

    // Lister tous les emprunts avec détails
    public List<Emprunt> getAllEmprunts() throws SQLException {
        List<Emprunt> list = new ArrayList<>();
        String sql = "SELECT e.IDEMP, e.DATEEMP, e.DATERETOUR, e.IDRES, " +
                "p.NOM, p.PRENOM, l.TITRE AS titreLivre " +
                "FROM emprunt e " +
                "JOIN reservation r ON e.IDRES = r.IDRES " +
                "LEFT JOIN personne p ON r.IDPERS = p.IDPERS " +
                "LEFT JOIN livre l ON r.ISBN = l.ISBN";


        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Emprunt emp = new Emprunt();
                emp.setIdEmp(rs.getInt("IDEMP"));
                emp.setDateEmp(rs.getTimestamp("DATEEMP"));
                emp.setDateRetour(rs.getTimestamp("DATERETOUR"));
                emp.setIdRes(rs.getInt("IDRES"));

                String nom = rs.getString("NOM");
                String prenom = rs.getString("PRENOM");
                if (nom == null) nom = "";
                if (prenom == null) prenom = "";
                emp.setNomPrenom(nom + (nom.isEmpty() || prenom.isEmpty() ? "" : " ") + prenom);

                emp.setTitreLivre(rs.getString("titreLivre"));

                list.add(emp);
            }
        }
        return list;
    }

    // Emprunter : créer un nouvel emprunt
    public boolean addEmprunt(int idRes) throws SQLException {
        String sql = "INSERT INTO emprunt (DATEEMP, IDRES) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, idRes);
            return ps.executeUpdate() > 0;
        }
    }

    // Retourner : mettre à jour la date de retour
    public boolean retournerEmprunt(int idEmp) throws SQLException {
        String sql = "UPDATE emprunt SET DATERETOUR=? WHERE IDEMP=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            ps.setInt(2, idEmp);
            return ps.executeUpdate() > 0;
        }
    }

    // Supprimer un emprunt (optionnel)
    public boolean deleteEmprunt(int idEmp) throws SQLException {
        String sql = "DELETE FROM emprunt WHERE IDEMP=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idEmp);
            return ps.executeUpdate() > 0;
        }
    }
}
