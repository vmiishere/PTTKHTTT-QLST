package model;

import java.io.Serializable;
import java.util.Date;

public class Customer1 extends Member1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private String customerCode;
    private Address1 address;

    public Customer1() {
        super();
        setRole("CUSTOMER");
    }

    public Customer1(String username, String password, String name, Date dob, String tel, String email, 
                     String customerCode, Address1 address) {
        super(username, password, name, dob, tel, email, "CUSTOMER");
        this.customerCode = customerCode;
        this.address = address;
    }

    public Customer1(int id, String username, String password, String name, Date dob, String tel, String email, 
                     String customerCode, Address1 address) {
        super(id, username, password, name, dob, tel, email, "CUSTOMER");
        this.customerCode = customerCode;
        this.address = address;
    }

    public String getCustomerCode() {
        return customerCode;
    }

    public void setCustomerCode(String customerCode) {
        this.customerCode = customerCode;
    }

    public Address1 getAddress() {
        return address;
    }

    public void setAddress(Address1 address) {
        this.address = address;
    }
}
