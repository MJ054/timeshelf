<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
    
    
 <%@ page import = "user.User"  %>
 <%@ page import = "java.util.ArrayList" %>
 <%@ page import = "user.UserDAO"  %>
 <%@ page import = "java.io.PrintWriter" %>
 <% request.setCharacterEncoding("UTF-8"); %>
 
 <jsp:useBean id = "user" class = "user.User" scope="page"/>
 <jsp:setProperty name="user" property = "userPassword" />
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
      <%
          String id = (String)session.getAttribute("id");
          String password = (String)session.getAttribute("password");	
          UserDAO userDAO = new UserDAO();
         
          if(!password.equals(userDAO.passwordcheck(id))){
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("alert('현재 비밀번호 확인')");
        	  script.println("history.back()");
        	  script.println("</script>");
          }else if(!request.getParameter("newPassword1").equals(request.getParameter("newPassword2"))){
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("alert('비밀번호가 같지않습니다.')");
        	  script.println("history.back()");
        	  script.println("</script>");
          }else{
        	 session.setAttribute("password",request.getParameter("newPassword1"));	
        	 userDAO.passwordChange(request.getParameter("newPassword1"), id);
        	 PrintWriter script = response.getWriter();
       	     script.println("<script>");
       	     script.println("alert('비밀번호가 변경되었습니다.')");
       	     script.println("location.href = 'mypage.jsp'");
       	     script.println("</script>");
       	  
        	// response.sendRedirect("myPage.jsp");
          }
        

      %>
</body>
</html>