<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Date, java.text.SimpleDateFormat, model.Invoice1, model.Item1, model.SaleItem1, dao.InvoiceDAO1" %>
<%-- 
    ============================================================================================
    GIAO DIỆN: ItemTransactionDetailUI1.jsp - Xem Chi Tiết Các Lần Giao Dịch Của Mặt Hàng
    PHÂN HỆ: Module 2 - Quản lý xem thống kê mặt hàng theo doanh thu
    TÁC NHÂN: Quản lý siêu thị (Manager)
    MÔ TẢ: 
      - Màn hình hiển thị danh sách tất cả các hóa đơn (lần giao dịch) có chứa mặt hàng được chọn
        trong khoảng thời gian (startDate -> endDate) đã lọc ở màn hình trước.
      - Tiếp nhận thông tin mặt hàng từ ItemRevenueStatUI1.jsp truyền sang (không gọi truy vấn Item thừa).
      - Gọi InvoiceDAO1.getTransactionByItem(itemId, start, end) để lấy danh sách Invoice1.
      - Cho phép Quản lý click vào một hóa đơn bất kỳ để xem chi tiết toàn bộ hóa đơn đó (InvoiceDetailUI1.jsp).
    ============================================================================================
--%>
<%
    // =========================================================================================
    // BƯỚC 1: TIẾP NHẬN CÁC THAM SỐ TỪ REQUEST (Truyền từ ItemRevenueStatUI1.jsp)
    // =========================================================================================
    // 1. Mã ID của mặt hàng được chọn và khoảng thời gian:
    String itemIdStr = request.getParameter("itemId");
    String itemCode = request.getParameter("itemCode");
    String itemName = request.getParameter("name");
    String itemBrand = request.getParameter("brand");
    String itemModel = request.getParameter("model");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");

    // Ép kiểu ID an toàn
    int itemId = 1;
    try {
        if (itemIdStr != null && !itemIdStr.trim().isEmpty()) {
            itemId = Integer.parseInt(itemIdStr);
        }
    } catch (Exception ignored) {}

    // Thiết lập giá trị mặc định cho khoảng ngày nếu trống
    if (startDateStr == null || startDateStr.trim().isEmpty()) startDateStr = "2026-10-01";
    if (endDateStr == null || endDateStr.trim().isEmpty()) endDateStr = "2026-10-31";

    if (itemCode == null || itemCode.trim().isEmpty()) itemCode = "ITM-01";
    if (itemName == null || itemName.trim().isEmpty()) itemName = "Electronic Item";
    if (itemBrand == null) itemBrand = "N/A";
    if (itemModel == null) itemModel = "N/A";

    // =========================================================================================
    // BƯỚC 2: KHỞI TẠO ĐỐI TƯỢNG Item1 CHỨA THÔNG TIN MẶT HÀNG ĐANG XEM
    // Lưu ý: Thông tin mặt hàng đã được truyền đầy đủ qua URL param từ màn hình thống kê trước,
    // tuân thủ chặt chẽ biểu đồ thiết kế (không gọi DAO truy vấn lại Item thừa thãi).
    // =========================================================================================
    Item1 selectedItem = new Item1();
    selectedItem.setId(itemId);
    selectedItem.setItemCode(itemCode);
    selectedItem.setName(itemName);
    selectedItem.setBrand(itemBrand);
    selectedItem.setModel(itemModel);

    SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    SimpleDateFormat sdfDisplay = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    // =========================================================================================
    // BƯỚC 3: GỌI TẦNG DAO TRUY VẤN CƠ SỞ DỮ LIỆU (Khớp chuẩn 100% với Biểu đồ tuần tự)
    // - Khởi tạo InvoiceDAO1
    // - Gọi phương thức: getTransactionByItem(itemId, startDate, endDate)
    // - Trả về: Danh sách List<Invoice1> các hóa đơn xuất bán có chứa mặt hàng này
    // =========================================================================================
    List<Invoice1> listInvoice = null;
    double totalItemRevenue = 0.0;
    int totalItemQuantity = 0;
    double grandInvoiceTotal = 0.0;

    try {
        Date start = sdfDateTime.parse(startDateStr + " 00:00:00");
        Date end = sdfDateTime.parse(endDateStr + " 23:59:59");
        InvoiceDAO1 invoiceDAO = new InvoiceDAO1();
        listInvoice = invoiceDAO.getTransactionByItem(itemId, start, end);
        if (listInvoice != null) {
            for (Invoice1 inv : listInvoice) {
                grandInvoiceTotal += inv.getTotalAmount();
                if (inv.getSaleItems() != null && !inv.getSaleItems().isEmpty()) {
                    SaleItem1 si = inv.getSaleItems().get(0);
                    totalItemRevenue += si.getAmount();
                    totalItemQuantity += si.getQuantity();
                }
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Item Transactions Detail - Supermarket Management System</title>
    <!-- Thư viện CSS Tailwind và FontAwesome Icons -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .font-mono-code {
            font-family: 'Consolas', 'Courier New', monospace;
        }
    </style>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen py-8">
    <div class="max-w-6xl mx-auto bg-white p-6 md:p-8 rounded-2xl border border-slate-200 shadow-sm space-y-4">
        
        <!-- ================================================================================= -->
        <!-- PHẦN 1: HEADER THÔNG TIN MẶT HÀNG ĐANG XEM GIAO DỊCH -->
        <!-- ================================================================================= -->
        <div class="flex flex-wrap justify-between items-start gap-4 border-b border-slate-200 pb-4">
            <div>
                <h3 class="font-extrabold text-slate-900 text-lg">Item Transactions Detail</h3>
                
                <!-- Thông tin chi tiết của mặt hàng được mang từ màn hình trước sang -->
                <div class="mt-1 text-xs text-slate-700 space-y-0.5">
                    <p>Selected item: <span class="font-bold text-indigo-900 text-sm"><%= selectedItem.getName() %></span> (Code: <span class="font-mono-code font-bold"><%= selectedItem.getItemCode() %></span>)</p>
                    <p class="text-slate-500">Brand: <span class="font-semibold text-slate-700"><%= selectedItem.getBrand() %></span> | Model: <span class="font-mono-code text-slate-700"><%= selectedItem.getModel() %></span></p>
                </div>
            </div>
            
            <div class="text-right text-xs text-slate-400">
                <span>Period: <strong class="text-slate-700"><%= startDateStr %></strong> to <strong class="text-slate-700"><%= endDateStr %></strong></span>
            </div>
        </div>

        <!-- ================================================================================= -->
        <!-- PHẦN 2: BẢNG DANH SÁCH CÁC LẦN GIAO DỊCH (tblTransaction) -->
        <!-- ================================================================================= -->
        <div class="overflow-x-auto border border-slate-200 rounded-xl">
            <table class="w-full text-xs text-left" id="tblTransaction">
                <thead class="bg-slate-50 text-slate-700 font-bold border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-3 text-center w-10">No.</th>
                        <th class="py-3 px-3">Invoice Code</th>
                        <th class="py-3 px-3">Date</th>
                        <th class="py-3 px-3">Payment Type</th>
                        <th class="py-3 px-3 text-center">Status</th>
                        <th class="py-3 px-3 text-center">Item Qty</th>
                        <th class="py-3 px-3 text-right font-bold text-indigo-900">Item Amount ($)</th>
                        <th class="py-3 px-3 text-right text-slate-600">Invoice Total ($)</th>
                        <th class="py-3 px-3 text-center">Action</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <%
                        // Lặp qua từng hóa đơn trong danh sách trả về từ DAO
                        if (listInvoice != null && !listInvoice.isEmpty()) {
                            int idx = 1;
                            for (Invoice1 inv : listInvoice) {
                                int iQty = (inv.getSaleItems() != null && !inv.getSaleItems().isEmpty()) ? inv.getSaleItems().get(0).getQuantity() : 0;
                                double iAmt = (inv.getSaleItems() != null && !inv.getSaleItems().isEmpty()) ? inv.getSaleItems().get(0).getAmount() : 0.0;
                    %>
                    <tr class="hover:bg-indigo-50/70 transition">
                        <td class="py-3.5 px-3 text-center font-medium"><%= idx++ %></td>
                        <td class="py-3.5 px-3 font-mono-code font-bold text-indigo-600"><%= inv.getInvoiceCode() %></td>
                        <td class="py-3.5 px-3"><%= (inv.getPaymentDate() != null) ? sdfDisplay.format(inv.getPaymentDate()) : "" %></td>
                        <td class="py-3.5 px-3"><%= inv.getPaymentType() %></td>
                        <td class="py-3.5 px-3 text-center">
                            <% 
                                String curStatus = inv.getStatus() != null ? inv.getStatus() : "Paid";
                                if ("Paid".equalsIgnoreCase(curStatus)) { 
                            %>
                                <span class="bg-emerald-100 text-emerald-800 border border-emerald-300 px-2 py-0.5 rounded text-[10px] font-bold inline-flex items-center gap-1">
                                    <i class="fa-solid fa-circle-check text-[9px]"></i> Paid
                                </span>
                            <% } else if ("Pending".equalsIgnoreCase(curStatus)) { %>
                                <span class="bg-amber-100 text-amber-800 border border-amber-300 px-2 py-0.5 rounded text-[10px] font-bold inline-flex items-center gap-1">
                                    <i class="fa-solid fa-clock text-[9px]"></i> Pending
                                </span>
                            <% } else if ("Refunded".equalsIgnoreCase(curStatus)) { %>
                                <span class="bg-purple-100 text-purple-800 border border-purple-300 px-2 py-0.5 rounded text-[10px] font-bold inline-flex items-center gap-1">
                                    <i class="fa-solid fa-rotate-left text-[9px]"></i> Refunded
                                </span>
                            <% } else if ("Cancelled".equalsIgnoreCase(curStatus)) { %>
                                <span class="bg-rose-100 text-rose-800 border border-rose-300 px-2 py-0.5 rounded text-[10px] font-bold inline-flex items-center gap-1">
                                    <i class="fa-solid fa-circle-xmark text-[9px]"></i> Cancelled
                                </span>
                            <% } else { %>
                                <span class="bg-slate-100 text-slate-800 border border-slate-300 px-2 py-0.5 rounded text-[10px] font-bold inline-flex items-center gap-1">
                                    <%= curStatus %>
                                </span>
                            <% } %>
                        </td>
                        <td class="py-3.5 px-3 text-center font-bold text-slate-800"><%= iQty %></td>
                        <td class="py-3.5 px-3 text-right font-black text-indigo-900"><%= String.format(java.util.Locale.US, "%,.2f", iAmt) %></td>
                        <td class="py-3.5 px-3 text-right font-medium text-slate-500"><%= String.format(java.util.Locale.US, "%,.2f", inv.getTotalAmount()) %></td>
                        <td class="py-3.5 px-3 text-center">
                            <!-- Nút chọn xem chi tiết hóa đơn (selectInvoice -> điều hướng sang InvoiceDetailUI1.jsp) -->
                            <a href="InvoiceDetailUI1.jsp?invoiceId=<%= inv.getId() %>&itemId=<%= itemId %>&itemCode=<%= java.net.URLEncoder.encode(selectedItem.getItemCode(), "UTF-8") %>&name=<%= java.net.URLEncoder.encode(selectedItem.getName(), "UTF-8") %>&brand=<%= java.net.URLEncoder.encode(selectedItem.getBrand(), "UTF-8") %>&model=<%= java.net.URLEncoder.encode(selectedItem.getModel(), "UTF-8") %>&startDate=<%= startDateStr %>&endDate=<%= endDateStr %>" class="text-indigo-600 font-semibold hover:underline inline-flex items-center">
                                View Invoice →
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="9" class="py-8 text-center text-slate-400 font-medium">No transaction records found for this item in this period.</td>
                    </tr>
                    <% } %>
                </tbody>
                <!-- Dòng Total tính tổng theo chuẩn kế toán ở chân bảng -->
                <tfoot class="bg-indigo-50/80 text-indigo-950 font-bold border-t-2 border-indigo-200">
                    <tr>
                        <td colspan="5" class="py-3.5 px-3 text-right uppercase tracking-wider text-xs">Total:</td>
                        <td class="py-3.5 px-3 text-center text-slate-900 font-black"><%= totalItemQuantity %></td>
                        <td class="py-3.5 px-3 text-right text-sm text-indigo-950 font-black">$<%= String.format(java.util.Locale.US, "%,.2f", totalItemRevenue) %></td>
                        <td class="py-3.5 px-3 text-right text-xs text-slate-600 font-bold">$<%= String.format(java.util.Locale.US, "%,.2f", grandInvoiceTotal) %></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <!-- ================================================================================= -->
        <!-- PHẦN 3: NÚT QUAY LẠI MÀN HÌNH THỐNG KÊ DOANH THU (btnBack) -->
        <!-- ================================================================================= -->
        <div class="flex justify-between items-center pt-2">
            <a href="ItemRevenueStatUI1.jsp?startDate=<%= startDateStr %>&endDate=<%= endDateStr %>" class="px-4 py-2 text-xs font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-lg border border-slate-300 inline-flex items-center">
                <i class="fa-solid fa-arrow-left mr-1.5"></i>Back
            </a>
        </div>
    </div>
</body>
</html>
