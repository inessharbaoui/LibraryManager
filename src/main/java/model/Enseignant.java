package model;

public class Enseignant {
    private int idPers;
    private String nom;
    private String prenom;
    private String email;
    private String adresse;
    private String telephone;
    private String grade;
    private String departement;
    private String login;  // added
    private String pass;   // added

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

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    public String getDepartement() { return departement; }
    public void setDepartement(String departement) { this.departement = departement; }

    public String getLogin() { return login; }
    public void setLogin(String login) { this.login = login; }

    public String getPass() { return pass; }
    public void setPass(String pass) { this.pass = pass; }
}
