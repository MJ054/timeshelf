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
<title>JSP �Խ��� �� ����Ʈ</title>
</head>
<body>
      <%
          UserDAO userDAO = new UserDAO();
          int result = userDAO.login(user.getUserID(), user.getUserPassword());
          if(result == 1){    //������    	 
        	  ArrayList<User> list = userDAO.getList(user.getUserID());
        	  session.setAttribute("id",user.getUserID());
        	  session.setAttribute("name",list.get(0).getUserName());
        	  session.setAttribute("email",list.get(0).getUserEmail());  
        	  session.setAttribute("password",list.get(0).getUserPassword());
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("location.href ='mainMypage.jsp'");
        	  script.println("</script>");
          }  
          else if(result == 0){
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("alert('��й�ȣ�� Ʋ���ϴ�.')");
        	  script.println("history.back()");
        	  script.println("</script>");
          }
          else if(result == -1){
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("alert('�������� �ʴ� ���̵��Դϴ�.')");
        	  script.println("history.back()");
        	  script.println("</script>");
          }
          else if(result == -2){
        	  PrintWriter script = response.getWriter();
        	  script.println("<script>");
        	  script.println("alert('�����ͺ��̽� ������ �߻��߽��ϴ�.')");
        	  script.println("history.back()");
        	  script.println("</script>");
          }
      %>
</body>
</html>