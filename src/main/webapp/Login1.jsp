<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Member1, dao.MemberDAO1" %>
<%
    String registered = request.getParameter("registered");
    String error = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        request.setCharacterEncoding("UTF-8");
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Member1 m = new Member1();
        m.setUsername(username);
        m.setPassword(password);

        MemberDAO1 memberDAO = new MemberDAO1();
        boolean ok = memberDAO.checkLogin(m);
        if (ok) {
            session.setAttribute("user", m);
            if ("MANAGER".equalsIgnoreCase(m.getRole())) {
                response.sendRedirect("ManagerHome1.jsp");
            } else {
                response.sendRedirect("CustomerHome1.jsp");
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
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen flex items-center justify-center p-4">
    <div class="max-w-md w-full bg-white rounded-2xl shadow-md border border-slate-200 p-6 md:p-8 space-y-6">
        
        <!-- Registration Success Notification Box -->
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

        <% if (error != null) { %>
            <div class="p-3 mb-4 rounded-xl text-xs font-semibold bg-rose-50 text-rose-800 border border-rose-200 flex items-center space-x-2">
                <i class="fa-solid fa-circle-exclamation text-rose-600"></i>
                <span><%= error %></span>
            </div>
        <% } %>

        <form action="Login1.jsp" method="POST" class="space-y-4">
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

        <div class="pt-4 border-t border-slate-200 text-center text-xs text-slate-500">
            <span>Don't have an account?</span>
            <a href="Register1.jsp" class="ml-1 text-indigo-600 font-bold hover:underline">Register</a>
        </div>
    </div>
</body>
</html>