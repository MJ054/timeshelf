<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
    
    
     <%@ page import = "user.User"  %>
     <%@ page import = "java.util.ArrayList" %>
 <%@ page import = "user.UserDAO"  %>
 <%@ page import = "java.io.PrintWriter" %>
 <% request.setCharacterEncoding("UTF-8"); %>
 
 <jsp:useBean id = "user" class = "user.User" scope="page"/>
 <jsp:setProperty name="user" property = "userID" />
 <jsp:setProperty name="user" property = "userPassword" />
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 
</head>
<body>
 <%
 		 String del = request.getParameter("del"); 
 		 int num_schedule = Integer.parseInt(del);
 		System.out.print("=====");
 		 System.out.print(del);
          UserDAO userDAO = new UserDAO();
          userDAO.delete_schedule(num_schedule);
         
      %>
       <script>document.location.href="addscheduleAction.jsp?del=del"</script>
</body>
</html>