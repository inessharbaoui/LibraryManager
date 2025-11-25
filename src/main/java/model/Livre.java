package model;

public class Livre {
    private String ISBN;
    private String titre;
    private String auteurs;

    // Constructeur vide
    public Livre() {}

    // Constructeur avec paramètres
    public Livre(String ISBN, String titre, String auteurs) {
        this.ISBN = ISBN;
        this.titre = titre;
        this.auteurs = auteurs;
    }

    // Getters et Setters
    public String getISBN() {
        return ISBN;
    }
    public void setISBN(String ISBN) {
        this.ISBN = ISBN;
    }

    public String getTitre() {
        return titre;
    }
    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getAuteurs() {
        return auteurs;
    }
    public void setAuteurs(String auteurs) {
        this.auteurs = auteurs;
    }

    @Override
    public String toString() {
        return "Livre [ISBN=" + ISBN + ", titre=" + titre + ", auteurs=" + auteurs + "]";
    }
}
