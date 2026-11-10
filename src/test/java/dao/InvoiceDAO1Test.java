package dao;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import model.Invoice1;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class InvoiceDAO1Test {

    private InvoiceDAO1 invoiceDAO;
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    @Before
    public void setUp() {
        invoiceDAO = new InvoiceDAO1();
    }

    /**
     * Test case TC01: Kiem tra lay giao dich khi ngay bat dau hoac ngay ket thuc null
     */
    @Test
    public void testGetTransactionByItem_NullDates() {
        List<Invoice1> res1 = invoiceDAO.getTransactionByItem(1, null, new Date());
        Assert.assertNotNull(res1);
        Assert.assertTrue(res1.isEmpty());

        List<Invoice1> res2 = invoiceDAO.getTransactionByItem(1, new Date(), null);
        Assert.assertNotNull(res2);
        Assert.assertTrue(res2.isEmpty());
    }

    /**
     * Test case TC02: Kiem tra khi startDate > endDate
     */
    @Test
    public void testGetTransactionByItem_InvalidDateRange() throws Exception {
        Date start = sdf.parse("2026-10-31 00:00:00");
        Date end = sdf.parse("2026-10-01 00:00:00");

        List<Invoice1> res = invoiceDAO.getTransactionByItem(1, start, end);
        Assert.assertNotNull(res);
        Assert.assertTrue("Should return empty list when start date > end date", res.isEmpty());
    }

    /**
     * Test case TC03: Kiem tra lay giao dich theo mat hang hop le co ton tai hoa don
     */
    @Test
    public void testGetTransactionByItem_Success() throws Exception {
        Date start = sdf.parse("2026-10-01 00:00:00");
        Date end = sdf.parse("2026-10-31 23:59:59");

        List<Invoice1> invoices = invoiceDAO.getTransactionByItem(1, start, end);
        Assert.assertNotNull(invoices);
        if (!invoices.isEmpty()) {
            Invoice1 inv = invoices.get(0);
            Assert.assertNotNull(inv.getInvoiceCode());
            Assert.assertTrue(inv.getTotalAmount() > 0);
        }
    }

    /**
     * Test case TC03_B: Kiem tra tat ca giao dich lay ra deu phai co trang thai Paid
     */
    @Test
    public void testGetTransactionByItem_OnlyPaidStatus() throws Exception {
        Date start = sdf.parse("2026-10-01 00:00:00");
        Date end = sdf.parse("2026-10-31 23:59:59");

        List<Invoice1> invoices = invoiceDAO.getTransactionByItem(1, start, end);
        Assert.assertNotNull(invoices);
        Assert.assertFalse("Must have transactions for item #1", invoices.isEmpty());
        for (Invoice1 inv : invoices) {
            Assert.assertEquals("Transaction in revenue breakdown must have status Paid", "Paid", inv.getStatus());
        }
    }

    /**
     * Test case TC04: Kiem tra lay chi tiet mot hoa don ton tai trong DB
     */
    @Test
    public void testGetInvoiceDetail_Exists() {
        Invoice1 inv = invoiceDAO.getInvoiceDetail(1);
        if (inv != null) {
            Assert.assertEquals(1, inv.getId());
            Assert.assertNotNull(inv.getInvoiceCode());
            Assert.assertNotNull(inv.getSaleItems());
            Assert.assertFalse("Invoice should contain sale items", inv.getSaleItems().isEmpty());
            // Test cashier / staff on counter offline sale
            Assert.assertNotNull("Counter offline invoice #1 must have cashier staff", inv.getStaff());
            Assert.assertEquals("David Miller", inv.getStaff().getName());
        }
    }

    /**
     * Test case TC05: Kiem tra lay chi tiet mot hoa don khong ton tai
     */
    @Test
    public void testGetInvoiceDetail_NotExists() {
        Invoice1 inv = invoiceDAO.getInvoiceDetail(-999);
        Assert.assertNull("Should return null for non-existing invoice", inv);
    }
}
