package model;

import java.io.Serializable;
import java.util.Date;

public class OnlineOrder1 extends Invoice1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private String shippingAddress;
    private Date deliveryDate;
    private WarehouseStaff1 staff;

    public OnlineOrder1() {
        super();
    }

    public OnlineOrder1(int id, String invoiceCode, Date paymentDate, String paymentType, String status, 
                        double totalAmount, Customer1 customer, String note, 
                        String shippingAddress, Date deliveryDate, WarehouseStaff1 staff) {
        super(id, invoiceCode, paymentDate, paymentType, status, totalAmount, customer, staff, note);
        this.shippingAddress = shippingAddress;
        this.deliveryDate = deliveryDate;
        this.staff = staff;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public Date getDeliveryDate() {
        return deliveryDate;
    }

    public void setDeliveryDate(Date deliveryDate) {
        this.deliveryDate = deliveryDate;
    }

    public WarehouseStaff1 getWarehouseStaff() {
        return staff;
    }

    public void setWarehouseStaff(WarehouseStaff1 staff) {
        this.staff = staff;
        setStaff(staff);
    }
}
