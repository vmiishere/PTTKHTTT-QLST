package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.Customer1;
import model.Invoice1;
import model.Item1;
import model.Member1;
import model.SaleItem1;

/**
 * ============================================================================================
 * LỚP TRUY VẤN: InvoiceDAO1 (Data Access Object cho Hóa đơn và Chi tiết Giao dịch)
 * PHÂN HỆ: Module 2 - Quản lý xem thống kê mặt hàng theo doanh thu
 * KẾ THỪA: DAO1
 * VAI TRÒ CHÍNH:
 *   1. getTransactionByItem: Lấy danh sách tất cả các hóa đơn bán chứa một mặt hàng cụ thể
 *      trong khoảng thời gian lọc (phục vụ màn hình ItemTransactionDetailUI1.jsp).
 *   2. getInvoiceDetail: Lấy thông tin chi tiết toàn diện của một hóa đơn bao gồm người mua,
 *      thu ngân lập hóa đơn và toàn bộ danh sách các sản phẩm (phục vụ màn hình InvoiceDetailUI1.jsp).
 * ============================================================================================
 */
public class InvoiceDAO1 extends DAO1 {

    public InvoiceDAO1() {
        super();
    }

    /**
     * ========================================================================================
     * PHƯƠNG THỨC: getTransactionByItem
     * VAI TRÒ TRONG THIẾT KẾ: Khớp chuẩn 100% với Bước 11 trong Biểu đồ tuần tự Module 2:
     *   "11: getTransactionByItem(itemId, startDate, endDate) -> InvoiceDAO1"
     * 
     * GIẢI THÍCH TRUY VẤN:
     *   - Kết nối tblInvoice1 JOIN tblSaleItem1 theo khóa ngoại invoiceId.
     *   - Điều kiện lọc:
     *     + si.itemId = ?: Chỉ lấy những hóa đơn có chứa mặt hàng được chọn.
     *     + inv.status = 'Paid': Hóa đơn đã hoàn tất thanh toán.
     *     + inv.paymentDate BETWEEN ? AND ?: Trong khoảng thời gian đang lọc.
     *   - Trích xuất:
     *     + Thông tin chung của hóa đơn: id, invoiceCode, paymentDate, paymentType, status, totalAmount.
     *     + Thông tin riêng của mặt hàng trong hóa đơn: SUM(si.quantity) và SUM(si.amount) 
     *       được đóng gói vào đối tượng SaleItem1 gắn trong Invoice1.getSaleItems().
     *   - Sắp xếp: ORDER BY inv.paymentDate DESC (Giao dịch mới nhất hiển thị trên cùng).
     * 
     * @param itemId ID của mặt hàng cần xem danh sách giao dịch
     * @param startDate Ngày bắt đầu
     * @param endDate Ngày kết thúc
     * @return List<Invoice1>: Danh sách các hóa đơn phát sinh giao dịch của mặt hàng
     * ========================================================================================
     */
    public List<Invoice1> getTransactionByItem(int itemId, Date startDate, Date endDate) {
        List<Invoice1> list = new ArrayList<>();
        if (startDate == null || endDate == null || startDate.after(endDate)) {
            return list;
        }

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String startStr = sdf.format(startDate);
        String endStr = sdf.format(endDate);

        String sql = "SELECT inv.id, inv.invoiceCode, inv.paymentDate, inv.paymentType, inv.status, inv.totalAmount, "
                   + "SUM(si.quantity) AS itemQty, SUM(si.amount) AS itemAmount, inv.note "
                   + "FROM tblInvoice1 inv "
                   + "JOIN tblSaleItem1 si ON inv.id = si.invoiceId "
                   + "WHERE si.itemId = ? AND inv.status = 'Paid' AND inv.paymentDate BETWEEN ? AND ? "
                   + "GROUP BY inv.id, inv.invoiceCode, inv.paymentDate, inv.paymentType, inv.status, inv.totalAmount, inv.note "
                   + "ORDER BY inv.paymentDate DESC";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ps.setString(2, startStr);
            ps.setString(3, endStr);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice1 inv = new Invoice1();
                    inv.setId(rs.getInt("id"));
                    inv.setInvoiceCode(rs.getString("invoiceCode"));
                    inv.setPaymentDate(rs.getTimestamp("paymentDate"));
                    inv.setPaymentType(rs.getString("paymentType"));
                    inv.setStatus(rs.getString("status"));
                    inv.setTotalAmount(rs.getDouble("totalAmount")); // Tổng tiền của cả hóa đơn
                    inv.setNote(rs.getString("note"));

                    // Đóng gói phần đóng góp (số lượng và doanh số) của riêng mặt hàng đang xem
                    SaleItem1 si = new SaleItem1();
                    si.setQuantity(rs.getInt("itemQty"));
                    si.setAmount(rs.getDouble("itemAmount"));
                    inv.getSaleItems().add(si);

                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * ========================================================================================
     * PHƯƠNG THỨC: getInvoiceDetail
     * VAI TRÒ TRONG THIẾT KẾ: Khớp chuẩn 100% với Bước 15 trong Biểu đồ tuần tự Module 2:
     *   "15: getInvoiceDetail(invoiceId) -> InvoiceDAO1"
     * 
     * QUY TRÌNH TRUY VẤN:
     *   1. Truy vấn thông tin tổng thể hóa đơn (sqlInvoice):
     *      - LEFT JOIN tblCustomer1 và tblMember1 để lấy thông tin khách hàng (Tên, SĐT, Email, Mã KH).
     *      - LEFT JOIN tblMember1 để lấy thông tin nhân viên thu ngân lập hóa đơn (Staff Name, Username).
     *   2. Truy vấn danh sách chi tiết các mặt hàng mua trong hóa đơn (sqlSaleItems):
     *      - JOIN tblSaleItem1 với tblItem1 để lấy tên, hãng, model, số lượng, đơn giá và thành tiền của từng món hàng.
     *      - Đóng gói danh sách List<SaleItem1> gắn vào đối tượng Invoice1.
     * 
     * @param invoiceId Mã ID của hóa đơn cần xem chi tiết
     * @return Invoice1: Đối tượng hóa đơn đầy đủ thông tin khách hàng, nhân viên và các dòng hàng
     * ========================================================================================
     */
    public Invoice1 getInvoiceDetail(int invoiceId) {
        Invoice1 inv = null;
        
        // Truy vấn thông tin chung của hóa đơn kèm Khách hàng và Nhân viên
        String sqlInvoice = "SELECT inv.*, "
                          + "m.name AS customerName, m.tel AS customerTel, m.email AS customerEmail, c.customerCode, "
                          + "s.name AS staffName, s.username AS staffUsername "
                          + "FROM tblInvoice1 inv "
                          + "LEFT JOIN tblCustomer1 c ON inv.customerId = c.id "
                          + "LEFT JOIN tblMember1 m ON c.id = m.id "
                          + "LEFT JOIN tblMember1 s ON inv.staffId = s.id "
                          + "WHERE inv.id = ?";

        // Truy vấn danh sách các mặt hàng đã mua trong hóa đơn đó
        String sqlSaleItems = "SELECT si.*, i.itemCode, i.name, i.brand, i.model "
                            + "FROM tblSaleItem1 si "
                            + "JOIN tblItem1 i ON si.itemId = i.id "
                            + "WHERE si.invoiceId = ?";

        try (PreparedStatement ps = con.prepareStatement(sqlInvoice)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    inv = new Invoice1();
                    inv.setId(rs.getInt("id"));
                    inv.setInvoiceCode(rs.getString("invoiceCode"));
                    inv.setPaymentDate(rs.getTimestamp("paymentDate"));
                    inv.setPaymentType(rs.getString("paymentType"));
                    inv.setStatus(rs.getString("status"));
                    inv.setTotalAmount(rs.getDouble("totalAmount"));
                    inv.setNote(rs.getString("note"));

                    // Gán thông tin khách hàng (nếu có)
                    int custId = rs.getInt("customerId");
                    if (custId > 0) {
                        Customer1 cust = new Customer1();
                        cust.setId(custId);
                        cust.setCustomerCode(rs.getString("customerCode"));
                        cust.setName(rs.getString("customerName"));
                        cust.setTel(rs.getString("customerTel"));
                        cust.setEmail(rs.getString("customerEmail"));
                        inv.setCustomer(cust);
                    }

                    // Gán thông tin nhân viên thu ngân (nếu bán trực tiếp tại quầy)
                    int staffId = rs.getInt("staffId");
                    if (!rs.wasNull() && staffId > 0) {
                        Member1 staff = new Member1();
                        staff.setId(staffId);
                        staff.setName(rs.getString("staffName"));
                        staff.setUsername(rs.getString("staffUsername"));
                        inv.setStaff(staff);
                    }

                    // Truy vấn danh sách các dòng hàng (SaleItem1) của hóa đơn
                    try (PreparedStatement psItems = con.prepareStatement(sqlSaleItems)) {
                        psItems.setInt(1, invoiceId);
                        try (ResultSet rsItems = psItems.executeQuery()) {
                            List<SaleItem1> saleList = new ArrayList<>();
                            while (rsItems.next()) {
                                SaleItem1 si = new SaleItem1();
                                si.setId(rsItems.getInt("id"));
                                si.setQuantity(rsItems.getInt("quantity"));
                                si.setPrice(rsItems.getDouble("price"));
                                si.setAmount(rsItems.getDouble("amount"));

                                Item1 itm = new Item1();
                                itm.setId(rsItems.getInt("itemId"));
                                itm.setItemCode(rsItems.getString("itemCode"));
                                itm.setName(rsItems.getString("name"));
                                itm.setBrand(rsItems.getString("brand"));
                                itm.setModel(rsItems.getString("model"));
                                si.setItem(itm);

                                saleList.add(si);
                            }
                            inv.setSaleItems(saleList);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return inv;
    }
}
