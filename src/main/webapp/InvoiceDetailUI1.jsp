<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat, model.Invoice1, model.SaleItem1, dao.InvoiceDAO1" %>
<%-- 
    ============================================================================================
    GIAO DIỆN: InvoiceDetailUI1.jsp - Xem Chi Tiết Hóa Đơn Bán Lẻ
    PHÂN HỆ: Module 2 - Quản lý xem thống kê mặt hàng theo doanh thu
    TÁC NHÂN: Quản lý siêu thị (Manager)
    MÔ TẢ: 
      - Màn hình hiển thị chi tiết đầy đủ của một hóa đơn cụ thể khi Quản lý click chọn 
        một mã hóa đơn từ danh sách các lần giao dịch (ItemTransactionDetailUI1.jsp).
      - Hiển thị: Mã hóa đơn, thời gian thanh toán, phương thức, trạng thái, khách hàng,
        thu ngân lập hóa đơn và bảng chi tiết danh sách các mặt hàng đã mua (SaleItem1).
      - Tự động làm nổi bật (highlight) mặt hàng đang được theo dõi thống kê từ các màn hình trước.
    ============================================================================================
--%>
<%
    // =========================================================================================
    // BƯỚC 1: TIẾP NHẬN CÁC THAM SỐ TỪ REQUEST (Truyền từ ItemTransactionDetailUI1.jsp)
    // =========================================================================================
    // 1. Mã định danh hóa đơn (ID) dùng để truy vấn CSDL:
    String invoiceIdStr = request.getParameter("invoiceId");

    // 2. Các tham số ngữ cảnh (Context parameters) của mặt hàng đang theo dõi:
    //    (Lưu giữ lại để khi bấm nút "Back to Transactions" sẽ quay lại đúng mặt hàng và khoảng thời gian đó)
    String itemIdStr = request.getParameter("itemId");
    String itemCode = request.getParameter("itemCode");
    String itemName = request.getParameter("name");
    String itemBrand = request.getParameter("brand");
    String itemModel = request.getParameter("model");
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");

    // =========================================================================================
    // BƯỚC 2: ÉP KIỂU VÀ XỬ LÝ DỮ LIỆU AN TOÀN
    // =========================================================================================
    int invoiceId = 1;
    int currentItemId = 1;
    try {
        if (invoiceIdStr != null) invoiceId = Integer.parseInt(invoiceIdStr);
        if (itemIdStr != null) currentItemId = Integer.parseInt(itemIdStr);
    } catch (Exception ignored) {}

    // =========================================================================================
    // BƯỚC 3: GỌI TẦNG DAO TRUY VẤN CƠ SỞ DỮ LIỆU (Khớp chuẩn 100% với Biểu đồ tuần tự)
    // - Khởi tạo đối tượng truy xuất dữ liệu: InvoiceDAO1
    // - Gọi phương thức: getInvoiceDetail(invoiceId)
    // - Nhận về đối tượng: Invoice1 (chứa thông tin hóa đơn, Customer, Staff và List<SaleItem1>)
    // =========================================================================================
    InvoiceDAO1 invoiceDAO = new InvoiceDAO1();
    Invoice1 inv = invoiceDAO.getInvoiceDetail(invoiceId);

    // Định dạng ngày giờ hiển thị giao dịch: yyyy-MM-dd HH:mm
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice Detail - Supermarket Management System</title>
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
    <div class="max-w-4xl mx-auto bg-white p-6 md:p-8 rounded-2xl border border-slate-200 shadow-sm space-y-6">
        
        <!-- ================================================================================= -->
        <!-- PHẦN 1: TIÊU ĐỀ MÀN HÌNH & MÃ HÓA ĐƠN -->
        <!-- ================================================================================= -->
        <div class="border-b border-slate-200 pb-4">
            <h3 class="font-extrabold text-slate-900 text-xl tracking-tight">Invoice Detail</h3>
            <p class="text-xs text-slate-500 mt-0.5">Invoice Code: <span class="font-mono-code font-bold text-indigo-900"><%= (inv != null) ? inv.getInvoiceCode() : "N/A" %></span></p>
        </div>

        <% if (inv != null) { %>
            <!-- ============================================================================= -->
            <!-- PHẦN 2: KHỐI THÔNG TIN CHUNG CỦA HÓA ĐƠN (Metadata: Ngày, KH, Thu ngân, Trạng thái) -->
            <!-- ============================================================================= -->
            <div class="bg-slate-50 p-4 rounded-xl border border-slate-200 text-xs grid grid-cols-1 md:grid-cols-2 gap-4">
                <!-- Cột trái: Thời gian, Hình thức thanh toán, Khách hàng -->
                <div class="space-y-2">
                    <div>
                        <span class="text-slate-500 block">Date:</span>
                        <span class="font-semibold text-slate-800"><%= (inv.getPaymentDate() != null) ? sdf.format(inv.getPaymentDate()) : "N/A" %></span>
                    </div>
                    <div>
                        <span class="text-slate-500 block">Payment Type:</span>
                        <span class="font-semibold text-slate-800"><%= inv.getPaymentType() %></span>
                    </div>
                    <div>
                        <span class="text-slate-500 block">Customer:</span>
                        <span class="font-semibold text-slate-800">
                            <%= (inv.getCustomer() != null && inv.getCustomer().getName() != null) 
                                ? (inv.getCustomer().getName() + " (" + (inv.getCustomer().getCustomerCode() != null ? inv.getCustomer().getCustomerCode() : "CUST") + ")") 
                                : "Walk-in Guest" %>
                        </span>
                    </div>
                </div>

                <!-- Cột phải: Trạng thái hóa đơn, Nhân viên lập hóa đơn, Ghi chú -->
                <div class="space-y-2">
                    <div>
                        <span class="text-slate-500 block">Status:</span>
                        <% 
                            String invStatus = (inv.getStatus() != null) ? inv.getStatus() : "Paid";
                            if ("Paid".equalsIgnoreCase(invStatus)) { 
                        %>
                            <span class="inline-flex items-center gap-1 bg-emerald-100 text-emerald-800 border border-emerald-300 font-bold px-2.5 py-0.5 rounded text-[11px]">
                                <i class="fa-solid fa-circle-check text-[10px]"></i> Paid
                            </span>
                        <% } else if ("Pending".equalsIgnoreCase(invStatus)) { %>
                            <span class="inline-flex items-center gap-1 bg-amber-100 text-amber-800 border border-amber-300 font-bold px-2.5 py-0.5 rounded text-[11px]">
                                <i class="fa-solid fa-clock text-[10px]"></i> Pending
                            </span>
                        <% } else if ("Refunded".equalsIgnoreCase(invStatus)) { %>
                            <span class="inline-flex items-center gap-1 bg-purple-100 text-purple-800 border border-purple-300 font-bold px-2.5 py-0.5 rounded text-[11px]">
                                <i class="fa-solid fa-rotate-left text-[10px]"></i> Refunded
                            </span>
                        <% } else if ("Cancelled".equalsIgnoreCase(invStatus)) { %>
                            <span class="inline-flex items-center gap-1 bg-rose-100 text-rose-800 border border-rose-300 font-bold px-2.5 py-0.5 rounded text-[11px]">
                                <i class="fa-solid fa-circle-xmark text-[10px]"></i> Cancelled
                            </span>
                        <% } else { %>
                            <span class="inline-flex items-center gap-1 bg-slate-100 text-slate-800 border border-slate-300 font-bold px-2.5 py-0.5 rounded text-[11px]">
                                <%= invStatus %>
                            </span>
                        <% } %>
                    </div>
                    <div>
                        <span class="text-slate-500 block">Cashier (Offline Counter Staff):</span>
                        <span class="font-semibold text-slate-800">
                            <%= (inv.getStaff() != null && inv.getStaff().getName() != null)
                                ? (inv.getStaff().getName() + " (EMP-0" + inv.getStaff().getId() + ")")
                                : "Online / Self-checkout System" %>
                        </span>
                    </div>
                    <div>
                        <span class="text-slate-500 block">Note:</span>
                        <span class="text-slate-600 italic"><%= (inv.getNote() != null) ? inv.getNote() : "Standard counter transaction" %></span>
                    </div>
                </div>
            </div>

            <!-- ============================================================================= -->
            <!-- PHẦN 3: BẢNG CHI TIẾT CÁC MẶT HÀNG TRONG HÓA ĐƠN (List<SaleItem1>) -->
            <!-- ============================================================================= -->
            <div class="space-y-2">
                <div class="flex justify-between items-center">
                    <h4 class="font-bold text-slate-800 text-xs tracking-wider uppercase">Purchased Sale Items:</h4>
                    <span class="text-[11px] text-slate-500 italic">* The inspected item from your previous report is highlighted below.</span>
                </div>
                <div class="overflow-x-auto border border-slate-200 rounded-xl">
                    <table class="w-full text-xs text-left" id="tblSaleItem">
                        <thead class="bg-slate-50 text-slate-700 font-bold border-b border-slate-200">
                            <tr>
                                <th class="py-3 px-3 text-center w-12">No.</th>
                                <th class="py-3 px-3">Item Code</th>
                                <th class="py-3 px-3">Item Name</th>
                                <th class="py-3 px-3 text-center">Quantity</th>
                                <th class="py-3 px-3 text-right">Price</th>
                                <th class="py-3 px-3 text-right font-bold">Amount</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <%
                                // Duyệt qua từng dòng hàng (SaleItem1) của hóa đơn
                                if (inv.getSaleItems() != null && !inv.getSaleItems().isEmpty()) {
                                    int sIdx = 1;
                                    for (SaleItem1 si : inv.getSaleItems()) {
                                        // Kiểm tra xem mặt hàng này có đúng là mặt hàng đang được Quản lý theo dõi từ màn hình trước không
                                        boolean isInspected = (si.getItem() != null && si.getItem().getId() == currentItemId);
                            %>
                            <tr class="<%= isInspected ? "bg-indigo-50/80 font-bold border-l-4 border-indigo-600" : "hover:bg-slate-50" %>">
                                <td class="py-3 px-3 text-center font-medium"><%= sIdx++ %></td>
                                <td class="py-3 px-3 font-mono-code font-bold text-indigo-600">
                                    <%= (si.getItem() != null) ? si.getItem().getItemCode() : "N/A" %>
                                </td>
                                <td class="py-3 px-3 font-semibold text-slate-900">
                                    <%= (si.getItem() != null) ? si.getItem().getName() : "Item" %>
                                    <% if (isInspected) { %>
                                        <span class="ml-2 bg-indigo-600 text-white text-[10px] px-2 py-0.5 rounded-full font-bold inline-flex items-center gap-1">
                                            <i class="fa-solid fa-magnifying-glass text-[9px]"></i> Inspected Item
                                        </span>
                                    <% } %>
                                </td>
                                <td class="py-3 px-3 text-center font-bold text-slate-800"><%= si.getQuantity() %></td>
                                <td class="py-3 px-3 text-right text-slate-700">$<%= String.format(java.util.Locale.US, "%,.2f", si.getPrice()) %></td>
                                <td class="py-3 px-3 text-right font-bold <%= isInspected ? "text-indigo-900 text-sm font-black" : "text-slate-900" %>">$<%= String.format(java.util.Locale.US, "%,.2f", si.getAmount()) %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="6" class="py-4 text-center text-slate-400">No items recorded in this invoice.</td>
                            </tr>
                            <% } %>
                        </tbody>
                        <!-- Tổng tiền toàn bộ hóa đơn -->
                        <tfoot class="bg-slate-50 border-t border-slate-200 font-bold">
                            <tr>
                                <td colspan="5" class="py-3 px-3 text-right">Total Invoice Amount:</td>
                                <td class="py-3 px-3 text-right text-sm text-indigo-900 font-black">$<%= String.format(java.util.Locale.US, "%,.2f", inv.getTotalAmount()) %></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        <% } else { %>
            <div class="py-8 text-center text-slate-400 font-medium">Invoice not found.</div>
        <% } %>

        <!-- ============================================================================= -->
        <!-- PHẦN 4: NÚT ĐIỀU HƯỚNG QUAY LẠI (Back button) -->
        <!-- Giữ nguyên đầy đủ itemId, khoảng thời gian startDate, endDate để quay lại đúng ngữ cảnh -->
        <!-- ============================================================================= -->
        <div class="pt-2 flex justify-between items-center">
            <a href="ItemTransactionDetailUI1.jsp?itemId=<%= currentItemId %>&itemCode=<%= (itemCode != null ? java.net.URLEncoder.encode(itemCode, "UTF-8") : "ITM-01") %>&name=<%= (itemName != null ? java.net.URLEncoder.encode(itemName, "UTF-8") : "Electronic+Item") %>&brand=<%= (itemBrand != null ? java.net.URLEncoder.encode(itemBrand, "UTF-8") : "") %>&model=<%= (itemModel != null ? java.net.URLEncoder.encode(itemModel, "UTF-8") : "") %>&startDate=<%= (startDateStr != null ? startDateStr : "2026-11-01") %>&endDate=<%= (endDateStr != null ? endDateStr : "2026-11-30") %>" class="px-5 py-2.5 text-xs font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-lg border border-slate-300 inline-flex items-center">
                <i class="fa-solid fa-arrow-left mr-1.5"></i>Back to Transactions
            </a>
        </div>
    </div>
</body>
</html>
