package dao;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import model.ItemStat1;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class ItemStatDAO1Test {

    private ItemStatDAO1 itemStatDAO;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Before
    public void setUp() {
        itemStatDAO = new ItemStatDAO1();
    }

    /**
     * Test case TC01: Kiem tra voi startDate hoac endDate la null
     */
    @Test
    public void testGetItemRevenueStat_NullDates() {
        List<ItemStat1> res1 = itemStatDAO.getItemRevenueStat(null, new Date());
        Assert.assertNotNull(res1);
        Assert.assertTrue(res1.isEmpty());

        List<ItemStat1> res2 = itemStatDAO.getItemRevenueStat(new Date(), null);
        Assert.assertNotNull(res2);
        Assert.assertTrue(res2.isEmpty());
    }

    /**
     * Test case TC02: Kiem tra voi startDate lon hon endDate
     */
    @Test
    public void testGetItemRevenueStat_StartDateAfterEndDate() throws Exception {
        Date start = sdf.parse("2026-10-31 00:00:00");
        Date end = sdf.parse("2026-10-01 00:00:00");

        List<ItemStat1> res = itemStatDAO.getItemRevenueStat(start, end);
        Assert.assertNotNull(res);
        Assert.assertTrue("Should return empty list when start date > end date", res.isEmpty());
    }

    /**
     * Test case TC03: Kiem tra khoang thoi gian hop le co du lieu ban hang
     */
    @Test
    public void testGetItemRevenueStat_ValidRangeWithData() throws Exception {
        Date start = sdf.parse("2026-10-01 00:00:00");
        Date end = sdf.parse("2026-10-31 23:59:59");

        List<ItemStat1> res = itemStatDAO.getItemRevenueStat(start, end);
        Assert.assertNotNull(res);
        if (!res.isEmpty()) {
            ItemStat1 topItem = res.get(0);
            Assert.assertTrue("Revenue must be greater than 0", topItem.getRevenue() > 0);
            Assert.assertTrue("Total sold quantity must be greater than 0", topItem.getTotalSoldQuantity() > 0);
            Assert.assertNotNull("Item code must not be null", topItem.getItemCode());
        }
    }
}
