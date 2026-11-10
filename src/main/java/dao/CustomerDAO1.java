package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import model.Customer1;

public class CustomerDAO1 extends DAO1 {

    public CustomerDAO1() {
        super();
    }

    /**
     * Dang ky them moi khach hang vao he thong
     * Luu dong thoi: Address -> Member -> Customer voi Database Transaction
     * @param cust thong tin khach hang
     * @return boolean true neu luu thanh cong, false neu that bai
     */
    public boolean saveCustomer(Customer1 cust) {
        if (cust == null || cust.getUsername() == null || cust.getPassword() == null || cust.getAddress() == null) {
            return false;
        }

        String sqlAddress = "INSERT INTO tblAddress1 (houseNumber, street, ward, city) VALUES (?, ?, ?, ?)";
        String sqlMember = "INSERT INTO tblMember1 (username, password, name, dob, tel, email, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlCustomer = "INSERT INTO tblCustomer1 (id, customerCode, addressId) VALUES (?, ?, ?)";

        boolean defaultAutoCommit = true;
        try {
            defaultAutoCommit = con.getAutoCommit();
            con.setAutoCommit(false);

            // 1. Luu tblAddress1
            PreparedStatement psAddress = con.prepareStatement(sqlAddress, Statement.RETURN_GENERATED_KEYS);
            psAddress.setString(1, cust.getAddress().getHouseNumber() != null ? cust.getAddress().getHouseNumber().trim() : "");
            psAddress.setString(2, cust.getAddress().getStreet() != null ? cust.getAddress().getStreet().trim() : "");
            psAddress.setString(3, cust.getAddress().getWard() != null ? cust.getAddress().getWard().trim() : "");
            psAddress.setString(4, cust.getAddress().getCity() != null ? cust.getAddress().getCity().trim() : "");
            psAddress.executeUpdate();

            ResultSet rsAddr = psAddress.getGeneratedKeys();
            int addressId = 0;
            if (rsAddr.next()) {
                addressId = rsAddr.getInt(1);
                cust.getAddress().setId(addressId);
            }
            rsAddr.close();
            psAddress.close();

            // 2. Luu tblMember1
            PreparedStatement psMember = con.prepareStatement(sqlMember, Statement.RETURN_GENERATED_KEYS);
            psMember.setString(1, cust.getUsername().trim());
            psMember.setString(2, cust.getPassword().trim());
            psMember.setString(3, cust.getName() != null ? cust.getName().trim() : "Customer");
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String dobStr = (cust.getDob() != null) ? sdf.format(cust.getDob()) : "2000-01-01";
            psMember.setString(4, dobStr);
            psMember.setString(5, cust.getTel() != null ? cust.getTel().trim() : "");
            psMember.setString(6, cust.getEmail() != null ? cust.getEmail().trim() : "");
            psMember.setString(7, "CUSTOMER");
            psMember.executeUpdate();

            ResultSet rsMember = psMember.getGeneratedKeys();
            int memberId = 0;
            if (rsMember.next()) {
                memberId = rsMember.getInt(1);
                cust.setId(memberId);
            }
            rsMember.close();
            psMember.close();

            // 3. Luu tblCustomer1
            PreparedStatement psCustomer = con.prepareStatement(sqlCustomer);
            psCustomer.setInt(1, memberId);
            String customerCode = (cust.getCustomerCode() != null && !cust.getCustomerCode().isEmpty()) 
                    ? cust.getCustomerCode() 
                    : ("CUST-" + String.format("%04d", memberId));
            cust.setCustomerCode(customerCode);
            psCustomer.setString(2, customerCode);
            psCustomer.setInt(3, addressId);
            psCustomer.executeUpdate();
            psCustomer.close();

            con.commit();
            con.setAutoCommit(defaultAutoCommit);
            return true;
        } catch (Exception e) {
            try {
                con.rollback();
                con.setAutoCommit(defaultAutoCommit);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            return false;
        }
    }
}
