package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Invoice1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String invoiceCode;
    private Date paymentDate;
    private String paymentType;
    private String status;
    private double totalAmount;
    private Customer1 customer;
    private Member1 staff;
    private String note;
    private List<SaleItem1> saleItems = new ArrayList<>();

    public Invoice1() {
    }

    public Invoice1(int id, String invoiceCode, Date paymentDate, String paymentType, String status, 
                    double totalAmount, Customer1 customer, String note) {
        this.id = id;
        this.invoiceCode = invoiceCode;
        this.paymentDate = paymentDate;
        this.paymentType = paymentType;
        this.status = status;
        this.totalAmount = totalAmount;
        this.customer = customer;
        this.note = note;
    }

    public Invoice1(int id, String invoiceCode, Date paymentDate, String paymentType, String status, 
                    double totalAmount, Customer1 customer, Member1 staff, String note) {
        this.id = id;
        this.invoiceCode = invoiceCode;
        this.paymentDate = paymentDate;
        this.paymentType = paymentType;
        this.status = status;
        this.totalAmount = totalAmount;
        this.customer = customer;
        this.staff = staff;
        this.note = note;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public Date getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Date paymentDate) {
        this.paymentDate = paymentDate;
    }

    public Date getDate() {
        return paymentDate;
    }

    public void setDate(Date date) {
        this.paymentDate = date;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Customer1 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer1 customer) {
        this.customer = customer;
    }

    public Member1 getStaff() {
        return staff;
    }

    public void setStaff(Member1 staff) {
        this.staff = staff;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<SaleItem1> getSaleItems() {
        return saleItems;
    }

    public void setSaleItems(List<SaleItem1> saleItems) {
        this.saleItems = saleItems;
    }
}
