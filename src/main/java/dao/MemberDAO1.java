package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.Member1;

public class MemberDAO1 extends DAO1 {

    public MemberDAO1() {
        super();
    }

    /**
     * Kiem tra xem username da ton tai trong he thong chua
     * @param username ten dang nhap can kiem tra
     * @return true neu da ton tai, false neu chua ton tai
     */
    public boolean checkUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return false;
        }
        String sql = "SELECT id FROM tblMember1 WHERE username = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username.trim());
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Kiem tra dang nhap nguoi dung
     * @param m thong tin Member chua username va password
     * @return boolean true neu dang nhap hop le, nguoc lai false
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
