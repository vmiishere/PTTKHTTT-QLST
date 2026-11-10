package model;

import java.io.Serializable;

public class Address1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String houseNumber;
    private String street;
    private String ward;
    private String city;

    public Address1() {
    }

    public Address1(String houseNumber, String street, String ward, String city) {
        this.houseNumber = houseNumber;
        this.street = street;
        this.ward = ward;
        this.city = city;
    }

    public Address1(int id, String houseNumber, String street, String ward, String city) {
        this.id = id;
        this.houseNumber = houseNumber;
        this.street = street;
        this.ward = ward;
        this.city = city;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getHouseNumber() {
        return houseNumber;
    }

    public void setHouseNumber(String houseNumber) {
        this.houseNumber = houseNumber;
    }

    public String getStreet() {
        return street;
    }

    public void setStreet(String street) {
        this.street = street;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        if (houseNumber != null && !houseNumber.trim().isEmpty()) {
            sb.append(houseNumber).append(", ");
        }
        sb.append(street).append(", ").append(ward).append(", ").append(city);
        return sb.toString();
    }
}
