<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Report Criteria - Supermarket Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <script>
        function validateDateCriteria() {
            var startInput = document.getElementById("startDate");
            var endInput = document.getElementById("endDate");
            var banner = document.getElementById("errorBanner");
            var errorMsg = document.getElementById("errorMessage");

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
        <div class="border-b border-slate-200 pb-4">
            <h3 class="font-extrabold text-slate-900 text-lg">Select Report Criteria</h3>
            <p class="text-xs text-slate-500 mt-0.5">Specify report type and time interval</p>
        </div>

        <!-- Validation Error Alert Banner -->
        <div id="errorBanner" class="hidden p-3.5 bg-rose-50 border border-rose-200 text-rose-700 text-xs rounded-xl flex items-center gap-2.5">
            <i class="fa-solid fa-circle-exclamation text-rose-500 text-base shrink-0"></i>
            <span id="errorMessage" class="font-medium">End Date cannot be earlier than Start Date. Please select a valid date range.</span>
        </div>

        <form id="reportForm" action="ItemRevenueStat1.jsp" method="GET" onsubmit="return validateDateCriteria()" class="space-y-4">
            <div>
                <label class="block text-xs font-semibold text-slate-700 mb-1.5">
                    Report Type (*)
                </label>
                <select name="reportType" class="w-full text-xs px-3.5 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:outline-none bg-white font-medium">
                    <option value="itemRevenue" selected>Item Revenue Statistics</option>
                </select>
            </div>

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

            <div class="pt-4 border-t border-slate-200 flex justify-between items-center">
                <a href="ManagerHome1.jsp" class="px-4 py-2.5 text-xs font-semibold text-slate-600 hover:bg-slate-100 rounded-lg border border-slate-300 inline-flex items-center">
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