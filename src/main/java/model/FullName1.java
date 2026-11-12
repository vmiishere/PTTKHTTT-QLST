package model;

import java.io.Serializable;

public class FullName1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String firstName;
    private String middleName;
    private String lastName;

    public FullName1() {
    }

    public FullName1(String firstName, String middleName, String lastName) {
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
    }

    public FullName1(int id, String firstName, String middleName, String lastName) {
        this.id = id;
        this.firstName = firstName;
        this.middleName = middleName;
        this.lastName = lastName;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getMiddleName() {
        return middleName;
    }

    public void setMiddleName(String middleName) {
        this.middleName = middleName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        if (lastName != null && !lastName.isEmpty()) sb.append(lastName).append(" ");
        if (middleName != null && !middleName.isEmpty()) sb.append(middleName).append(" ");
        if (firstName != null && !firstName.isEmpty()) sb.append(firstName);
        return sb.toString().trim();
    }
}
