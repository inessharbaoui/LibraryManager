package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Etudiant;

public class EtudiantDAO {
    private Connection conn;

    public EtudiantDAO(Connection conn) {
        this.conn = conn;
    }

    // LISTER
    public List<Etudiant> getAllEtudiants() throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String sql = "SELECT p.IDPERS, p.NOM, p.PRENOM, p.EMAIL, p.ADRESSE, p.TELEPHONE, e.CLASSE " +
                     "FROM personne p JOIN etudiant e ON p.IDPERS = e.IDETUD";

        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Etudiant e = new Etudiant();
                e.setIdPers(rs.getInt("IDPERS"));
                e.setNom(rs.getString("NOM"));
                e.setPrenom(rs.getString("PRENOM"));
                e.setEmail(rs.getString("EMAIL"));
                e.setAdresse(rs.getString("ADRESSE"));
                e.setTelephone(rs.getString("TELEPHONE"));
                e.setClasse(rs.getString("CLASSE"));
                list.add(e);
            }
        }
        return list;
    }

    // AJOUTER
    public boolean addEtudiant(Etudiant e) throws SQLException {
        String sqlP = "INSERT INTO personne (NOM, PRENOM, EMAIL, ADRESSE, TELEPHONE) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sqlP, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, e.getNom());
            ps.setString(2, e.getPrenom());
            ps.setString(3, e.getEmail());
            ps.setString(4, e.getAdresse());
            ps.setString(5, e.getTelephone());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Échec de l'insertion de la personne, aucune ligne affectée.");
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int id = rs.getInt(1);
                    String sqlE = "INSERT INTO etudiant (IDETUD, CLASSE) VALUES (?, ?)";
                    try (PreparedStatement ps2 = conn.prepareStatement(sqlE)) {
                        ps2.setInt(1, id);
                        ps2.setString(2, e.getClasse());
                        ps2.executeUpdate();
                        return true;
                    }
                } else {
                    throw new SQLException("Échec de la récupération de l'ID généré.");
                }
            }
        }
    }

    // SUPPRIMER
    public boolean deleteEtudiant(int id) throws SQLException {
        PreparedStatement psE = conn.prepareStatement("DELETE FROM etudiant WHERE IDETUD=?");
        PreparedStatement psP = conn.prepareStatement("DELETE FROM personne WHERE IDPERS=?");

        psE.setInt(1, id);
        psP.setInt(1, id);

        psE.executeUpdate();
        return psP.executeUpdate() > 0;
    }

    // CHARGER POUR MODIFIER
    public Etudiant getById(int id) throws SQLException {
        String sql = "SELECT p.IDPERS, p.NOM, p.PRENOM, p.EMAIL, p.ADRESSE, p.TELEPHONE, e.CLASSE " +
                     "FROM personne p JOIN etudiant e ON p.IDPERS = e.IDETUD WHERE IDPERS=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Etudiant e = new Etudiant();
                e.setIdPers(rs.getInt("IDPERS"));
                e.setNom(rs.getString("NOM"));
                e.setPrenom(rs.getString("PRENOM"));
                e.setEmail(rs.getString("EMAIL"));
                e.setAdresse(rs.getString("ADRESSE"));
                e.setTelephone(rs.getString("TELEPHONE"));
                e.setClasse(rs.getString("CLASSE"));
                return e;
            }
        }
        return null;
    }

    // MODIFIER
    public boolean updateEtudiant(Etudiant e) throws SQLException {
        String sqlP = "UPDATE personne SET NOM=?, PRENOM=?, EMAIL=?, ADRESSE=?, TELEPHONE=? WHERE IDPERS=?";
        String sqlE = "UPDATE etudiant SET CLASSE=? WHERE IDETUD=?";

        try (PreparedStatement ps = conn.prepareStatement(sqlP);
             PreparedStatement ps2 = conn.prepareStatement(sqlE)) {

            ps.setString(1, e.getNom());
            ps.setString(2, e.getPrenom());
            ps.setString(3, e.getEmail());
            ps.setString(4, e.getAdresse());
            ps.setString(5, e.getTelephone());
            ps.setInt(6, e.getIdPers());
            ps.executeUpdate();

            ps2.setString(1, e.getClasse());
            ps2.setInt(2, e.getIdPers());
            ps2.executeUpdate();
            return true;
        }
    }

    // RECHERCHER
    public List<Etudiant> search(String key) throws SQLException {
        List<Etudiant> list = new ArrayList<>();
        String sql = "SELECT p.IDPERS, p.NOM, p.PRENOM, p.EMAIL, p.ADRESSE, p.TELEPHONE, e.CLASSE " +
                     "FROM personne p JOIN etudiant e ON p.IDPERS = e.IDETUD " +
                     "WHERE p.NOM LIKE ? OR p.PRENOM LIKE ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + key + "%");
            ps.setString(2, "%" + key + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Etudiant e = new Etudiant();
                e.setIdPers(rs.getInt("IDPERS"));
                e.setNom(rs.getString("NOM"));
                e.setPrenom(rs.getString("PRENOM"));
                e.setEmail(rs.getString("EMAIL"));
                e.setAdresse(rs.getString("ADRESSE"));
                e.setTelephone(rs.getString("TELEPHONE"));
                e.setClasse(rs.getString("CLASSE"));
                list.add(e);
            }
        }
        return list;
    }
}
