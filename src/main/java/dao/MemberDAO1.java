package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Member1;

/**
 * ============================================================================================
 * LỚP TRUY VẤN: MemberDAO1 (Data Access Object cho Thực thể Member1)
 * PHÂN HỆ LIÊN QUAN: Module 1 (Đăng ký thành viên) & Đăng nhập hệ thống
 * KẾ THỪA: DAO1
 * VAI TRÒ CHÍNH:
 *   1. checkUsername(username): Kiểm tra trùng lặp tên đăng nhập trong quá trình khách hàng đăng ký.
 *   2. checkLogin(m): Xác thực thông tin đăng nhập và nạp thông tin phân quyền cho người dùng.
 * ============================================================================================
 */
public class MemberDAO1 extends DAO1 {

    public MemberDAO1() {
        super();
    }

    /**
     * ========================================================================================
     * PHƯƠNG THỨC: checkUsername
     * VAI TRÒ TRONG THIẾT KẾ: Khớp chuẩn 100% với Bước 6 trong Biểu đồ tuần tự (Sequence Diagram)
     *   "6: checkUsername(username) -> MemberDAO1"
     * 
     * @param username Tên tài khoản do khách hàng nhập vào form đăng ký
     * @return boolean:
     *   - true: Tên đăng nhập ĐÃ TỒN TẠI trong bảng tblMember1 (phát sinh lỗi trùng lặp).
     *   - false: Tên đăng nhập CHƯA TỒN TẠI (hợp lệ để cho phép đăng ký mới).
     * ========================================================================================
     */
    public boolean checkUsername(String username) {
        // Kiểm tra an toàn: nếu username rỗng thì trả về false
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        
        // Câu truy vấn chỉ cần tìm bản ghi có username khớp để tối ưu hiệu năng
        String sql = "SELECT id FROM tblMember1 WHERE username = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username.trim());
            ResultSet rs = ps.executeQuery();
            
            // Nếu có kết quả trả về -> đã tồn tại
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ========================================================================================
     * PHƯƠNG THỨC: checkLogin
     * VAI TRÒ: Xác thực thông tin đăng nhập của người dùng vào hệ thống.
     * 
     * @param m Đối tượng Member1 chứa username và password nhận từ form LoginUI1
     * @return boolean:
     *   - true: Đăng nhập thành công, đồng thời tự động nạp đầy đủ id, name, role vào đối tượng m.
     *   - false: Sai tên đăng nhập hoặc mật khẩu.
     * ========================================================================================
     */
    public boolean checkLogin(Member1 m) {
        if (m == null || m.getUsername() == null || m.getPassword() == null) {
            return false;
        }

        String sql = "SELECT * FROM tblMember1 WHERE username = ? AND password = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, m.getUsername().trim());
            ps.setString(2, m.getPassword().trim());
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                // Đăng nhập hợp lệ: Nạp thông tin định danh và vai trò (CUSTOMER, MANAGER, STAFF)
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setDob(rs.getDate("dob"));
                m.setTel(rs.getString("tel"));
                m.setEmail(rs.getString("email"));
                m.setRole(rs.getString("role"));
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
