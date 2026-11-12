<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 
    ============================================================================================
    TRANG CHỦ MẶC ĐỊNH: index.jsp - Cổng Điều Hướng Hệ Thống Quản Lý Siêu Thị Điện Máy (QLST)
    BÀI TẬP LỚN: Phân tích và Thiết kế Hệ thống Thông tin (Đề số 10)
    GIẢNG VIÊN HƯỚNG DẪN: TS. Đỗ Thị Bích Ngọc - Học viện Công nghệ Bưu chính Viễn thông (PTIT)
    SINH VIÊN THỰC HIỆN: Đinh Văn Minh - Mã SV: B23DCCN541 - Lớp: D23CN09
    ============================================================================================
--%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>QLST – Hệ thống Quản lý Siêu thị Điện máy (Đề số 10)</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen flex items-center justify-center p-4">
    <div class="max-w-lg w-full bg-white rounded-2xl shadow-md border border-slate-200 p-8 text-center space-y-6">
        <div class="w-16 h-16 bg-indigo-50 text-indigo-600 rounded-2xl mx-auto flex items-center justify-center text-3xl shadow-inner">
            <i class="fa-solid fa-store"></i>
        </div>
        <div>
            <span class="bg-indigo-100 text-indigo-700 px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider">Học viện PTIT – Đề số 10</span>
            <h1 class="text-xl font-black text-slate-900 mt-3">Hệ thống Quản lý Siêu thị Điện máy</h1>
            <p class="text-xs text-slate-500 mt-1">Phân tích & Thiết kế Hệ thống Thông tin (PTTKHTTT)</p>
            <p class="text-xs text-indigo-900 font-semibold mt-0.5">Sinh viên: Đinh Văn Minh - B23DCCN541</p>
        </div>

        <div class="space-y-3 pt-2 text-xs">
            <a href="CustomerHomeUI1.jsp" class="w-full py-3 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl shadow transition flex items-center justify-center gap-2">
                <i class="fa-solid fa-user"></i>
                <span>Cổng Khách hàng (Đăng ký thành viên)</span>
            </a>
            <a href="ManagerHomeUI1.jsp" class="w-full py-3 bg-slate-800 hover:bg-slate-900 text-white font-bold rounded-xl shadow transition flex items-center justify-center gap-2">
                <i class="fa-solid fa-chart-line"></i>
                <span>Cổng Quản lý (Thống kê doanh thu mặt hàng)</span>
            </a>
            <a href="LoginUI1.jsp" class="w-full py-2.5 bg-slate-100 hover:bg-slate-200 text-slate-700 font-semibold rounded-xl border border-slate-300 transition flex items-center justify-center gap-2">
                <i class="fa-solid fa-right-to-bracket"></i>
                <span>Đăng nhập hệ thống</span>
            </a>
        </div>
    </div>
</body>
</html>
