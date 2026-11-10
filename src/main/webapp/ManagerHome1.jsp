<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member1" %>
<%
    Member1 user = (Member1) session.getAttribute("user");
    String managerName = (user != null && user.getName() != null) ? user.getName() : "Arthur Dent";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard - Supermarket Management System</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">
    <!-- Top Bar -->
    <header class="bg-slate-900 text-white shadow-md sticky top-0 z-50 border-b border-slate-800">
        <div class="max-w-7xl mx-auto px-4 py-3 flex justify-between items-center">
            <div class="flex items-center space-x-3">
                <span class="bg-indigo-600 text-white px-2.5 py-1 rounded font-black text-xs tracking-wider uppercase">SMS Portal</span>
                <h1 class="text-base md:text-lg font-bold tracking-tight">Electronics Supermarket Enterprise System</h1>
            </div>
            <div class="flex items-center space-x-4 text-xs text-slate-300">
                <span>Manager: <strong class="text-white"><%= managerName %></strong></span>
                <a href="Login1.jsp" class="text-rose-400 hover:text-rose-300 font-semibold transition">Log Out</a>
            </div>
        </div>
    </header>

    <main class="max-w-xl mx-auto mt-12 p-6 md:p-8 bg-white rounded-2xl border border-slate-200 shadow-sm space-y-6">
        <!-- Manager Profile Banner -->
        <div class="flex items-center space-x-4 border-b border-slate-200 pb-4">
            <div class="w-12 h-12 rounded-full bg-indigo-100 text-indigo-700 flex items-center justify-center font-bold text-lg">
                AD
            </div>
            <div>
                <h3 class="font-bold text-slate-900 text-base">Manager Dashboard</h3>
                <p class="text-xs text-slate-500">Manager: <span class="font-semibold text-indigo-700"><%= managerName %></span> (Level: Senior Store Manager)</p>
            </div>
        </div>

        <!-- Single Functional Trigger strictly in design: subViewReport -->
        <div class="p-6 bg-indigo-50/70 border border-indigo-200 rounded-xl space-y-3 text-center">
            <div class="w-12 h-12 rounded-xl bg-indigo-600 text-white flex items-center justify-center text-xl mx-auto shadow">
                <i class="fa-solid fa-chart-pie"></i>
            </div>
            <h4 class="font-bold text-sm text-indigo-950">Revenue & Statistics Reports</h4>
            <p class="text-xs text-slate-600 max-w-sm mx-auto">Access sales performance analytics and track item revenues down to transaction invoices.</p>
            <div class="pt-2">
                <!-- subViewReport : link -->
                <a href="SelectReport1.jsp" class="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-xs rounded-lg shadow transition inline-flex items-center">
                    <i class="fa-solid fa-chart-column mr-2"></i>
                    <span>View Statistics & Reports</span>
                </a>
            </div>
        </div>
    </main>
</body>
</html>