package user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UserRegisterServlet extends HttpServlet{
      private static final long serialVerstionUID = 1L;
      
      protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	  request.setCharacterEncoding("UTF-8");
    	  response.setContentType("text/html;charset=UTF-8");
    	  String ID = request.getParameter("");
      }  // ����ڰ� ȸ������ �ϴ� �� ó���� �� �ִ� �ڵ�
}
