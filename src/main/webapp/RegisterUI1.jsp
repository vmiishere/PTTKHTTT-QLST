<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    ============================================================================================
    GIAO DIỆN: RegisterUI1.jsp - Biểu Mẫu Nhập Liệu Đăng Ký Tài Khoản Thành Viên Khách Hàng
    PHÂN HỆ: Module 1 - Đăng ký tài khoản thành viên khách hàng
    TÁC NHÂN: Khách hàng (Customer)
    MÔ TẢ: 
      - Màn hình chứa Form nhập liệu thông tin cá nhân và thông tin tài khoản của khách hàng mới.
      - Chứa đầy đủ các thuộc tính nhập liệu theo đúng lớp Boundary RegisterUI1 trong Biểu đồ lớp:
        + -inUsername, -inPassword, -inConfirmPassword (Thông tin xác thực tài khoản)
        + -inFullName, -inDob, -inTel, -inEmail (Thông tin hồ sơ cá nhân)
        + -inAddress (houseNumber, street, ward, city)
      - Thuộc tính kích hoạt:
        + -subSubmitRegister (Nút gửi form đăng ký: POST -> doRegister1.jsp)
        + -subBack (Nút quay lại: GET -> CustomerHomeUI1.jsp)
      - Giữ lại các giá trị đã nhập khi phát sinh lỗi để người dùng không phải điền lại từ đầu.
    ============================================================================================
--%>
<%
    // Tiếp nhận thông báo lỗi và các dữ liệu đã nhập trước đó (nếu xử lý đăng ký thất bại)
    String errorMessage = (String) request.getAttribute("errorMessage");
    String usernameVal = (request.getAttribute("username") != null) ? (String) request.getAttribute("username") : "";
    String nameVal = (request.getAttribute("name") != null) ? (String) request.getAttribute("name") : "";
    String dobVal = (request.getAttribute("dob") != null) ? (String) request.getAttribute("dob") : "1998-05-15";
    String telVal = (request.getAttribute("tel") != null) ? (String) request.getAttribute("tel") : "";
    String emailVal = (request.getAttribute("email") != null) ? (String) request.getAttribute("email") : "";
    String houseVal = (request.getAttribute("houseNumber") != null) ? (String) request.getAttribute("houseNumber") : "";
    String streetVal = (request.getAttribute("street") != null) ? (String) request.getAttribute("street") : "";
    String wardVal = (request.getAttribute("ward") != null) ? (String) request.getAttribute("ward") : "";
    String cityVal = (request.getAttribute("city") != null) ? (String) request.getAttribute("city") : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Member Registration - Supermarket Management System</title>
    <!-- Thư viện CSS Tailwind và FontAwesome Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen py-8">
    <div class="max-w-2xl mx-auto bg-white rounded-2xl shadow-sm border border-slate-200 p-6 md:p-8 space-y-6">
        
        <!-- Header tiêu đề Form đăng ký -->
        <div class="border-b border-slate-200 pb-4">
            <h3 class="text-xl font-extrabold text-slate-900 tracking-tight">Member Registration Form</h3>
            <p class="text-xs text-slate-500 mt-1">Fill in the required profile details to register a new customer account.</p>
        </div>

        <!-- Khối hiển thị thông báo lỗi (trùng lặp username, mật khẩu xác nhận không khớp,...) -->
        <% if (errorMessage != null) { %>
            <div class="p-3.5 rounded-xl text-xs font-medium border flex items-center space-x-2 bg-rose-50 text-rose-700 border-rose-200">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <span><%= errorMessage %></span>
            </div>
        <% } %>

        <!-- Form gửi dữ liệu sang doRegister1.jsp để xử lý nghiệp vụ xác thực và lưu CSDL -->
        <form action="doRegister1.jsp" method="POST" class="space-y-4">
            
            <!-- ============================================================================= -->
            <!-- KHỐI 1: THÔNG TIN TÀI KHOẢN (inUsername, inPassword, inConfirmPassword) -->
            <!-- ============================================================================= -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Username (*)</label>
                    <input type="text" name="username" value="<%= usernameVal %>" required placeholder="johnsmith99" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Password (*)</label>
                    <input type="password" name="password" required placeholder="••••••••" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Confirm Password (*)</label>
                    <input type="password" name="confirmPassword" required placeholder="••••••••" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
            </div>

            <!-- ============================================================================= -->
            <!-- KHỐI 2: THÔNG TIN CÁ NHÂN (inFullName, inDob, inTel, inEmail) -->
            <!-- ============================================================================= -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Full Name (*)</label>
                    <input type="text" name="name" value="<%= nameVal %>" required placeholder="John Robert Smith" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Date of Birth (*)</label>
                    <input type="date" name="dob" value="<%= dobVal %>" required class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Phone Number (*)</label>
                    <input type="text" name="tel" value="<%= telVal %>" required placeholder="0912345678" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1">Email (*)</label>
                    <input type="email" name="email" value="<%= emailVal %>" required placeholder="john.smith@example.com" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
            </div>

            <!-- ============================================================================= -->
            <!-- KHỐI 3: THÔNG TIN ĐỊA CHỈ NƠI CƯ TRÚ (inAddress) -->
            <!-- ============================================================================= -->
            <div class="border-t border-slate-200 pt-4">
                <h4 class="text-xs font-bold uppercase tracking-wider text-slate-500 mb-3">Residential Address:</h4>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">House Number</label>
                        <input type="text" name="houseNumber" value="<%= houseVal %>" placeholder="Apt 4B, No. 742" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Street (*)</label>
                        <input type="text" name="street" value="<%= streetVal %>" required placeholder="Broadway Avenue" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">Ward (*)</label>
                        <input type="text" name="ward" value="<%= wardVal %>" required placeholder="Midtown" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 mb-1">City (*)</label>
                        <input type="text" name="city" value="<%= cityVal %>" required placeholder="New York" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                    </div>
                </div>
            </div>

            <!-- ============================================================================= -->
            <!-- KHỐI 4: NÚT THAO TÁC (subBack, subSubmitRegister) -->
            <!-- ============================================================================= -->
            <div class="pt-4 border-t border-slate-200 flex items-center justify-between">
                <!-- subBack: Quay lại màn hình CustomerHomeUI1 -->
                <a href="CustomerHomeUI1.jsp" class="px-5 py-2.5 border border-slate-300 hover:bg-slate-100 text-slate-700 text-xs font-semibold rounded-lg flex items-center transition">
                    <i class="fa-solid fa-arrow-left mr-2"></i>
                    <span>Back</span>
                </a>
                <!-- subSubmitRegister: Xác nhận gửi thông tin đăng ký -->
                <button type="submit" class="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold rounded-lg shadow-md transition flex items-center">
                    <i class="fa-solid fa-check mr-2"></i>
                    <span>Register</span>
                </button>
            </div>
        </form>
    </div>
</body>
</html>
