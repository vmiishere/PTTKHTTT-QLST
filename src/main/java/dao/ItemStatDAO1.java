package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.ItemStat1;

public class ItemStatDAO1 extends DAO1 {

    public ItemStatDAO1() {
        super();
    }

    /**
     * Lay thong tin chi tiet mot mat hang theo id
     * @param itemId id cua mat hang
     * @return doi tuong Item1
     */
    public model.Item1 getItemById(int itemId) {
        String sql = "SELECT * FROM tblItem1 WHERE id = ?";
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                model.Item1 item = new model.Item1();
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
     * Thong ke doanh thu theo mat hang trong khoang thoi gian tu startDate den endDate
     * @param startDate ngay bat dau
     * @param endDate ngay ket thuc
     * @return danh sach cac ItemStat1 gom thong tin mat hang, tong so luong da ban va tong doanh thu
     */
    public List<ItemStat1> getItemRevenueStat(Date startDate, Date endDate) {
        List<ItemStat1> list = new ArrayList<>();
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
