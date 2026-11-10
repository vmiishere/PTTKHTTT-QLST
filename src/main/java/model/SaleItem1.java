package model;

import java.io.Serializable;

public class SaleItem1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private Item1 item;
    private int quantity;
    private double price;
    private double amount;
    private Invoice1 invoice;

    public SaleItem1() {
    }

    public SaleItem1(int id, Item1 item, int quantity, double price, double amount) {
        this.id = id;
        this.item = item;
        this.quantity = quantity;
        this.price = price;
        this.amount = amount;
    }

    public SaleItem1(int id, Item1 item, int quantity, double price, double amount, Invoice1 invoice) {
        this.id = id;
        this.item = item;
        this.quantity = quantity;
        this.price = price;
        this.amount = amount;
        this.invoice = invoice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Item1 getItem() {
        return item;
    }

    public void setItem(Item1 item) {
        this.item = item;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Invoice1 getInvoice() {
        return invoice;
    }

    public void setInvoice(Invoice1 invoice) {
        this.invoice = invoice;
    }
}
