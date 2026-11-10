package model;

import java.io.Serializable;
import java.util.Date;

public class SaleInvoice1 extends Invoice1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private double changeAmount;
    private Cashier1 cashier;

    public SaleInvoice1() {
        super();
    }

    public SaleInvoice1(int id, String invoiceCode, Date paymentDate, String paymentType, String status, 
                        double totalAmount, Customer1 customer, String note, double changeAmount, Cashier1 cashier) {
        super(id, invoiceCode, paymentDate, paymentType, status, totalAmount, customer, cashier, note);
        this.changeAmount = changeAmount;
        this.cashier = cashier;
    }

    public double getChangeAmount() {
        return changeAmount;
    }

    public void setChangeAmount(double changeAmount) {
        this.changeAmount = changeAmount;
    }

    public Cashier1 getCashier() {
        return cashier;
    }

    public void setCashier(Cashier1 cashier) {
        this.cashier = cashier;
        setStaff(cashier);
    }
}
