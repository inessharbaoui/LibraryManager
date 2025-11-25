package model;

public class Etudiant {

    private int idPers;
    private String nom;
    private String prenom;
    private String email;
    private String adresse;
    private String telephone;
    private String classe;

    public int getIdPers() { return idPers; }
    public void setIdPers(int idPers) { this.idPers = idPers; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getClasse() { return classe; }
    public void setClasse(String classe) { this.classe = classe; }
}
