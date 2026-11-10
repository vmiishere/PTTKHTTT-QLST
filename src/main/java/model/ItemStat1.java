package model;

import java.io.Serializable;

public class ItemStat1 extends Item1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int totalSoldQuantity;
    private double revenue;

    public ItemStat1() {
        super();
    }

    public ItemStat1(int id, String itemCode, String name, String brand, String model, double price, 
                     String description, int totalSoldQuantity, double revenue) {
        super(id, itemCode, name, brand, model, price, description);
        this.totalSoldQuantity = totalSoldQuantity;
        this.revenue = revenue;
    }

    public int getTotalSoldQuantity() {
        return totalSoldQuantity;
    }

    public void setTotalSoldQuantity(int totalSoldQuantity) {
        this.totalSoldQuantity = totalSoldQuantity;
    }

    public double getRevenue() {
        return revenue;
    }

    public void setRevenue(double revenue) {
        this.revenue = revenue;
    }
}
