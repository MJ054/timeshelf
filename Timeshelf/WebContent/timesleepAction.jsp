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
          String start_hour = request.getParameter("start_hour");
         String start_minute = request.getParameter("start_minute"); 
         String end_hour = request.getParameter("end_hour");
         String end_minute = request.getParameter("end_minute");

         double tmp_startH = Double.parseDouble(start_hour);
         double tmp_startM = Double.parseDouble(start_minute);
         tmp_startM/=60;
         double start_t = tmp_startH + tmp_startM;
         
         double tmp_endH = Double.parseDouble(end_hour);
         double tmp_endM = Double.parseDouble(end_minute);
         tmp_endM/=60;
         double end_t = tmp_endH + tmp_endM;
        
           int result = userDAO.modifytime(id, start_t, end_t);
          
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
</html>html>