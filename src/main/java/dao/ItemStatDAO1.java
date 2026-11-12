package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Item1;
import model.ItemStat1;

/**
 * ============================================================================================
 * LỚP TRUY VẤN: ItemStatDAO1 (Data Access Object cho Báo cáo Thống kê Mặt hàng)
 * PHÂN HỆ: Module 2 - Quản lý xem thống kê mặt hàng theo doanh thu
 * KẾ THỪA: DAO1
 * VAI TRÒ CHÍNH:
 *   - Thực thi các câu truy vấn phức tạp kết nối nhiều bảng (JOIN: tblItem1, tblSaleItem1, tblInvoice1).
 *   - Tổng hợp số lượng bán và tính tổng doanh thu theo từng mặt hàng trong khoảng thời gian xác định.
 *   - Lọc chính xác các hóa đơn có trạng thái "Paid" (Đã thanh toán) và sắp xếp giảm dần theo doanh thu.
 * ============================================================================================
 */
public class ItemStatDAO1 extends DAO1 {

    public ItemStatDAO1() {
        super();
    }

    /**
     * ========================================================================================
     * PHƯƠNG THỨC: getItemById
     * VAI TRÒ: Truy vấn thông tin chi tiết của một mặt hàng điện máy dựa trên khóa chính id.
     * 
     * @param itemId Mã định danh ID của mặt hàng
     * @return Item1: Đối tượng mặt hàng đầy đủ thuộc tính, hoặc null nếu không tìm thấy
     * ========================================================================================
     */
    public Item1 getItemById(int itemId) {
        String sql = "SELECT * FROM tblItem1 WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Item1 item = new Item1();
                item.setId(rs.getInt("id"));
                item.setItemCode(rs.getString("itemCode"));
                item.setName(rs.getString("name"));
                item.setBrand(rs.getString("brand"));
                item.setModel(rs.getString("model"));
                item.setPrice(rs.getDouble("price"));
                item.setDescription(rs.getString("description"));
                return item;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ========================================================================================
     * PHƯƠNG THỨC: getItemRevenueStat
     * VAI TRÒ TRONG THIẾT KẾ: Khớp chuẩn 100% với Bước 6 trong Biểu đồ tuần tự Module 2:
     *   "6: getItemRevenueStat(startDate, endDate) -> ItemStatDAO1"
     * 
     * GIẢI THÍCH TRUY VẤN SQL BÁO CÁO:
     *   - Kết nối 3 bảng: tblItem1 (Mặt hàng) JOIN tblSaleItem1 (Dòng hàng) JOIN tblInvoice1 (Hóa đơn).
     *   - Điều kiện lọc:
     *     + inv.status = 'Paid': Chỉ tính các giao dịch thanh toán thành công vào doanh thu siêu thị.
     *     + inv.paymentDate BETWEEN ? AND ?: Lọc chính xác trong khoảng thời gian Quản lý yêu cầu.
     *   - Hàm tổng hợp:
     *     + SUM(si.quantity) AS totalSoldQuantity: Tổng số lượng sản phẩm bán ra của từng mặt hàng.
     *     + SUM(si.amount) AS revenue: Tổng số tiền thu được của từng mặt hàng.
     *   - Sắp xếp: ORDER BY revenue DESC, totalSoldQuantity DESC (Doanh thu cao nhất đứng đầu bảng).
     * 
     * @param startDate Ngày bắt đầu khoảng thời gian thống kê
     * @param endDate Ngày kết thúc khoảng thời gian thống kê
     * @return List<ItemStat1>: Danh sách các đối tượng ItemStat1 kế thừa từ Item1, 
     *                          chứa đầy đủ thông tin mặt hàng kèm totalSoldQuantity và revenue.
     * ========================================================================================
     */
    public List<ItemStat1> getItemRevenueStat(Date startDate, Date endDate) {
        List<ItemStat1> list = new ArrayList<>();
        // Kiểm tra an toàn: nếu khoảng ngày không hợp lệ -> trả về danh sách rỗng
        if (startDate == null || endDate == null || startDate.after(endDate)) {
            return list;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String startStr = sdf.format(startDate);
        String endStr = sdf.format(endDate);

        String sql = "SELECT i.id, i.itemCode, i.name, i.brand, i.model, i.price, i.description, "
                   + "COALESCE(SUM(si.quantity), 0) AS totalSoldQuantity, "
                   + "COALESCE(SUM(si.amount), 0.0) AS revenue "
                   + "FROM tblItem1 i "
                   + "JOIN tblSaleItem1 si ON i.id = si.itemId "
                   + "JOIN tblInvoice1 inv ON si.invoiceId = inv.id "
                   + "WHERE inv.status = 'Paid' AND inv.paymentDate BETWEEN ? AND ? "
                   + "GROUP BY i.id, i.itemCode, i.name, i.brand, i.model, i.price, i.description "
                   + "ORDER BY revenue DESC, totalSoldQuantity DESC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, startStr);
            ps.setString(2, endStr);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ItemStat1 itemStat = new ItemStat1();
                    itemStat.setId(rs.getInt("id"));
                    itemStat.setItemCode(rs.getString("itemCode"));
                    itemStat.setName(rs.getString("name"));
                    itemStat.setBrand(rs.getString("brand"));
                    itemStat.setModel(rs.getString("model"));
                    itemStat.setPrice(rs.getDouble("price"));
                    itemStat.setDescription(rs.getString("description"));
                    
                    // Gán 2 thuộc tính thống kê mở rộng của ItemStat1
                    itemStat.setTotalSoldQuantity(rs.getInt("totalSoldQuantity"));
                    itemStat.setRevenue(rs.getDouble("revenue"));
                    
                    list.add(itemStat);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
