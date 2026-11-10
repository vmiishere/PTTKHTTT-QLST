package model;

import java.io.Serializable;
import java.util.Date;

public class Manager1 extends Member1 implements Serializable {
    private static final long serialVersionUID = 1L;

    public Manager1() {
        super();
        setRole("MANAGER");
    }

    public Manager1(int id, String username, String password, String name, Date dob, String tel, String email) {
        super(id, username, password, name, dob, tel, email, "MANAGER");
    }
}
