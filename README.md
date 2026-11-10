# Quản Lý Siêu Thị Điện Máy (SMS) - PTIT PTTKHTTT

Dự án bài tập lớn môn **Phân tích và Thiết kế Hệ thống Thông tin (PTTKHTTT)** - Học viện Công nghệ Bưu chính Viễn thông (PTIT).

## 1. Giới thiệu chức năng chính
* **Thống kê Doanh thu theo Mặt hàng (Item Revenue Statistics)**:
  * Cho phép người quản lý (Manager) tra cứu doanh thu và số lượng bán của các mặt hàng điện máy theo khoảng thời gian tùy chọn.
  * Xem danh sách chi tiết các hóa đơn giao dịch tạo nên doanh thu của từng mặt hàng (`Item Transactions Detail`).
  * Xem chi tiết từng hóa đơn bán lẻ (`Invoice Detail`), nổi bật mặt hàng đang kiểm tra (`[Inspected Item]`) cùng toàn bộ các sản phẩm khác trong giỏ hàng.
  * Chỉ tính doanh thu trên các hóa đơn đã thanh toán thành công (`status = 'Paid'`).
* **Đăng ký Khách hàng Thành viên (Customer Registration)**:
  * Đăng ký tài khoản thành viên mới với giao dịch cơ sở dữ liệu (Transaction) lưu đồng thời bảng Địa chỉ (`tblAddress1`), Thành viên (`tblMember1`), và Khách hàng (`tblCustomer1`).
  * Kiểm tra tính duy nhất của `username`.

---

## 2. Kiến trúc & Công nghệ sử dụng
* **Mô hình**: Kiến trúc 3 lớp (3-Tier) chuẩn theo quy ước giảng dạy PTIT (Model, DAO, View JSP).
* **Ngôn ngữ & Nền tảng**:
  * Java 21 / 25
  * Jakarta EE 10 / Servlet 4.0 & JSP 2.3
  * Web Server: Apache Tomcat 10.1 (Embedded via Maven Cargo)
  * CSDL: MySQL Server 8.0 (MySQL Connector/J 8.3.0)
  * Giao diện: HTML5, Tailwind CSS, FontAwesome 6
  * Kiểm thử đơn vị: JUnit 5 & JUnit 4 (14/14 Test Cases PASS 100%)

---

## 3. Cấu trúc thư mục mã nguồn
```
qlst-project/
├── pom.xml                     # Cấu hình Maven build & Cargo Tomcat plugin
├── seed_rich_data.sql          # Script tạo CSDL qlst_de10 và dữ liệu mẫu phong phú
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   ├── dao/            # Các lớp DAO (DAO1, ItemStatDAO1, InvoiceDAO1, CustomerDAO1, MemberDAO1)
│   │   │   └── model/          # Các lớp thực thể (Item1, ItemStat1, Invoice1, Customer1, Member1, Address1...)
│   │   ├── resources/
│   │   │   └── db.properties   # Cấu hình kết nối MySQL
│   │   └── webapp/             # Các trang giao diện JSP
│   │       ├── WEB-INF/web.xml # Cấu hình ứng dụng web
│   │       ├── ManagerHome1.jsp
│   │       ├── SelectReport1.jsp
│   │       ├── ItemRevenueStat1.jsp
│   │       ├── ItemTransactionDetail1.jsp
│   │       ├── InvoiceDetail1.jsp
│   │       ├── CustomerHome1.jsp
│   │       ├── Register1.jsp
│   │       └── Login1.jsp
│   └── test/
│       └── java/dao/           # Các test case JUnit kiểm thử DAO
```

---

## 4. Hướng dẫn cài đặt & Khởi chạy

### Bước 1: Khởi tạo Cơ sở dữ liệu MySQL
Mở MySQL Command Line hoặc MySQL Workbench và chạy file `seed_rich_data.sql`:
```bash
mysql -u root -p < seed_rich_data.sql
```
*(Mặc định kết nối: `localhost:3306`, user: `root`, pass: `123456`, db: `qlst_de10`)*

### Bước 2: Chạy kiểm thử đơn vị (Unit Tests)
```bash
mvn test
```

### Bước 3: Khởi chạy máy chủ Web (Tomcat)
```bash
mvn cargo:run
```
Sau khi server khởi động thành công, truy cập hệ thống tại:
👉 **http://localhost:8080/qlst**
