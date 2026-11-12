<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    ============================================================================================
    GIAO DIỆN: CustomerHomeUI1.jsp - Trang Chủ Dành Cho Khách Hàng
    PHÂN HỆ: Module 1 - Đăng ký tài khoản thành viên khách hàng
    TÁC NHÂN: Khách hàng (Customer)
    MÔ TẢ: 
      - Màn hình chính khi khách hàng truy cập vào cổng dịch vụ trực tuyến của Siêu thị điện máy.
      - Chứa nút kích hoạt chức năng đăng ký thành viên: subRegister.
      - Khi khách hàng click nút "Register Member Account", hệ thống điều hướng sang RegisterUI1.jsp.
    ============================================================================================
--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Home - Supermarket Management System</title>
    <!-- Thư viện CSS Tailwind và FontAwesome Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">
    <!-- Header hệ thống -->
    <header class="bg-slate-900 text-white shadow-md sticky top-0 z-50 border-b border-slate-800">
        <div class="max-w-7xl mx-auto px-4 py-3 flex justify-between items-center">
            <div class="flex items-center space-x-3">
                <span class="bg-indigo-600 text-white px-2.5 py-1 rounded font-black text-xs tracking-wider uppercase">SMS Portal</span>
                <h1 class="text-base md:text-lg font-bold tracking-tight">Electronics Supermarket Enterprise System</h1>
            </div>
            <!-- Các nút điều hướng nhanh: Đăng nhập & Đăng ký -->
            <div class="space-x-2">
                <a href="LoginUI1.jsp" class="px-3.5 py-1.5 text-xs font-semibold bg-white text-indigo-700 rounded-lg shadow hover:bg-slate-100 transition">Login</a>
                <a href="RegisterUI1.jsp" class="px-3.5 py-1.5 text-xs font-semibold bg-indigo-600 text-white rounded-lg shadow hover:bg-indigo-700 transition">Register</a>
            </div>
        </div>
    </header>

    <main class="max-w-3xl mx-auto mt-12 p-6 md:p-8">
        <div class="bg-white p-8 rounded-2xl border border-slate-200 shadow-sm space-y-6 text-center">
            <div class="w-16 h-16 bg-indigo-50 text-indigo-600 rounded-2xl mx-auto flex items-center justify-center text-3xl shadow-inner">
                <i class="fa-solid fa-store"></i>
            </div>
            <div>
                <h2 class="text-2xl font-black text-slate-900 tracking-tight">Supermarket Customer Portal</h2>
                <p class="text-xs text-slate-500 mt-1">Welcome to Electronics Supermarket System</p>
            </div>

            <!-- Khối giới thiệu và nút kích hoạt đăng ký tài khoản (subRegister) -->
            <div class="bg-slate-50 p-6 rounded-xl border border-slate-200 max-w-md mx-auto space-y-4">
                <p class="text-xs text-slate-600 leading-relaxed">
                    New customer? Register an official membership account to receive promotional updates and track your purchases.
                </p>
                <div>
                    <!-- subRegister: Thuộc tính kích hoạt chức năng đăng ký thành viên trên Boundary CustomerHomeUI1 -->
                    <a href="RegisterUI1.jsp" class="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-xl shadow-md transition flex items-center justify-center gap-2">
                        <i class="fa-solid fa-user-plus"></i>
                        <span>Register Member Account</span>
                    </a>
                </div>
            </div>

            <div class="pt-4 border-t border-slate-100 flex justify-center items-center text-xs text-slate-500">
                <span>Already registered?</span>
                <a href="LoginUI1.jsp" class="ml-2 font-bold text-indigo-600 hover:underline">
                    Login here
                </a>
            </div>
        </div>
    </main>
</body>
</html>
