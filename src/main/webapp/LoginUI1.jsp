<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member1, dao.MemberDAO1" %>
<%-- 
    ============================================================================================
    GIAO DIỆN: LoginUI1.jsp - Màn Hình Đăng Nhập Hệ Thống & Hiển Thị Kết Quả Đăng Ký
    PHÂN HỆ: Dùng chung (Đặc biệt kết nối với Module 1: Đăng ký thành viên)
    TÁC NHÂN: Thành viên (Member - bao gồm Customer và Manager)
    MÔ TẢ: 
      - Màn hình tiếp nhận chuyển hướng sau khi khách hàng đăng ký tài khoản thành công từ doRegister1.jsp.
      - Chứa thuộc tính hiển thị -outMessage trên lớp Boundary LoginUI1:
        + Hiển thị hộp thông báo màu xanh chúc mừng khách hàng đã đăng ký thành công vào CSDL.
      - Cho phép đăng nhập hệ thống:
        + Gọi MemberDAO1.checkLogin(m) để xác thực thông tin tài khoản.
        + Phân quyền điều hướng: Nếu vai trò là MANAGER -> chuyển sang ManagerHomeUI1.jsp;
          nếu là CUSTOMER -> chuyển sang CustomerHomeUI1.jsp.
    ============================================================================================
--%>
<%
    // Kiểm tra tham số đăng ký thành công từ URL (registered=success)
    String registered = request.getParameter("registered");
    String error = null;

    // Xử lý khi người dùng submit form đăng nhập (POST)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Đóng gói thông tin đăng nhập vào đối tượng Member1
        Member1 m = new Member1();
        m.setUsername(username);
        m.setPassword(password);

        // Gọi MemberDAO1 để xác thực tài khoản và mật khẩu
        MemberDAO1 memberDAO = new MemberDAO1();
        boolean ok = memberDAO.checkLogin(m);
        if (ok) {
            // Lưu thông tin người dùng vào Session
            session.setAttribute("user", m);
            // Phân quyền điều hướng dựa trên Role
            if ("MANAGER".equalsIgnoreCase(m.getRole())) {
                response.sendRedirect("ManagerHomeUI1.jsp");
            } else {
                response.sendRedirect("CustomerHomeUI1.jsp");
            }
            return;
        } else {
            error = "Authentication Failed: Invalid username or password.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Supermarket Management System</title>
    <!-- Thư viện CSS Tailwind và FontAwesome Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen flex items-center justify-center p-4">
    <div class="max-w-md w-full bg-white rounded-2xl shadow-md border border-slate-200 p-6 md:p-8 space-y-6">
        
        <!-- ============================================================================= -->
        <!-- THUỘC TÍNH HIỂN THỊ: -outMessage (Thông báo đăng ký thành công vào CSDL) -->
        <!-- Khớp chuẩn 100% với thuộc tính lớp Boundary LoginUI1 trong Biểu đồ lớp phân tích -->
        <!-- ============================================================================= -->
        <% if ("success".equals(registered)) { %>
            <div class="bg-emerald-50 border-l-4 border-emerald-500 p-4 rounded-r-xl flex items-start space-x-3">
                <i class="fa-solid fa-circle-check text-emerald-600 text-lg mt-0.5 shrink-0"></i>
                <div>
                    <h4 class="text-xs font-bold text-emerald-900">Registration Successful!</h4>
                    <p class="text-xs text-emerald-700 mt-0.5 leading-relaxed" id="outMessage">Your customer account has been registered and saved to the database. Please sign in.</p>
                </div>
            </div>
        <% } %>

        <div class="text-center">
            <h3 class="text-lg font-bold text-slate-900 tracking-tight">Login</h3>
            <p class="text-xs text-slate-500 mt-1">Please enter your credentials</p>
        </div>

        <!-- Thông báo lỗi khi nhập sai tên đăng nhập hoặc mật khẩu -->
        <% if (error != null) { %>
            <div class="p-3 mb-4 rounded-xl text-xs font-semibold bg-rose-50 text-rose-800 border border-rose-200 flex items-center space-x-2">
                <i class="fa-solid fa-circle-exclamation text-rose-600"></i>
                <span><%= error %></span>
            </div>
        <% } %>

        <!-- Form Đăng nhập -->
        <form action="LoginUI1.jsp" method="POST" class="space-y-4">
            <div>
                <label class="block text-xs font-semibold text-slate-700 mb-1">Username</label>
                <input type="text" name="username" required placeholder="johnsmith99" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
            </div>
            <div>
                <label class="block text-xs font-semibold text-slate-700 mb-1">Password</label>
                <input type="password" name="password" required placeholder="••••••••" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
            </div>
            <button type="submit" class="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow transition">
                Login
            </button>
        </form>

        <!-- Chuyển hướng sang form Đăng ký nếu chưa có tài khoản -->
        <div class="pt-4 border-t border-slate-200 text-center text-xs text-slate-500">
            <span>Don't have an account?</span>
            <a href="RegisterUI1.jsp" class="ml-1 text-indigo-600 font-bold hover:underline">Register</a>
        </div>
    </div>
</body>
</html>
