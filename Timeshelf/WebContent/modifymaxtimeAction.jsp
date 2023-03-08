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
<title>최대시간 수정</title>
</head>
<body>
	<%
          UserDAO userDAO = new UserDAO();
     
          String id = (String)session.getAttribute("id");   
          String hour = request.getParameter("maxtime_hour");
          String minute = request.getParameter("maxtime_minute");
          
          double tmp_hour = Double.parseDouble(hour);
          double tmp_minute = Double.parseDouble(minute);
          tmp_minute/=60;
          
          double maxtime = tmp_hour + tmp_minute;

          int result = userDAO.modifymaxtime(id, maxtime);
          
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