<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 
    ============================================================================================
    GIAO DIỆN: SelectReportUI1.jsp - Chọn Tiêu Chí Báo Cáo & Khoảng Thời Gian Thống Kê
    PHÂN HỆ: Module 2 - Quản lý xem thống kê mặt hàng theo doanh thu
    TÁC NHÂN: Quản lý siêu thị (Manager)
    MÔ TẢ: 
      - Màn hình cho phép Quản lý lựa chọn loại báo cáo cần xem (Thống kê doanh thu mặt hàng)
        và thiết lập khoảng thời gian (Từ ngày - Đến ngày).
      - Có cơ chế kiểm tra tính hợp lệ bằng JavaScript phía Client (validateDateCriteria)
        đảm bảo Ngày kết thúc không được nhỏ hơn Ngày bắt đầu.
      - Sau khi bấm "View Statistics", gửi request GET sang ItemRevenueStatUI1.jsp để tính toán.
    ============================================================================================
--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Report Criteria - Supermarket Management System</title>
    <!-- Thư viện CSS Tailwind và FontAwesome Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Script kiểm tra tính hợp lệ của khoảng ngày nhập vào -->
    <script>
        function validateDateCriteria() {
            var startInput = document.getElementById("startDate");
            var endInput = document.getElementById("endDate");
            var banner = document.getElementById("errorBanner");
            var errorMsg = document.getElementById("errorMessage");

            // Kiểm tra: Nếu ngày kết thúc nhỏ hơn ngày bắt đầu -> hiển thị thông báo lỗi và chặn submit
            if (startInput.value && endInput.value && endInput.value < startInput.value) {
                banner.classList.remove("hidden");
                errorMsg.textContent = "End Date (" + endInput.value + ") cannot be earlier than Start Date (" + startInput.value + "). Please select a valid date range.";
                endInput.focus();
                return false;
            }
            banner.classList.add("hidden");
            return true;
        }
    </script>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen py-8">
    <div class="max-w-xl mx-auto bg-white p-6 md:p-8 rounded-2xl shadow-sm border border-slate-200 space-y-6">
        
        <!-- Header tiêu đề -->
        <div class="border-b border-slate-200 pb-4">
            <h3 class="font-extrabold text-slate-900 text-lg">Select Report Criteria</h3>
            <p class="text-xs text-slate-500 mt-0.5">Specify report type and time interval</p>
        </div>

        <!-- Khối hiển thị thông báo lỗi khi nhập sai ngày (mặc định ẩn) -->
        <div id="errorBanner" class="hidden p-3.5 bg-rose-50 border border-rose-200 text-rose-700 text-xs rounded-xl flex items-center gap-2.5">
            <i class="fa-solid fa-circle-exclamation text-rose-500 text-base shrink-0"></i>
            <span id="errorMessage" class="font-medium">End Date cannot be earlier than Start Date. Please select a valid date range.</span>
        </div>

        <!-- Form nhập tiêu chí: Gửi GET sang ItemRevenueStatUI1.jsp -->
        <form id="reportForm" action="ItemRevenueStatUI1.jsp" method="GET" onsubmit="return validateDateCriteria()" class="space-y-4">
            
            <!-- Trường chọn loại báo cáo thống kê -->
            <div>
                <label class="block text-xs font-semibold text-slate-700 mb-1.5">
                    Report Type (*)
                </label>
                <select name="reportType" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none bg-white font-medium">
                    <option value="itemRevenue" selected>Item Revenue Statistics</option>
                </select>
            </div>

            <!-- Trường chọn khoảng ngày: Ngày bắt đầu (startDate) và Ngày kết thúc (endDate) -->
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1.5">
                        Start Date (*)
                    </label>
                    <input type="date" id="startDate" name="startDate" value="2026-10-01" required onchange="validateDateCriteria()" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none font-medium">
                </div>
                <div>
                    <label class="block text-xs font-semibold text-slate-700 mb-1.5">
                        End Date (*)
                    </label>
                    <input type="date" id="endDate" name="endDate" value="2026-10-31" required onchange="validateDateCriteria()" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none font-medium">
                </div>
            </div>

            <!-- Nút điều hướng: Quay lại trang chủ Quản lý và Nút Xem thống kê -->
            <div class="pt-4 border-t border-slate-200 flex justify-between items-center">
                <a href="ManagerHomeUI1.jsp" class="px-4 py-2.5 text-xs font-semibold text-slate-600 hover:bg-slate-100 rounded-lg border border-slate-300 inline-flex items-center">
                    <i class="fa-solid fa-arrow-left mr-2"></i>Back
                </a>
                <button type="submit" class="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white text-xs font-bold rounded-lg shadow transition inline-flex items-center">
                    <i class="fa-solid fa-chart-simple mr-2"></i>
                    <span>View Statistics</span>
                </button>
            </div>
        </form>
    </div>
</body>
</html>
