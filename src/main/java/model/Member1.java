package model;

import java.io.Serializable;
import java.util.Date;

public class Member1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String username;
    private String password;
    private String name;
    private Date dob;
    private String tel;
    private String email;
    private String role;

    public Member1() {
    }

    public Member1(String username, String password, String name, Date dob, String tel, String email, String role) {
        this.username = username;
        this.password = password;
        this.name = name;
        this.dob = dob;
        this.tel = tel;
        this.email = email;
        this.role = role;
    }

    public Member1(int id, String username, String password, String name, Date dob, String tel, String email, String role) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.name = name;
        this.dob = dob;
        this.tel = tel;
        this.email = email;
        this.role = role;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }
}
