package dao;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * ============================================================================================
 * LỚP CƠ SỞ: DAO1 (Data Access Object Base Class)
 * VAI TRÒ: 
 *   - Lớp cha của toàn bộ các lớp DAO trong hệ thống (MemberDAO1, CustomerDAO1, ItemStatDAO1, InvoiceDAO1).
 *   - Đảm nhiệm việc khởi tạo, quản lý và tái sử dụng đối tượng kết nối JDBC Connection (con).
 *   - Kết nối trực tiếp tới cơ sở dữ liệu MySQL Server (database: qlst_de10).
 * ============================================================================================
 */
public class DAO1 {
    // Biến kết nối static dùng chung cho toàn bộ các đối tượng DAO kế thừa
    public static Connection con;

    /**
     * Hàm khởi tạo (Constructor) của DAO1.
     * Tự động kiểm tra trạng thái kết nối: nếu chưa kết nối hoặc kết nối đã bị đóng,
     * sẽ tiến hành nạp MySQL JDBC Driver và mở một kết nối mới tới CSDL qlst_de10.
     */
    public DAO1() {
        try {
            if (con == null || con.isClosed()) {
                // Cấu hình chuỗi kết nối JDBC URL: sử dụng cổng mặc định 3306, hỗ trợ tiếng Việt UTF-8 và múi giờ Việt Nam
                String dbUrl = "jdbc:mysql://localhost:3306/qlst_de10?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh";
                String dbClass = "com.mysql.cj.jdbc.Driver";
                
                // Nạp MySQL Driver class vào bộ nhớ JVM
                Class.forName(dbClass);
                
                // Thiết lập kết nối với tài khoản root và mật khẩu CSDL
                con = DriverManager.getConnection(dbUrl, "root", "123456");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
