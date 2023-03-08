package user;


import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class monthDateServlet extends HttpServlet{
	   
		private static final long serialVersionUID = 1L;

	    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
	    	  request.setCharacterEncoding("UTF-8");
	    	  response.setContentType("text/html;charset=UTF-8");
	      
	    	  
	    	  String date = request.getParameter("date"); 
	    	  System.out.print(date);
	    	  response.getWriter().write("1");
	      }  
}


 