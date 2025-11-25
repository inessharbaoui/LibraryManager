package model;

import java.util.Date;

public class Emprunt {
    private int idEmp;
    private Date dateEmp;
    private Date dateRetour;
    private int idRes;
    private String nomPrenom;  // depuis Reservation
    private String titreLivre; // depuis Reservation

    public int getIdEmp() { return idEmp; }
    public void setIdEmp(int idEmp) { this.idEmp = idEmp; }

    public Date getDateEmp() { return dateEmp; }
    public void setDateEmp(Date dateEmp) { this.dateEmp = dateEmp; }

    public Date getDateRetour() { return dateRetour; }
    public void setDateRetour(Date dateRetour) { this.dateRetour = dateRetour; }

    public int getIdRes() { return idRes; }
    public void setIdRes(int idRes) { this.idRes = idRes; }

    public String getNomPrenom() { return nomPrenom; }
    public void setNomPrenom(String nomPrenom) { this.nomPrenom = nomPrenom; }

    public String getTitreLivre() { return titreLivre; }
    public void setTitreLivre(String titreLivre) { this.titreLivre = titreLivre; }
}
