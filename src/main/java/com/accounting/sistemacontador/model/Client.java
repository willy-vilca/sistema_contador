
package com.accounting.sistemacontador.model;

public class Client {

    private int clientId;
    private int userId;
    private String fullName;
    private String documentType;
    private String documentNumber;
    private String email;
    private String phone;
    private String address;
    private String companyName;
    private boolean status;

    // Getters y Setters

    public int getClientId() { return clientId; }
    public void setClientId(int clientId) { this.clientId = clientId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getDocumentType() { return documentType; }
    public void setDocumentType(String documentType) { this.documentType = documentType; }

    public String getDocumentNumber() { return documentNumber; }
    public void setDocumentNumber(String documentNumber) { this.documentNumber = documentNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
}
