package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import model.Customer1;

/**
 * ============================================================================================
 * LỚP TRUY VẤN: CustomerDAO1 (Data Access Object cho Thực thể Customer1)
 * PHÂN HỆ: Module 1 - Đăng ký tài khoản thành viên khách hàng
 * KẾ THỪA: DAO1
 * VAI TRÒ CHÍNH:
 *   - Thực thi lưu trữ thông tin khách hàng mới vào CSDL.
 *   - Áp dụng kỹ thuật DATABASE TRANSACTION để bảo đảm tính toàn vẹn dữ liệu (ACID):
 *     + Ghi nhận đồng thời qua 3 bảng liên kết: tblAddress1 -> tblMember1 -> tblCustomer1.
 *     + Nếu một trong 3 bước thất bại, toàn bộ quá trình sẽ được Rollback ngay lập tức.
 * ============================================================================================
 */
public class CustomerDAO1 extends DAO1 {

    public CustomerDAO1() {
        super();
    }

    /**
     * ========================================================================================
     * PHƯƠNG THỨC: saveCustomer
     * VAI TRÒ TRONG THIẾT KẾ: Khớp chuẩn 100% với Bước 8 trong Biểu đồ tuần tự (Sequence Diagram)
     *   "8: saveCustomer(cust) -> CustomerDAO1"
     * 
     * QUY TRÌNH THỰC THI TRANSACTION 3 BẢNG:
     *   Bước 1: Tắt chế độ tự động ghi nhận (con.setAutoCommit(false)) để mở Transaction.
     *   Bước 2: INSERT vào bảng tblAddress1 -> Lấy về addressId tự tăng.
     *   Bước 3: INSERT vào bảng tblMember1 (role = 'CUSTOMER') -> Lấy về memberId tự tăng.
     *   Bước 4: Sinh mã customerCode (dạng CUST-000x) -> INSERT vào bảng tblCustomer1 (id = memberId, addressId).
     *   Bước 5: Gọi con.commit() để xác nhận toàn bộ thay đổi thành công.
     *   Khối catch: Gọi con.rollback() nếu có bất kỳ ngoại lệ nào phát sinh.
     * 
     * @param cust Đối tượng khách hàng chứa đầy đủ thông tin cá nhân, tài khoản và địa chỉ
     * @return boolean: true nếu lưu thành công trọn vẹn, false nếu thất bại
     * ========================================================================================
     */
    public boolean saveCustomer(Customer1 cust) {
        // Kiểm tra an toàn tính toàn vẹn dữ liệu đầu vào
        if (cust == null || cust.getUsername() == null || cust.getPassword() == null || cust.getAddress() == null) {
            return false;
        }

        // 3 câu lệnh SQL tương ứng với 3 bảng liên kết
        String sqlAddress = "INSERT INTO tblAddress1 (houseNumber, street, ward, city) VALUES (?, ?, ?, ?)";
        String sqlMember = "INSERT INTO tblMember1 (username, password, name, dob, tel, email, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String sqlCustomer = "INSERT INTO tblCustomer1 (id, customerCode, addressId) VALUES (?, ?, ?)";

        boolean defaultAutoCommit = true;
        try {
            // Lưu lại trạng thái autoCommit ban đầu và bắt đầu Transaction
            defaultAutoCommit = con.getAutoCommit();
            con.setAutoCommit(false);

            // --------------------------------------------------------------------------------
            // BƯỚC 1: LƯU THÔNG TIN ĐỊA CHỈ (tblAddress1)
            // --------------------------------------------------------------------------------
            PreparedStatement psAddress = con.prepareStatement(sqlAddress, Statement.RETURN_GENERATED_KEYS);
            psAddress.setString(1, cust.getAddress().getHouseNumber() != null ? cust.getAddress().getHouseNumber().trim() : "");
            psAddress.setString(2, cust.getAddress().getStreet() != null ? cust.getAddress().getStreet().trim() : "");
            psAddress.setString(3, cust.getAddress().getWard() != null ? cust.getAddress().getWard().trim() : "");
            psAddress.setString(4, cust.getAddress().getCity() != null ? cust.getAddress().getCity().trim() : "");
            psAddress.executeUpdate();

            // Trích xuất khóa chính id vừa sinh của bảng tblAddress1
            ResultSet rsAddr = psAddress.getGeneratedKeys();
            int addressId = 0;
            if (rsAddr.next()) {
                addressId = rsAddr.getInt(1);
                cust.getAddress().setId(addressId);
            }
            rsAddr.close();
            psAddress.close();

            // --------------------------------------------------------------------------------
            // BƯỚC 2: LƯU TÀI KHOẢN THÀNH VIÊN (tblMember1) VỚI VAI TRÒ CUSTOMER
            // --------------------------------------------------------------------------------
            PreparedStatement psMember = con.prepareStatement(sqlMember, Statement.RETURN_GENERATED_KEYS);
            psMember.setString(1, cust.getUsername().trim());
            psMember.setString(2, cust.getPassword().trim());
            psMember.setString(3, cust.getName() != null ? cust.getName().trim() : "Customer");
            
            // Định dạng ngày sinh theo chuẩn ISO CSDL yyyy-MM-dd
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String dobStr = (cust.getDob() != null) ? sdf.format(cust.getDob()) : "2000-01-01";
            psMember.setString(4, dobStr);
            psMember.setString(5, cust.getTel() != null ? cust.getTel().trim() : "");
            psMember.setString(6, cust.getEmail() != null ? cust.getEmail().trim() : "");
            psMember.setString(7, "CUSTOMER");
            psMember.executeUpdate();

            // Trích xuất khóa chính id vừa sinh của bảng tblMember1
            ResultSet rsMember = psMember.getGeneratedKeys();
            int memberId = 0;
            if (rsMember.next()) {
                memberId = rsMember.getInt(1);
                cust.setId(memberId);
            }
            rsMember.close();
            psMember.close();

            // --------------------------------------------------------------------------------
            // BƯỚC 3: LƯU THỰC THỂ KHÁCH HÀNG (tblCustomer1) KẾ THỪA TỪ MEMBER
            // --------------------------------------------------------------------------------
            PreparedStatement psCustomer = con.prepareStatement(sqlCustomer);
            psCustomer.setInt(1, memberId); // Khóa chính kế thừa từ tblMember1.id
            
            // Tự động sinh mã khách hàng chuẩn dạng CUST-000x nếu chưa có
            String customerCode = (cust.getCustomerCode() != null && !cust.getCustomerCode().isEmpty()) 
                    ? cust.getCustomerCode() 
                    : ("CUST-" + String.format("%04d", memberId));
            cust.setCustomerCode(customerCode);
            psCustomer.setString(2, customerCode);
            psCustomer.setInt(3, addressId); // Khóa ngoại liên kết tới tblAddress1.id
            psCustomer.executeUpdate();
            psCustomer.close();

            // --------------------------------------------------------------------------------
            // BƯỚC 4: COMMIT TRANSACTION HOÀN TẤT
            // --------------------------------------------------------------------------------
            con.commit();
            con.setAutoCommit(defaultAutoCommit);
            return true;

        } catch (Exception e) {
            // Nếu có bất kỳ lỗi nào xảy ra: ROLLBACK để hoàn tác toàn bộ dữ liệu 3 bảng
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
