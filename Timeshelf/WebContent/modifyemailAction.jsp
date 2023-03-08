<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
    
    
 <%@ page import = "user.User"  %>
 <%@ page import = "java.util.*" %>
 <%@ page import = "java.util.Date" %>
 <%@ page import = "user.UserDAO"  %>
 <%@ page import = "java.io.PrintWriter" %>
 <%@page import="java.sql.*"%>
 <%@page import="java.text.*"%>
 <%@page import="java.time.*"%>
 <% request.setCharacterEncoding("UTF-8"); %>
 
 <jsp:useBean id = "user" class = "user.User" scope="page"/>
 <jsp:setProperty name="user" property = "userID" />
 <jsp:setProperty name="user" property = "userPassword" />
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
      <%
          UserDAO userDAO = new UserDAO();
     
          String id = (String)session.getAttribute("id");   
          String email = request.getParameter("email");
        
          int result = userDAO.modifyemail(id, email);
          
          if(result == -1){
              PrintWriter script = response.getWriter();
              script.println("<script>");
              script.println("alert('오류')");
              script.println("history.back()");
              script.println("</script>");
           }  
           else{              
              PrintWriter script = response.getWriter();
              script.println("<script>");
              script.println("location.href = 'mypage.jsp'");
               script.println("</script>");          
           }
          
      %>
</body>
</html>