-- ============================================================
-- DATABASE SCHEMA & RICH SEED DATA: ELECTRONICS SUPERMARKET MANAGEMENT SYSTEM (SMS)
-- COURSE: ANALYSIS AND DESIGN OF INFORMATION SYSTEMS (PTIT)
-- ============================================================

DROP DATABASE IF EXISTS qlst_de10;
CREATE DATABASE qlst_de10 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE qlst_de10;

-- 1. Table tblAddress1
CREATE TABLE tblAddress1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    houseNumber VARCHAR(100),
    street VARCHAR(150) NOT NULL,
    ward VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Table tblMember1 (System users)
CREATE TABLE tblMember1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    name VARCHAR(150) NOT NULL,
    dob DATE NOT NULL,
    tel VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(30) NOT NULL -- 'CUSTOMER', 'MANAGER', 'STAFF'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Table tblCustomer1 (Inherits Member1)
CREATE TABLE tblCustomer1 (
    id INT PRIMARY KEY,
    customerCode VARCHAR(50) NOT NULL UNIQUE,
    addressId INT NOT NULL,
    CONSTRAINT fk_customer_member FOREIGN KEY (id) REFERENCES tblMember1(id) ON DELETE CASCADE,
    CONSTRAINT fk_customer_address FOREIGN KEY (addressId) REFERENCES tblAddress1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Table tblItem1 (Electronic Items)
CREATE TABLE tblItem1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    itemCode VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(200) NOT NULL,
    brand VARCHAR(100) NOT NULL,
    model VARCHAR(100) NOT NULL,
    price DOUBLE NOT NULL DEFAULT 0.0,
    description TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Table tblInvoice1 (Sales Invoices)
CREATE TABLE tblInvoice1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoiceCode VARCHAR(50) NOT NULL UNIQUE,
    paymentDate DATETIME NOT NULL,
    paymentType VARCHAR(50) NOT NULL, -- 'Cash', 'Card / Transfer'
    status VARCHAR(50) NOT NULL DEFAULT 'Paid', -- 'Paid', 'Pending', 'Refunded', 'Cancelled'
    totalAmount DOUBLE NOT NULL DEFAULT 0.0,
    customerId INT,
    staffId INT NULL, -- Cashier / Sales Staff (if counter offline purchase)
    note TEXT,
    CONSTRAINT fk_invoice_customer FOREIGN KEY (customerId) REFERENCES tblCustomer1(id),
    CONSTRAINT fk_invoice_staff FOREIGN KEY (staffId) REFERENCES tblMember1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Table tblSaleItem1 (Invoice line items)
CREATE TABLE tblSaleItem1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    invoiceId INT NOT NULL,
    itemId INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DOUBLE NOT NULL DEFAULT 0.0,
    discount DOUBLE NOT NULL DEFAULT 0.0,
    amount DOUBLE NOT NULL DEFAULT 0.0,
    CONSTRAINT fk_sale_invoice FOREIGN KEY (invoiceId) REFERENCES tblInvoice1(id) ON DELETE CASCADE,
    CONSTRAINT fk_sale_item FOREIGN KEY (itemId) REFERENCES tblItem1(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- SEED DATA (REALISTIC MULTI-ITEM BASKETS & DIVERSE STATUSES)
-- ============================================================

INSERT INTO tblAddress1 (id, houseNumber, street, ward, city) VALUES
(1, 'Apt 4B, No. 742', 'Broadway Avenue', 'Midtown', 'New York'),
(2, 'No. 10', 'Tran Phu Street', 'Ha Dong', 'Hanoi'),
(3, 'Villa 18, Lakeview Residence', 'Nguyen Huu Tho Street', 'Tan Phong', 'Ho Chi Minh City'),
(4, 'No. 88', 'Cau Giay Street', 'Quan Hoa', 'Hanoi');

INSERT INTO tblMember1 (id, username, password, name, dob, tel, email, role) VALUES
(1, 'manager01', '123456', 'Arthur Dent', '1985-01-15', '0912345678', 'manager@sms.com', 'MANAGER'),
(2, 'johnsmith99', 'password123', 'John Robert Smith', '1998-05-15', '+1 555-019-2834', 'john.smith@example.com', 'CUSTOMER'),
(3, 'emmawatson', 'pass123', 'Emma Watson', '2000-08-20', '0988776655', 'emma.watson@email.com', 'CUSTOMER'),
(4, 'davidm', '123456', 'David Miller', '1995-06-12', '0933445566', 'david.miller@sms.com', 'STAFF'),
(5, 'emilyc', '123456', 'Emily Clark', '1996-09-25', '0944556677', 'emily.clark@sms.com', 'STAFF'),
(6, 'annguyen', 'pass123', 'Nguyen Van An', '1997-03-10', '0977889900', 'annguyen@email.com', 'CUSTOMER'),
(7, 'michaelj', 'pass123', 'Michael Johnson', '1994-11-05', '0966112233', 'michael.j@email.com', 'CUSTOMER');

INSERT INTO tblCustomer1 (id, customerCode, addressId) VALUES
(2, 'CUST-0001', 1),
(3, 'CUST-0002', 2),
(6, 'CUST-0003', 3),
(7, 'CUST-0004', 4);

INSERT INTO tblItem1 (id, itemCode, name, brand, model, price, description) VALUES
(1, 'ITM-01', 'Sony Bravia 4K Smart TV 55"', 'Sony', 'KD-55X80L', 590.00, '55 inch 4K HDR Google TV with Triluminos Pro'),
(2, 'ITM-02', 'LG AI DD Front Load Washer 9kg', 'LG', 'FV1409S4W', 360.00, 'Direct Drive Front Load Washer with Steam Cycle'),
(3, 'ITM-03', 'Panasonic Inverter Air Conditioner 1.5HP', 'Panasonic', 'CU/CS-PU12XKH-8M', 480.00, 'Inverter AC Energy Saving with Nanoe-G Air Purification'),
(4, 'ITM-04', 'Daikin Inverter AC 1.0HP', 'Daikin', 'FTKB25XVMV', 420.00, 'Inverter 1HP Rapid Cooling with Coanda Airflow'),
(5, 'ITM-05', 'Samsung Inverter Refrigerator 380L', 'Samsung', 'RT38CG6584S9', 450.00, 'Optimal Fresh+ SpaceMax Dual Cooling Refrigerator'),
(6, 'ITM-06', 'Bosch Serie 6 Built-in Dishwasher', 'Bosch', 'SMS6ZCI49E', 850.00, 'PerfectDry Zeolith Technology with 14 Place Settings'),
(7, 'ITM-07', 'Panasonic Convection Microwave Oven 27L', 'Panasonic', 'NN-CD58JSYUE', 220.00, 'Inverter Convection Microwave with Auto Cooking Menus'),
(8, 'ITM-08', 'Dyson V12 Detect Slim Cordless Vacuum', 'Dyson', 'V12-Slim', 620.00, 'Laser Slim Fluffy cleaner head with Piezo sensor'),
(9, 'ITM-09', 'Philips 5000 Series Air Purifier', 'Philips', 'AC2887/10', 290.00, 'AeraSense Technology HEPA filter for rooms up to 79m2'),
(10, 'ITM-10', 'Apple MacBook Air 13" M3', 'Apple', 'MRXN3SA/A', 1099.00, 'Apple M3 chip 8-core CPU 10-core GPU 16GB RAM 512GB SSD');

-- Invoices across October 2026:
-- Invoices 1 to 18 are Completed Sales ('Paid') making up the verified October Revenue.
-- Invoices 19 to 22 demonstrate diverse supermarket lifecycle states: Pending, Refunded, Cancelled.
INSERT INTO tblInvoice1 (id, invoiceCode, paymentDate, paymentType, status, totalAmount, customerId, staffId, note) VALUES
(1,  'INV-0101', '2026-10-02 14:35:00', 'Card / Transfer', 'Paid',      1180.00, 2, 4,    'Customer purchased at counter'),
(2,  'INV-0102', '2026-10-03 10:15:00', 'Cash',            'Paid',       580.00, 3, 4,    'Counter walk-in payment (Washer + Microwave)'),
(3,  'INV-0103', '2026-10-05 16:40:00', 'Card / Transfer', 'Paid',      1099.00, 6, 5,    'Cashier assisted checkout'),
(4,  'INV-0104', '2026-10-08 09:20:00', 'Cash',            'Paid',      1210.00, 7, 4,    'In-store promotion applied (TV + Vacuum combo)'),
(5,  'INV-0105', '2026-10-10 11:30:00', 'Card / Transfer', 'Paid',       900.00, 2, 5,    'Direct payment via POS (Panasonic + Daikin ACs)'),
(6,  'INV-0106', '2026-10-12 15:10:00', 'Card / Transfer', 'Paid',       450.00, 3, NULL, 'Online order - Home delivery completed'),
(7,  'INV-0107', '2026-10-14 14:00:00', 'Card / Transfer', 'Paid',      1140.00, 6, 4,    'Full package delivery and installation (Dishwasher + Purifier)'),
(8,  'INV-0108', '2026-10-16 17:25:00', 'Cash',            'Paid',      1180.00, 7, 5,    'Customer purchased at counter'),
(9,  'INV-0109', '2026-10-18 13:45:00', 'Card / Transfer', 'Paid',       810.00, 2, 4,    'Combo discount purchase (Washer + Fridge)'),
(10, 'INV-0110', '2026-10-20 10:50:00', 'Card / Transfer', 'Paid',      1240.00, 6, 5,    'Two units purchased for office'),
(11, 'INV-0111', '2026-10-22 16:15:00', 'Cash',            'Paid',      1070.00, 3, 4,    'Counter walk-in payment (TV + AC package)'),
(12, 'INV-0112', '2026-10-24 11:20:00', 'Card / Transfer', 'Paid',      1099.00, 7, 5,    'Premium membership transaction'),
(13, 'INV-0113', '2026-10-25 14:10:00', 'Card / Transfer', 'Paid',      1070.00, 2, 4,    'Kitchen appliance upgrade (Dishwasher + Microwave)'),
(14, 'INV-0114', '2026-10-26 09:30:00', 'Cash',            'Paid',       710.00, 6, 5,    'Counter payment (Daikin AC + Purifier)'),
(15, 'INV-0115', '2026-10-27 15:45:00', 'Card / Transfer', 'Paid',      1719.00, 3, 4,    'Weekend sale counter purchase (MacBook + Dyson Vacuum)'),
(16, 'INV-0116', '2026-10-28 16:30:00', 'Cash',            'Paid',       900.00, 7, 4,    'Dual AC installation project (Panasonic + Daikin)'),
(17, 'INV-0117', '2026-10-29 11:15:00', 'Card / Transfer', 'Paid',       810.00, 2, 5,    'Apartment appliance bundle (Washer + Refrigerator)'),
(18, 'INV-0118', '2026-10-30 10:40:00', 'Cash',            'Paid',      1360.00, 6, 4,    'Direct store purchase (Dishwasher + Purifier + Microwave)'),
-- Real-world pending / returned / cancelled orders (excluded from Revenue by inv.status = 'Paid')
(19, 'INV-0119', '2026-10-30 17:00:00', 'Card / Transfer', 'Refunded',   510.00, 3, 5,    'Customer return processed - Full refund issued'),
(20, 'INV-0120', '2026-10-31 14:20:00', 'Cash',            'Cancelled',  510.00, 7, 4,    'Customer cancelled counter reservation before pickup'),
(21, 'INV-0121', '2026-10-31 16:00:00', 'Card / Transfer', 'Pending',   1099.00, 2, NULL, 'Online pre-order - Payment processing with payment gateway'),
(22, 'INV-0122', '2026-10-31 18:30:00', 'Cash',            'Pending',    620.00, 6, NULL, 'COD delivery scheduled - Pending payment upon receipt');

-- Sale Items linking to Invoices
INSERT INTO tblSaleItem1 (id, invoiceId, itemId, quantity, price, discount, amount) VALUES
-- INV-0101: 2x Sony TV ($590) = $1,180
(1, 1, 1, 2, 590.00, 0.0, 1180.00),

-- INV-0102: 1x LG Washer ($360) + 1x Panasonic Microwave ($220) = $580
(2, 2, 2, 1, 360.00, 0.0, 360.00),
(3, 2, 7, 1, 220.00, 0.0, 220.00),

-- INV-0103: 1x MacBook Air ($1,099) = $1,099
(4, 3, 10, 1, 1099.00, 0.0, 1099.00),

-- INV-0104: 1x Sony TV ($590) + 1x Dyson Vacuum ($620) = $1,210
(5, 4, 1, 1, 590.00, 0.0, 590.00),
(6, 4, 8, 1, 620.00, 0.0, 620.00),

-- INV-0105: 1x Panasonic AC ($480) + 1x Daikin AC ($420) = $900
(7, 5, 3, 1, 480.00, 0.0, 480.00),
(8, 5, 4, 1, 420.00, 0.0, 420.00),

-- INV-0106: 1x Samsung Fridge ($450) = $450
(9, 6, 5, 1, 450.00, 0.0, 450.00),

-- INV-0107: 1x Bosch Dishwasher ($850) + 1x Philips Purifier ($290) = $1,140
(10, 7, 6, 1, 850.00, 0.0, 850.00),
(11, 7, 9, 1, 290.00, 0.0, 290.00),

-- INV-0108: 2x Sony TV ($590) = $1,180
(12, 8, 1, 2, 590.00, 0.0, 1180.00),

-- INV-0109: 1x LG Washer ($360) + 1x Samsung Fridge ($450) = $810
(13, 9, 2, 1, 360.00, 0.0, 360.00),
(14, 9, 5, 1, 450.00, 0.0, 450.00),

-- INV-0110: 2x Dyson Vacuum ($620) = $1,240
(15, 10, 8, 2, 620.00, 0.0, 1240.00),

-- INV-0111: 1x Sony TV ($590) + 1x Panasonic AC ($480) = $1,070
(16, 11, 1, 1, 590.00, 0.0, 590.00),
(17, 11, 3, 1, 480.00, 0.0, 480.00),

-- INV-0112: 1x MacBook Air ($1,099) = $1,099
(18, 12, 10, 1, 1099.00, 0.0, 1099.00),

-- INV-0113: 1x Bosch Dishwasher ($850) + 1x Panasonic Microwave ($220) = $1,070
(19, 13, 6, 1, 850.00, 0.0, 850.00),
(20, 13, 7, 1, 220.00, 0.0, 220.00),

-- INV-0114: 1x Daikin AC ($420) + 1x Philips Purifier ($290) = $710
(21, 14, 4, 1, 420.00, 0.0, 420.00),
(22, 14, 9, 1, 290.00, 0.0, 290.00),

-- INV-0115: 1x MacBook Air ($1,099) + 1x Dyson Vacuum ($620) = $1,719 (Paid)
(23, 15, 10, 1, 1099.00, 0.0, 1099.00),
(24, 15, 8, 1, 620.00, 0.0, 620.00),

-- INV-0116: 1x Panasonic AC ($480) + 1x Daikin AC ($420) = $900
(25, 16, 3, 1, 480.00, 0.0, 480.00),
(26, 16, 4, 1, 420.00, 0.0, 420.00),

-- INV-0117: 1x LG Washer ($360) + 1x Samsung Fridge ($450) = $810
(27, 17, 2, 1, 360.00, 0.0, 360.00),
(28, 17, 5, 1, 450.00, 0.0, 450.00),

-- INV-0118: 1x Bosch Dishwasher ($850) + 1x Philips Purifier ($290) + 1x Microwave ($220) = $1,360 (Paid)
(29, 18, 6, 1, 850.00, 0.0, 850.00),
(30, 18, 9, 1, 290.00, 0.0, 290.00),
(31, 18, 7, 1, 220.00, 0.0, 220.00),

-- INV-0119: 1x Philips Purifier ($290) + 1x Panasonic Microwave ($220) = $510 (Refunded order)
(32, 19, 9, 1, 290.00, 0.0, 290.00),
(33, 19, 7, 1, 220.00, 0.0, 220.00),

-- INV-0120: 1x Panasonic Microwave ($220) + 1x Philips Purifier ($290) = $510 (Cancelled order)
(34, 20, 7, 1, 220.00, 0.0, 220.00),
(35, 20, 9, 1, 290.00, 0.0, 290.00),

-- INV-0121: 1x MacBook Air ($1,099) = $1,099 (Pending gateway payment)
(36, 21, 10, 1, 1099.00, 0.0, 1099.00),

-- INV-0122: 1x Dyson Vacuum ($620) = $620 (Pending COD delivery)
(37, 22, 8, 1, 620.00, 0.0, 620.00);
