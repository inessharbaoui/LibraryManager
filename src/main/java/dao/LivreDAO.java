package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Livre;

public class LivreDAO {
    private Connection conn;

    public LivreDAO(Connection conn) {
        this.conn = conn;
    }

    public List<Livre> getAllLivres() throws SQLException {
        List<Livre> livres = new ArrayList<>();
        String sql = "SELECT * FROM livre";
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Livre l = new Livre();
                l.setISBN(rs.getString("ISBN"));
                l.setTitre(rs.getString("TITRE"));
                l.setAuteurs(rs.getString("AUTEURS"));
                livres.add(l);
            }
        }
        return livres;
    }

    public List<Livre> searchByTitleOrAuthor(String keyword) throws SQLException {
        List<Livre> livres = new ArrayList<>();
        String sql = "SELECT * FROM livre WHERE TITRE LIKE ? OR AUTEURS LIKE ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Livre l = new Livre();
                    l.setISBN(rs.getString("ISBN"));
                    l.setTitre(rs.getString("TITRE"));
                    l.setAuteurs(rs.getString("AUTEURS"));
                    livres.add(l);
                }
            }
        }
        return livres;
    }

    public boolean addLivre(Livre l) throws SQLException {
        String sql = "INSERT INTO livre (ISBN, TITRE, AUTEURS) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, l.getISBN());
            pstmt.setString(2, l.getTitre());
            pstmt.setString(3, l.getAuteurs());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteLivre(String ISBN) throws SQLException {
        String sql = "DELETE FROM livre WHERE ISBN = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, ISBN);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateLivre(Livre l) throws SQLException {
        String sql = "UPDATE livre SET TITRE = ?, AUTEURS = ? WHERE ISBN = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, l.getTitre());
            pstmt.setString(2, l.getAuteurs());
            pstmt.setString(3, l.getISBN());
            return pstmt.executeUpdate() > 0;
        }
    }

    public Livre getLivreByISBN(String ISBN) throws SQLException {
        Livre l = null;
        String sql = "SELECT * FROM livre WHERE ISBN = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, ISBN);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    l = new Livre();
                    l.setISBN(rs.getString("ISBN"));
                    l.setTitre(rs.getString("TITRE"));
                    l.setAuteurs(rs.getString("AUTEURS"));
                }
            }
        }
        return l;
    }
}
