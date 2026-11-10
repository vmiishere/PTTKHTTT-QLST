<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Customer1, model.Address1, dao.MemberDAO1, dao.CustomerDAO1, java.text.SimpleDateFormat, java.util.Date" %>
<%
    request.setCharacterEncoding("UTF-8");

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");
    String name = request.getParameter("name");
    String dobStr = request.getParameter("dob");
    String tel = request.getParameter("tel");
    String email = request.getParameter("email");
    String houseNumber = request.getParameter("houseNumber");
    String street = request.getParameter("street");
    String ward = request.getParameter("ward");
    String city = request.getParameter("city");

    // Preserve user inputs in request scope
    request.setAttribute("username", username);
    request.setAttribute("name", name);
    request.setAttribute("dob", dobStr);
    request.setAttribute("tel", tel);
    request.setAttribute("email", email);
    request.setAttribute("houseNumber", houseNumber);
    request.setAttribute("street", street);
    request.setAttribute("ward", ward);
    request.setAttribute("city", city);

    // Basic validation
    if (username == null || username.trim().isEmpty() ||
        password == null || password.trim().isEmpty() ||
        name == null || name.trim().isEmpty() ||
        street == null || street.trim().isEmpty() ||
        ward == null || ward.trim().isEmpty() ||
        city == null || city.trim().isEmpty()) {
        
        request.setAttribute("errorMessage", "Validation Error: Please fill in all required fields (*).");
        request.getRequestDispatcher("Register1.jsp").forward(request, response);
        return;
    }

    if (!password.equals(confirmPassword)) {
        request.setAttribute("errorMessage", "Validation Error: Password confirmation does not match the password entered.");
        request.getRequestDispatcher("Register1.jsp").forward(request, response);
        return;
    }

    // 1. Encapsulate entity object Customer1
    Date dob = new Date();
    try {
        if (dobStr != null && !dobStr.trim().isEmpty()) {
            dob = new SimpleDateFormat("yyyy-MM-dd").parse(dobStr);
        }
    } catch (Exception ignored) {}

    Address1 address = new Address1(houseNumber, street, ward, city);
    Customer1 cust = new Customer1(username, password, name, dob, tel, email, null, address);

    // 2. Call MemberDAO1 to check username uniqueness
    MemberDAO1 memberDAO = new MemberDAO1();
    boolean isUsernameExist = memberDAO.checkUsername(username);

    if (isUsernameExist) {
        request.setAttribute("errorMessage", "Registration Error: The username '" + username + "' is already registered. Please choose another username.");
        request.getRequestDispatcher("Register1.jsp").forward(request, response);
        return;
    }

    // 3. Call CustomerDAO1 to persist customer into database
    CustomerDAO1 customerDAO = new CustomerDAO1();
    boolean isSaved = customerDAO.saveCustomer(cust);

    if (isSaved) {
        session.setAttribute("registeredUser", username);
        response.sendRedirect("Login1.jsp?registered=success");
    } else {
        request.setAttribute("errorMessage", "System Error: Failed to register account into database. Please try again later.");
        request.getRequestDispatcher("Register1.jsp").forward(request, response);
    }
%>
