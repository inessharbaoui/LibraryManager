package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Enseignant;

public class EnseignantDAO {
    private Connection conn;

    public EnseignantDAO(Connection conn) {
        this.conn = conn;
    }

    // LISTER
    public List<Enseignant> getAllEnseignants() throws SQLException {
        List<Enseignant> list = new ArrayList<>();
        String sql = "SELECT p.IDPERS, p.NOM, p.PRENOM, p.EMAIL, p.ADRESSE, p.TELEPHONE, e.GRADE, e.DEPARTEMENT " +
                     "FROM personne p JOIN enseignant e ON p.IDPERS = e.IDENS";

        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Enseignant e = new Enseignant();
                e.setIdPers(rs.getInt("IDPERS"));
                e.setNom(rs.getString("NOM"));
                e.setPrenom(rs.getString("PRENOM"));
                e.setEmail(rs.getString("EMAIL"));
                e.setAdresse(rs.getString("ADRESSE"));
                e.setTelephone(rs.getString("TELEPHONE"));
                e.setGrade(rs.getString("GRADE"));
                e.setDepartement(rs.getString("DEPARTEMENT"));
                list.add(e);
            }
        }
        return list;
    }

    // AJOUTER
    public boolean addEnseignant(Enseignant e) throws SQLException {
        String sqlP = "INSERT INTO personne (NOM, PRENOM, EMAIL, ADRESSE, TELEPHONE) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sqlP, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getNom());
            ps.setString(2, e.getPrenom());
            ps.setString(3, e.getEmail());
            ps.setString(4, e.getAdresse());
            ps.setString(5, e.getTelephone());
            int affected = ps.executeUpdate();
            if (affected == 0) return false;

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    String sqlE = "INSERT INTO enseignant (IDENS, GRADE, DEPARTEMENT) VALUES (?, ?, ?)";
                    try (PreparedStatement ps2 = conn.prepareStatement(sqlE)) {
                        ps2.setInt(1, id);
                        ps2.setString(2, e.getGrade());
                        ps2.setString(3, e.getDepartement());
                        return ps2.executeUpdate() > 0;
                    }
                }
            }
        }
        return false;
    }

    // SUPPRIMER
    public boolean deleteEnseignant(int id) throws SQLException {
        String sqlE = "DELETE FROM enseignant WHERE IDENS=?";
        String sqlP = "DELETE FROM personne WHERE IDPERS=?";
        try (PreparedStatement psE = conn.prepareStatement(sqlE);
             PreparedStatement psP = conn.prepareStatement(sqlP)) {

            psE.setInt(1, id);
            psE.executeUpdate();

            psP.setInt(1, id);
            return psP.executeUpdate() > 0;
        }
    }

    // CHARGER POUR MODIFIER
    public Enseignant getById(int id) throws SQLException {
        String sql = "SELECT p.IDPERS, p.NOM, p.PRENOM, p.EMAIL, p.ADRESSE, p.TELEPHONE, e.GRADE, e.DEPARTEMENT " +
                     "FROM personne p JOIN enseignant e ON p.IDPERS = e.IDENS WHERE IDPERS=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Enseignant e = new Enseignant();
                e.setIdPers(rs.getInt("IDPERS"));
                e.setNom(rs.getString("NOM"));
                e.setPrenom(rs.getString("PRENOM"));
                e.setEmail(rs.getString("EMAIL"));
                e.setAdresse(rs.getString("ADRESSE"));
                e.setTelephone(rs.getString("TELEPHONE"));
                e.setGrade(rs.getString("GRADE"));
                e.setDepartement(rs.getString("DEPARTEMENT"));
                return e;
            }
        }
        return null;
    }

    // MODIFIER
    public boolean updateEnseignant(Enseignant e) throws SQLException {
        String sqlP = "UPDATE personne SET NOM=?, PRENOM=?, EMAIL=?, ADRESSE=?, TELEPHONE=? WHERE IDPERS=?";
        String sqlE = "UPDATE enseignant SET GRADE=?, DEPARTEMENT=? WHERE IDENS=?";
        try (PreparedStatement ps = conn.prepareStatement(sqlP);
             PreparedStatement ps2 = conn.prepareStatement(sqlE)) {

            ps.setString(1, e.getNom());
            ps.setString(2, e.getPrenom());
            ps.setString(3, e.getEmail());
            ps.setString(4, e.getAdresse());
            ps.setString(5, e.getTelephone());
            ps.setInt(6, e.getIdPers());
            ps.executeUpdate();

            ps2.setString(1, e.getGrade());
            ps2.setString(2, e.getDepartement());
            ps2.setInt(3, e.getIdPers());
            return ps2.executeUpdate() > 0;
        }
    }

    // RECHERCHER
    public List<Enseignant> search(String key) throws SQLException {
        List<Enseignant> list = new ArrayList<>();
        String sql = "SELECT p.IDPERS, p.NOM, p.PRENOM, p.EMAIL, p.ADRESSE, p.TELEPHONE, e.GRADE, e.DEPARTEMENT " +
                     "FROM personne p JOIN enseignant e ON p.IDPERS = e.IDENS " +
                     "WHERE p.NOM LIKE ? OR p.PRENOM LIKE ? OR e.GRADE LIKE ? OR e.DEPARTEMENT LIKE ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            String pattern = "%" + key + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Enseignant e = new Enseignant();
                e.setIdPers(rs.getInt("IDPERS"));
                e.setNom(rs.getString("NOM"));
                e.setPrenom(rs.getString("PRENOM"));
                e.setEmail(rs.getString("EMAIL"));
                e.setAdresse(rs.getString("ADRESSE"));
                e.setTelephone(rs.getString("TELEPHONE"));
                e.setGrade(rs.getString("GRADE"));
                e.setDepartement(rs.getString("DEPARTEMENT"));
                list.add(e);
            }
        }
        return list;
    }
}
