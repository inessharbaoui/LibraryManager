package model;

import java.util.Date;

public class Reservation {
    private int idRes;
    private String isbn;
    private int idPers;
    private String nomPrenom;
    private String titreLivre;
    private Date dateRes;
    private String status;

    public int getIdRes() { return idRes; }
    public void setIdRes(int idRes) { this.idRes = idRes; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public int getIdPers() { return idPers; }
    public void setIdPers(int idPers) { this.idPers = idPers; }

    public String getNomPrenom() { return nomPrenom; }
    public void setNomPrenom(String nomPrenom) { this.nomPrenom = nomPrenom; }

    public String getTitreLivre() { return titreLivre; }
    public void setTitreLivre(String titreLivre) { this.titreLivre = titreLivre; }

    public Date getDateRes() { return dateRes; }
    public void setDateRes(Date dateRes) { this.dateRes = dateRes; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
