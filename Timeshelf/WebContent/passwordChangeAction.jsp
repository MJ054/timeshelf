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
<title>JSP �Խ��� �� ����Ʈ</title>
</head>
<body>
      <%
          String id = (String)session.getAttribute("id");
          String password = (String)session.getAttribute("password");	
          UserDAO userDAO = new UserDAO();
         
          if(!password.equals(userDAO.passwordcheck(id))){
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("alert('���� ��й�ȣ Ȯ��')");
        	  script.println("history.back()");
        	  script.println("</script>");
          }else if(!request.getParameter("newPassword1").equals(request.getParameter("newPassword2"))){
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("alert('��й�ȣ�� �����ʽ��ϴ�.')");
        	  script.println("history.back()");
        	  script.println("</script>");
          }else{
        	 session.setAttribute("password",request.getParameter("newPassword1"));	
        	 userDAO.passwordChange(request.getParameter("newPassword1"), id);
        	 PrintWriter script = response.getWriter();
       	     script.println("<script>");
       	     script.println("alert('��й�ȣ�� ����Ǿ����ϴ�.')");
       	     script.println("location.href = 'mypage.jsp'");
       	     script.println("</script>");
       	  
        	// response.sendRedirect("myPage.jsp");
          }
        

      %>
</body>
</html>