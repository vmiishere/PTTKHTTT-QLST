package dao;

import java.util.Date;
import model.Address1;
import model.Customer1;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

public class CustomerDAO1Test {

    private CustomerDAO1 customerDAO;
    private MemberDAO1 memberDAO;

    @Before
    public void setUp() {
        customerDAO = new CustomerDAO1();
        memberDAO = new MemberDAO1();
    }

    /**
     * Test case TC01: Kiem tra trung lap voi username da ton tai trong CSDL qua MemberDAO1
     */
    @Test
    public void testCheckUsername_Exists() {
        String existingUsername = "johnsmith99";
        boolean isDuplicate = memberDAO.checkUsername(existingUsername);
        Assert.assertTrue("Username 'johnsmith99' should already exist in DB", isDuplicate);
    }

    /**
     * Test case TC02: Kiem tra voi username chua tung ton tai
     */
    @Test
    public void testCheckUsername_NotExists() {
        String newUsername = "non_existing_user_" + System.currentTimeMillis();
        boolean isDuplicate = memberDAO.checkUsername(newUsername);
        Assert.assertFalse("New unique username should not exist", isDuplicate);
    }

    /**
     * Test case TC03: Kiem tra voi username null hoac rong
     */
    @Test
    public void testCheckUsername_NullOrEmpty() {
        Assert.assertFalse(memberDAO.checkUsername(null));
        Assert.assertFalse(memberDAO.checkUsername(""));
        Assert.assertFalse(memberDAO.checkUsername("   "));
    }

    /**
     * Test case TC04: Them khach hang voi thong tin null
     */
    @Test
    public void testSaveCustomer_NullCustomer() {
        boolean result = customerDAO.saveCustomer(null);
        Assert.assertFalse("saveCustomer should fail with null customer", result);
    }

    /**
     * Test case TC05: Them khach hang hop le
     */
    @Test
    public void testSaveCustomer_Success() {
        String uniqueUsername = "testcust_" + System.currentTimeMillis();
        Address1 addr = new Address1("123", "Cau Giay", "Dich Vong", "Hanoi");
        Customer1 cust = new Customer1(uniqueUsername, "Pass@123", "Nguyen Test Customer", new Date(), "0912345678", uniqueUsername + "@gmail.com", null, addr);

        boolean result = customerDAO.saveCustomer(cust);
        Assert.assertTrue("saveCustomer should succeed with valid new customer", result);
        Assert.assertTrue("Customer ID should be auto-generated > 0", cust.getId() > 0);
        Assert.assertNotNull("CustomerCode should be generated", cust.getCustomerCode());
    }
}
