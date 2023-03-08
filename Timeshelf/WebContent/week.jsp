<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@page import="java.sql.SQLException"%>
 <%@page import="java.sql.DriverManager"%>
 <%@page import="java.sql.ResultSet"%>
 <%@page import="java.sql.PreparedStatement"%>
 <%@page import="java.sql.Connection"%>
 <%@ page import = "user.UserDAO"  %>
 <%@ page import = "user.User"  %>
 <%@ page import = "java.io.PrintWriter" %>
 <%@ page import = "java.util.*" %>
 <% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id = "user" class = "user.User" scope="page"/> 
 <jsp:setProperty name="user" property = "userID" />
 <jsp:setProperty name="user" property = "userPassword" />
 <jsp:setProperty name="user" property = "checkPassword" />
 <jsp:setProperty name="user" property = "userName" />
 <jsp:setProperty name="user" property = "userEmail" />
<html>
    <head>
       <script>
          function callResize()  
        {  
            var height = document.body.scrollHeight;  
            parent.resizeTopIframe(height);  
       }  
       window.onload =callResize;  
          </script>
        <style>                
            .divv{
                text-align: center;
                width:100px;
                border-style: solid;
                border-color: darkgray;
                border-radius: 20px;
                margin: 10px;
                margin-left: 13.5px;
                margin-right: 13.5px;
                padding: 10px;
                display: inline-block;
            }
            .ddiv{
               float: left;
                width: 100px;
                height : auto;
                border-style: solid;
                border-color: darkgray;
                border-radius: 20px;
                margin: 10px;
                margin-left: 17.8px;                
                padding: 15 10 10 10;
                display: inline-block; 
                min-height: 500;            
            }   
        </style>
    </head>
    <body style="text-align: center; overflow: hidden;">                
               <%
               try{
                  String Day[] = {"일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"};
                  String days[] = new String[7];
                  String id = (String)session.getAttribute("id");
                   
                  //오늘 요일 구하기
                  UserDAO userDAO = new UserDAO();                 
                  userDAO.pstmt = userDAO.conn.prepareStatement("select weekday((select DATE_FORMAT(NOW(), '%Y-%m-%d') from dual)) day");                  
                  userDAO.rs = userDAO.pstmt.executeQuery();   
                  userDAO.rs.next();
                  int t = userDAO.rs.getInt("day");
                  t = (t+1)%7; 

                  //오늘로부터 일주일 후의 날짜들 구하기
                  for(int i=0;i<7;i++){
                     userDAO.pstmt = userDAO.conn.prepareStatement("SELECT date_add((select DATE_FORMAT(NOW(), '%Y-%m-%d') from dual),INTERVAL ? DAY) day");
                     userDAO.pstmt.setInt(1, i);
                     userDAO.rs = userDAO.pstmt.executeQuery();
                     userDAO.rs.next();
                     String day = userDAO.rs.getString("day");
                     days[i] = day;
                  }
                  
                  //오늘부터 차례대로 요일 출력
                  out.print("<br>");
                  for(int i=0;i<7;i++){
                      out.print("<div class='divv'>");    
                      out.print(Day[(t+i)%7]);
                      out.print("</div>");
                  }
                  out.print("<br>");
                   
                  //오늘부터 차례대로 일정 출력
                  for(int i=0;i<7;i++){
                      out.print("<div class='ddiv' id='"+ i +"'>");    
                      userDAO.pstmt = userDAO.conn.prepareStatement("SELECT name_schedule, deadline, per_extime from schedule, schedule_per_day WHERE schedule.userid = schedule_per_day.userid AND schedule_per_day.userid = ? AND schedule.num_schedule = schedule_per_day.num_schedule AND schedule_per_day.execute_day=? order by schedule.importance desc;");
                      userDAO.pstmt.setString(1, id);
                      userDAO.pstmt.setString(2, days[i]);
                      userDAO.rs = userDAO.pstmt.executeQuery();
                      while(userDAO.rs.next()){                      
                            int hour =  (int) userDAO.rs.getDouble("per_extime");
                            int minute = (int)Math.round((userDAO.rs.getDouble("per_extime") * 10)%10 * 6);
                            if(minute == 0)
                               out.print(userDAO.rs.getString("name_schedule")+"<br>"+hour + "시간 " + "<br>"+userDAO.rs.getString("deadline")+"<br><br>");
                            else
                               out.print(userDAO.rs.getString("name_schedule")+"<br>"+hour + "시간 " + minute + "분" +"<br>"+userDAO.rs.getString("deadline")+"<br><br>");
                      }
                      out.print("</div>");
                  }
               }
               catch(Exception e) {
                    e.printStackTrace();
               }              
               %>        
    </body>
</html>