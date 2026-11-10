package model;

import java.io.Serializable;

public class Item1 implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String itemCode;
    private String name;
    private String brand;
    private String model;
    private double price;
    private String description;
    private int warrantyPeriod = 12; // In months, as specified in UML Class Diagram

    public Item1() {
    }

    public Item1(int id, String itemCode, String name, String brand, String model, double price, String description) {
        this.id = id;
        this.itemCode = itemCode;
        this.name = name;
        this.brand = brand;
        this.model = model;
        this.price = price;
        this.description = description;
        this.warrantyPeriod = 12;
    }

    public Item1(int id, String itemCode, String name, String brand, String model, double price, String description, int warrantyPeriod) {
        this.id = id;
        this.itemCode = itemCode;
        this.name = name;
        this.brand = brand;
        this.model = model;
        this.price = price;
        this.description = description;
        this.warrantyPeriod = warrantyPeriod;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getWarrantyPeriod() {
        return warrantyPeriod;
    }

    public void setWarrantyPeriod(int warrantyPeriod) {
        this.warrantyPeriod = warrantyPeriod;
    }
}
