<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Date, java.text.SimpleDateFormat, model.ItemStat1, dao.ItemStatDAO1" %>
<%
    String startDateStr = request.getParameter("startDate");
    String endDateStr = request.getParameter("endDate");

    if (startDateStr == null || startDateStr.trim().isEmpty()) {
        startDateStr = "2026-10-01";
    }
    if (endDateStr == null || endDateStr.trim().isEmpty()) {
        endDateStr = "2026-10-31";
    }

    SimpleDateFormat sdfDateTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    List<ItemStat1> listItemStat = null;
    double grandTotalRevenue = 0.0;
    int grandTotalQuantity = 0;
    boolean isInvalidRange = false;
    String dateErrorMessage = null;

    try {
        Date start = sdfDateTime.parse(startDateStr + " 00:00:00");
        Date end = sdfDateTime.parse(endDateStr + " 23:59:59");

        if (end.before(start)) {
            isInvalidRange = true;
            dateErrorMessage = "End Date (" + endDateStr + ") cannot be earlier than Start Date (" + startDateStr + "). Please select a valid date range.";
        } else {
            ItemStatDAO1 dao = new ItemStatDAO1();
            listItemStat = dao.getItemRevenueStat(start, end);
            if (listItemStat != null) {
                for (ItemStat1 stat : listItemStat) {
                    grandTotalRevenue += stat.getRevenue();
                    grandTotalQuantity += stat.getTotalSoldQuantity();
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
    <title>Item Revenue Statistics - Supermarket Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .font-mono-code {
            font-family: 'Consolas', 'Courier New', monospace;
        }
    </style>
    <script>
        function validateInlineFilter() {
            var s = document.getElementById("filterStartDate").value;
            var e = document.getElementById("filterEndDate").value;
            if (s && e && e < s) {
                alert("Invalid Date Range:\nEnd Date (" + e + ") cannot be earlier than Start Date (" + s + ").\nPlease select a valid period.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen py-8">
    <div class="max-w-6xl mx-auto bg-white p-6 md:p-8 rounded-2xl border border-slate-200 shadow-sm space-y-4">
        <!-- Top Navigation & Filter Bar -->
        <div class="flex flex-wrap justify-between items-center pb-4 mb-2 border-b border-slate-200 gap-4">
            <div>
                <h3 class="font-extrabold text-slate-900 text-lg">Item Revenue Statistics</h3>
                <% if (isInvalidRange) { %>
                    <p class="text-xs text-rose-600 mt-0.5 font-semibold flex items-center gap-1.5">
                        <i class="fa-solid fa-circle-exclamation text-rose-500"></i>
                        Invalid Period: <span class="font-bold underline"><%= startDateStr %></span> to <span class="font-bold underline"><%= endDateStr %></span>
                    </p>
                <% } else { %>
                    <p class="text-xs text-slate-500 mt-0.5">
                        Period: <span class="font-semibold text-slate-800"><%= startDateStr %></span> to <span class="font-semibold text-slate-800"><%= endDateStr %></span>
                    </p>
                <% } %>
            </div>

            <!-- Inline Filter Controls -->
            <form action="ItemRevenueStat1.jsp" method="GET" onsubmit="return validateInlineFilter()" class="flex items-center gap-3">
                <div>
                    <label class="text-[11px] font-semibold text-slate-500 block">From</label>
                    <input type="date" id="filterStartDate" name="startDate" value="<%= startDateStr %>" required class="text-xs px-3 py-1.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <div>
                    <label class="text-[11px] font-semibold text-slate-500 block">To</label>
                    <input type="date" id="filterEndDate" name="endDate" value="<%= endDateStr %>" required class="text-xs px-3 py-1.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none">
                </div>
                <button type="submit" class="mt-4 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-lg shadow transition flex items-center gap-1.5">
                    <i class="fa-solid fa-filter text-[11px]"></i>
                    <span>Filter</span>
                </button>
            </form>
        </div>

        <% if (isInvalidRange) { %>
            <!-- Warning Alert Box -->
            <div class="p-4 bg-rose-50 border border-rose-200 rounded-xl flex items-start sm:items-center gap-3 text-rose-800 text-xs shadow-sm">
                <div class="w-8 h-8 rounded-lg bg-rose-100 flex items-center justify-center text-rose-600 shrink-0">
                    <i class="fa-solid fa-triangle-exclamation text-sm"></i>
                </div>
                <div class="flex-1">
                    <p class="font-bold text-rose-900 text-sm">Invalid Date Range Specified</p>
                    <p class="text-rose-700 mt-0.5"><%= dateErrorMessage %></p>
                </div>
                <a href="SelectReport1.jsp" class="px-3.5 py-1.5 bg-rose-600 hover:bg-rose-700 text-white text-xs font-bold rounded-lg transition shrink-0 inline-flex items-center">
                    <i class="fa-solid fa-rotate-left mr-1.5"></i>Re-select Dates
                </a>
            </div>
        <% } %>

        <!-- Table displaying List<ItemStat1> -->
        <div class="overflow-x-auto border border-slate-200 rounded-xl">
            <table class="w-full text-xs text-left" id="tblItemStat">
                <thead class="bg-slate-50 text-slate-700 font-bold border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-3 text-center w-12">No.</th>
                        <th class="py-3 px-3">Item Code</th>
                        <th class="py-3 px-3">Name</th>
                        <th class="py-3 px-3">Brand</th>
                        <th class="py-3 px-3">Model</th>
                        <th class="py-3 px-3 text-center">Total Sold Qty (Units)</th>
                        <th class="py-3 px-3 text-right font-extrabold text-slate-900">Revenue ($)</th>
                        <th class="py-3 px-3 text-center">Action</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-200">
                    <%
                        if (isInvalidRange) {
                    %>
                    <tr>
                        <td colspan="8" class="py-10 text-center text-rose-600 font-medium">
                            <div class="inline-flex flex-col items-center">
                                <i class="fa-solid fa-calendar-xmark text-3xl text-rose-400 mb-2"></i>
                                <span class="font-bold text-sm">Cannot generate statistics for an invalid time interval!</span>
                                <span class="text-xs text-slate-500 mt-1">Please ensure End Date is equal to or after Start Date using the filter above or click Back.</span>
                            </div>
                        </td>
                    </tr>
                    <%
                        } else if (listItemStat != null && !listItemStat.isEmpty()) {
                            int idx = 1;
                            for (ItemStat1 item : listItemStat) {
                    %>
                    <tr class="hover:bg-indigo-50/70 transition">
                        <td class="py-3.5 px-3 text-center font-medium"><%= idx++ %></td>
                        <td class="py-3.5 px-3 font-mono-code font-bold text-indigo-600"><%= item.getItemCode() %></td>
                        <td class="py-3.5 px-3 font-semibold text-slate-900"><%= item.getName() %></td>
                        <td class="py-3.5 px-3 text-slate-600"><%= item.getBrand() %></td>
                        <td class="py-3.5 px-3 font-mono-code text-slate-600"><%= item.getModel() %></td>
                        <td class="py-3.5 px-3 text-center font-bold text-slate-800"><%= item.getTotalSoldQuantity() %></td>
                        <td class="py-3.5 px-3 text-right font-black text-emerald-600"><%= String.format(java.util.Locale.US, "%,.2f", item.getRevenue()) %></td>
                        <td class="py-3.5 px-3 text-center">
                            <!-- selectItem : link with all item fields carried over to transaction detail -->
                            <a href="ItemTransactionDetail1.jsp?itemId=<%= item.getId() %>&itemCode=<%= java.net.URLEncoder.encode(item.getItemCode(), "UTF-8") %>&name=<%= java.net.URLEncoder.encode(item.getName(), "UTF-8") %>&brand=<%= java.net.URLEncoder.encode(item.getBrand() != null ? item.getBrand() : "", "UTF-8") %>&model=<%= java.net.URLEncoder.encode(item.getModel() != null ? item.getModel() : "", "UTF-8") %>&startDate=<%= startDateStr %>&endDate=<%= endDateStr %>" class="text-indigo-600 text-xs font-semibold hover:underline inline-flex items-center">
                                Select <i class="fa-solid fa-chevron-right ml-1 text-[10px]"></i>
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="8" class="py-8 text-center text-slate-400 font-medium">No sales records found for this period.</td>
                    </tr>
                    <% } %>
                </tbody>
                <tfoot class="bg-indigo-50/80 text-indigo-950 font-bold border-t-2 border-indigo-200">
                    <tr>
                        <td colspan="5" class="py-3 px-3 text-right uppercase tracking-wider text-xs">Total:</td>
                        <td class="py-3 px-3 text-center text-slate-900"><%= grandTotalQuantity %></td>
                        <td class="py-3 px-3 text-right text-sm text-indigo-950 font-black">$<%= String.format(java.util.Locale.US, "%,.2f", grandTotalRevenue) %></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>
        </div>

        <div class="flex justify-between items-center pt-2">
            <!-- btnBack -->
            <a href="SelectReport1.jsp" class="px-4 py-2 text-xs font-semibold text-slate-700 bg-slate-100 hover:bg-slate-200 rounded-lg border border-slate-300 inline-flex items-center">
                <i class="fa-solid fa-arrow-left mr-1.5"></i>Back
            </a>
        </div>
    </div>
</body>
</html>