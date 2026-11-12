<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer1, model.Address1, dao.MemberDAO1, dao.CustomerDAO1, java.text.SimpleDateFormat, java.util.Date" %>
<%-- 
    ============================================================================================
    BỘ ĐIỀU PHỐI XỬ LÝ: doRegister1.jsp - Xử Lý Nghiệp Vụ Đăng Ký Tài Khoản Khách Hàng
    PHÂN HỆ: Module 1 - Đăng ký tài khoản thành viên khách hàng
    TÁC NHÂN: Khách hàng (Customer)
    MÔ TẢ: 
      - Đóng vai trò Controller trung gian tiếp nhận dữ liệu POST gửi lên từ RegisterUI1.jsp.
      - Thực hiện xác thực hợp lệ dữ liệu (validation).
      - Đóng gói dữ liệu thành các thực thể Address1 và Customer1.
      - Gọi MemberDAO1.checkUsername(username) để kiểm tra tính duy nhất của tên tài khoản.
      - Nếu hợp lệ, gọi CustomerDAO1.saveCustomer(cust) để lưu khách hàng mới vào CSDL.
      - Chuyển hướng sang LoginUI1.jsp?registered=success nếu đăng ký thành công, hoặc quay lại
        RegisterUI1.jsp kèm thông báo lỗi cụ thể nếu thất bại.
    ============================================================================================
--%>
<%
    // Thiết lập bảng mã UTF-8 để nhận đúng ký tự tiếng Việt có dấu
    request.setCharacterEncoding("UTF-8");

    // =========================================================================================
    // BƯỚC 1: TIẾP NHẬN TOÀN BỘ THÔNG TIN TỪ BIỂU MẪU ĐĂNG KÝ
    // =========================================================================================
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String name = request.getParameter("name");
    String dobStr = request.getParameter("dob");
    String tel = request.getParameter("tel");
    String email = request.getParameter("email");
    String houseNumber = request.getParameter("houseNumber");
    String street = request.getParameter("street");
    String ward = request.getParameter("ward");
    String city = request.getParameter("city");

    // Lưu lại các giá trị vào Request Scope để chuyển tiếp lại Form nếu có lỗi
    request.setAttribute("username", username);
    request.setAttribute("name", name);
    request.setAttribute("dob", dobStr);
    request.setAttribute("tel", tel);
    request.setAttribute("email", email);
    request.setAttribute("houseNumber", houseNumber);
    request.setAttribute("street", street);
    request.setAttribute("ward", ward);
    request.setAttribute("city", city);

    // =========================================================================================
    // BƯỚC 2: KIỂM TRA HỢP LỆ DỮ LIỆU ĐẦU VÀO (VALIDATION)
    // =========================================================================================
    // 1. Kiểm tra các trường bắt buộc (*) không được để trống:
    if (username == null || username.trim().isEmpty() ||
        password == null || password.trim().isEmpty() ||
        name == null || name.trim().isEmpty() ||
        street == null || street.trim().isEmpty() ||
        ward == null || ward.trim().isEmpty() ||
        city == null || city.trim().isEmpty()) {
        
        request.setAttribute("errorMessage", "Validation Error: Please fill in all required fields (*).");
        request.getRequestDispatcher("RegisterUI1.jsp").forward(request, response);
        return;
    }

    // 2. Kiểm tra mật khẩu xác nhận có khớp với mật khẩu đã nhập hay không:
    if (!password.equals(confirmPassword)) {
        request.setAttribute("errorMessage", "Validation Error: Password confirmation does not match the password entered.");
        request.getRequestDispatcher("RegisterUI1.jsp").forward(request, response);
        return;
    }

    // =========================================================================================
    // BƯỚC 3: ĐÓNG GÓI THỰC THỂ Address1 VÀ Customer1
    // =========================================================================================
    Date dob = new Date();
    try {
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
        }
    } catch (Exception ignored) {}

    // Khởi tạo đối tượng địa chỉ Address1
    Address1 address = new Address1(houseNumber, street, ward, city);
    // Khởi tạo đối tượng khách hàng Customer1 (kế thừa từ Member1)
    Customer1 cust = new Customer1(username, password, name, dob, tel, email, null, address);

    // =========================================================================================
    // BƯỚC 4: GỌI MemberDAO1 ĐỂ KIỂM TRA TRÙNG LẶP USERNAME (Khớp Biểu đồ tuần tự)
    // =========================================================================================
    MemberDAO1 memberDAO = new MemberDAO1();
    boolean isUsernameExist = memberDAO.checkUsername(username);

    // Nếu username đã tồn tại trong CSDL -> Báo lỗi và dừng xử lý
    if (isUsernameExist) {
        request.setAttribute("errorMessage", "Registration Error: The username '" + username + "' is already registered. Please choose another username.");
        request.getRequestDispatcher("RegisterUI1.jsp").forward(request, response);
        return;
    }

    // =========================================================================================
    // BƯỚC 5: GỌI CustomerDAO1 ĐỂ LƯU KHÁCH HÀNG VÀO CSDL (Khớp Biểu đồ tuần tự)
    // - Sử dụng Database Transaction (Tự động lưu tblAddress -> tblMember -> tblCustomer)
    // =========================================================================================
    CustomerDAO1 customerDAO = new CustomerDAO1();
    boolean isSaved = customerDAO.saveCustomer(cust);

    if (isSaved) {
        // Đăng ký thành công: Lưu tạm username vào session và chuyển hướng sang màn hình Đăng nhập
        session.setAttribute("registeredUser", username);
        response.sendRedirect("LoginUI1.jsp?registered=success");
    } else {
        // Lỗi lưu CSDL
        request.setAttribute("errorMessage", "System Error: Registration failed. Please try again later.");
        request.getRequestDispatcher("RegisterUI1.jsp").forward(request, response);
    }
%>
