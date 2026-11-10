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
import model.SaleItem1;

public class InvoiceDAO1 extends DAO1 {

    public InvoiceDAO1() {
        super();
    }

    /**
     * Lay danh sach cac hoa don / giao dich co chua mat hang itemId trong khoang thoi gian
     * @param itemId id cua mat hang can tra cuu
     * @param startDate ngay bat dau
     * @param endDate ngay ket thuc
     * @return danh sach cac Invoice1 tuong ung
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
                    inv.setTotalAmount(rs.getDouble("totalAmount")); // Entire invoice total
                    inv.setNote(rs.getString("note"));

                    // Store item-specific sale contribution in saleItems list
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
     * Lay chi tiet mot hoa don kem danh sach cac mat hang da ban
     * @param invoiceId id cua hoa don
     * @return doi tuong Invoice1 day du thong tin khach hang va dong hang (SaleItem1)
     */
    public Invoice1 getInvoiceDetail(int invoiceId) {
        Invoice1 inv = null;
        String sqlInvoice = "SELECT inv.*, "
                          + "m.name AS customerName, m.tel AS customerTel, m.email AS customerEmail, c.customerCode, "
                          + "s.name AS staffName, s.username AS staffUsername "
                          + "FROM tblInvoice1 inv "
                          + "LEFT JOIN tblCustomer1 c ON inv.customerId = c.id "
                          + "LEFT JOIN tblMember1 m ON c.id = m.id "
                          + "LEFT JOIN tblMember1 s ON inv.staffId = s.id "
                          + "WHERE inv.id = ?";

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

                    int staffId = rs.getInt("staffId");
                    if (!rs.wasNull() && staffId > 0) {
                        model.Member1 staff = new model.Member1();
                        staff.setId(staffId);
                        staff.setName(rs.getString("staffName"));
                        staff.setUsername(rs.getString("staffUsername"));
                        inv.setStaff(staff);
                    }

                    // Lay danh sach cac dong hang trong hoa don
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
