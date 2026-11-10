package model;

import java.io.Serializable;
import java.util.Date;

public class WarehouseStaff1 extends Member1 implements Serializable {
    private static final long serialVersionUID = 1L;

    public WarehouseStaff1() {
        super();
        setRole("STAFF");
    }

    public WarehouseStaff1(int id, String username, String password, String name, Date dob, String tel, String email) {
        super(id, username, password, name, dob, tel, email, "STAFF");
    }
}
