package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO1 {
    public static Connection con;

    public DAO1() {
        try {
            if (con == null || con.isClosed()) {
                String dbUrl = "jdbc:mysql://localhost:3306/qlst_de10?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Ho_Chi_Minh";
                String dbClass = "com.mysql.cj.jdbc.Driver";
                Class.forName(dbClass);
                con = DriverManager.getConnection(dbUrl, "root", "123456");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
