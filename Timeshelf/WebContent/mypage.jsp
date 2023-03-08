<%@ page import="user.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<html>
    <head>

   <!-- sql 연동 부분 -->  
 	<%
 		
		String sql = ""; 
        
        UserDAO userDAO = new UserDAO();    
        String id = (String)session.getAttribute("id");
        String name = (String)session.getAttribute("name");   
        String email = userDAO.getemail(id);
        
		if(id==null)
		{
			response.sendRedirect("login.jsp");
		}		
		request.setCharacterEncoding("utf-8");		
 	 %>
       
       <!-- 함수 -->
        <script>       
           <!-- 요소 보이도록 -->
           function show(show){
              document.getElementById(show).style.display = 'inline-block'
           }
           
           <!-- 요소 안보이도록 -->
           function hide(hide){
              document.getElementById(hide).style.display = 'none'
           }
                    
        </script>
        <style>
            #mypagediv{
                text-align: center;              
                width: 700;
             
                margin: auto;
                margin-top: 40;
            }
            #information{
                border-style: solid;
                text-align: left;
                padding: 30;
                width: 500;
               
                margin: auto;
            }
            #memo{
                border-style: solid;
                text-align: left;
                padding: 30;
                width: 500;
                margin: auto;
            }
            .info{
                display: inline-block;
                font-size: 18;
                margin: 15 0 15 0;
                width: 190;
            }
            #infoname, #infoid, #infoemail, #infomaxtime, #infomintime, #infotimesleep, #infotimeorder, #infomemo{
                font-size: 18;
            }
            .tit{
                width: 520;
                 
                margin-left: 80;
                text-align: left;
                font-size: 20;
                margin-top: 10;
                margin-bottom: 13;
                font-weight: bold;
            }
            #on{
                font-size: 25;
            }
            .modi{
                background-color: white;
                border-color: black;
                font-weight: bold;
                font-size: 15;
                padding: 2 6 3 6;
                margin: 11 10 0 0;
                float: right;
                border-radius: 4px;
            }
            .modi2{
                background-color: white;
                border-color: black;
                font-weight: bold;
                font-size: 15;
                padding: 2 6 3 6;
                margin: 5 10 5 0;
                //float: right;
                border-radius: 4px;
            }
            #pwmodi{
                display: inline;
                background-color: white;
                border-color: black;
                border-style: solid;
                border-width: 2;
                font-weight: bold;
                font-size: 15;
                padding: 2 6 3 6;
                //float: right;
                //margin-top: 14;
                border-radius: 4px;
                margin-left: 161;
            }
            #new_email{
                border-style: solid;
                border-color: black;
                border-radius: 4px;
                padding: 3 6 3 6;
                margin: 11 10 0 0;           
                //font-size: 18;
            }
            #new_memo{
               float: center;
               font-size: inherit;
               width: 500px;
            }
            #maxtime_hour, #maxtime_minute, #mintime_hour, #mintime_minute{
                border-style: solid;
                border-color: black;
                border-radius: 4px;
                padding: 3 6 3 6;
                margin-top: -1;              
                font-size: 18;
            }
            #sleep_start, #sleep_end{
                border-style: solid;
                border-color: black;
                border-radius: 4px;
                padding: 2 6 3 6;
                margin-bottom: 10;
                float: right;
                margin-right: 10;
            }
            #ordertime_modify{
               text-align: right;
               display: inline-block;
               float: right;
               padding: 2 6 3 6;
            }
           
            form{
               display: inline;
            }
        </style>
    </head>
    <body>
        <div id="mypagediv">
            <a target="_self" href="mainMypage.jsp" ><img src="image\logo.png" width="250" style="margin-bottom: -20"></a><br><br><br>
            <div class="tit">
               회원정보
            </div>
           
            <div id="information">
               <!-- 이름 -->
               <span class="info">이름</span>
               <span id="infoname"><%= name%></span>
               <br>
               
               <!-- 아이디 -->
               <span class="info">아이디</span>
               <span id="infoid"><%= id%></span>
               <a target="_self" href="passwordChange.jsp">
                  <input type="button" id="pwmodi" value="비밀번호 변경">
               </a>
               <br>
               
               <!-- 이메일 -->
               <span class="info">이메일</span>
               <span id="infoemail"><%= email%></span>
               
               <input type="button" class="modi" value="수정" id="modify_button_email" onclick='hide("modify_button_email"); show("complete_cancel_email"); hide("infoemail"); show("email_modify");'>
               <form name="emailform" action="modifyemailAction.jsp">
                  <span id="email_modify" style="display: none">
                     <input type="email" size=42 id="new_email" value="<%= email %>" name="email" required>
                  </span>
                 <span id="complete_cancel_email" style="display: none">
                     <input type="button" class="modi2" style="margin-left: 315" value="수정 취소" id="modify_cancel_email" onclick='show("modify_button_email"); hide("complete_cancel_email"); show("infoemail"); hide("email_modify");'>
                     <input type="submit" class="modi2" value="수정 완료" id="modify_complete_email"  onclick='show("modify_button_email"); hide("complete_cancel_email"); show("infoemail"); hide("email_modify");'>
                 </span>
               </form><br>
               
               <!-- max_time -->
               <span class="info">한 일정당 최대 시간</span>            
               <span id="infomaxtime" style="display: inline">
                   <%
                    sql = "SELECT max_time FROM mypage WHERE userid = ?";
                      double maxtime_hour = 0;
                      double maxtime_minute = 0;
                     try{
                    	 userDAO.pstmt = userDAO.conn.prepareStatement(sql);
                    	 userDAO.pstmt.setString(1, id);
                    	 userDAO.rs = userDAO.pstmt.executeQuery();
                       while(userDAO.rs.next()){  
                         
                          double maxtime = userDAO.rs.getDouble(1);                        
                          maxtime_hour = maxtime;
                          maxtime_minute = (maxtime * 10)%10 * 6;
                   %>
                        <%= (int)maxtime_hour %>시간
                        <%= (int)maxtime_minute %>분
                           
                   <%     }
                     }catch(SQLException e){
                        e.printStackTrace();
                     }
                   %>
               </span>
               
               <input type="button" class="modi" value="수정" id="modify_button_maxtime" style="display: inline-block" onclick='hide("modify_button_maxtime"); show("complete_cancel_maxtime"); hide("infomaxtime"); show("maxtime_modify");'>
                <form name="maxtimeform" action = "modifymaxtimeAction.jsp">
                  <span id="maxtime_modify" style="display: none">
                  <input type="number" name = "maxtime_hour" style="width: 40" id='maxtime_hour' value="<%= (int)maxtime_hour %>" min="0" max="24"> 시간
                  <input type="number" name = "maxtime_minute" style="width: 40; margin-left: 20" id='maxtime_minute' value="<%= (int)maxtime_minute %>" min="0" max="59"> 분
                     
                  </span>
                  <span id="complete_cancel_maxtime" style="display: none">
                     <input type="button" class="modi2" style="margin-left: 315" value="수정 취소" id="modify_cancel_maxtime" onclick='show("modify_button_maxtime"); hide("complete_cancel_maxtime"); show("infomaxtime"); hide("maxtime_modify");'>
                     <input type="submit" class="modi2" value="수정 완료" id="modify_complete_maxtime" onclick='show("modify_button_maxtime"); hide("complete_cancel_maxtime"); show("infomaxtime"); hide("maxtime_modify");'>
                 </span>
               </form><br>
               
               <!-- min_time -->
               <span class="info">한 일정당 최소 시간</span>
               <span id="infomintime">
                  <%
                     sql = "SELECT min_time FROM mypage WHERE userid = ?";
                     double mintime_hour = 0;
                     double mintime_minute = 0;
                     try{
                    	 userDAO.pstmt = userDAO.conn.prepareStatement(sql);
                    	 userDAO.pstmt.setString(1, id);
                    	 userDAO.rs = userDAO.pstmt.executeQuery();
                        while(userDAO.rs.next()){  
                          
                           double mintime = userDAO.rs.getDouble(1);                          
                           mintime_hour = mintime;
                           mintime_minute = (mintime * 10)%10 * 60 / 10;
                        %>
                           
                           <%= (int)mintime_hour %>시간
                           <%= (int)mintime_minute %>분
                           
                        <%  }
                     }catch(SQLException e){
                        e.printStackTrace();
                     }
                     
                  %>
               </span>
               <input type="button" class="modi" value="수정" id="modify_button_mintime" onclick='hide("modify_button_mintime"); show("complete_cancel_mintime"); hide("infomintime"); show("mintime_modify");'>
               
               <form name="mintimeform" action = "modifymintimeAction.jsp">
                  <span id="mintime_modify" style="display: none">               
                     <input type="number" name = "mintime_hour" style="width: 40" id='mintime_hour' value="<%= (int)mintime_hour %>" min="0" max="24"> 시간
                     <input type="number" name = "mintime_minute" style="width: 40; margin-left: 20" id='mintime_minute' value="<%= (int)mintime_minute %>" min="0" max="59"> 분

                     <br>
                  </span>
                  <span id="complete_cancel_mintime" style="display: none">
                     <input type="button" class="modi2" style="margin-left: 315" value="수정 취소" id="modify_complete_mintime" onclick='show("modify_button_mintime"); hide("complete_cancel_mintime"); show("infomintime"); hide("mintime_modify");'>
                       <input type="submit" class="modi2" value="수정 완료" id="modify_cancel_mintime" onclick='show("modify_button_mintime"); hide("complete_cancel_mintime"); show("infomintime"); hide("mintime_modify");'>
                 </span>
               </form>
               
               <!-- start_t -->
               <span class="info" >스케쥴 시간</span>
               <span id="infotimesleep">
                  <%
                    sql = "SELECT start_t, end_t FROM mypage WHERE userid = ?";
                   	double end_hour = 0;
                   	double end_minute = 0;
                   	double start_hour = 0;
                   	double start_minute = 0;
                     try{
                    	 userDAO.pstmt = userDAO.conn.prepareStatement(sql);
                    	 userDAO.pstmt.setString(1, id);
                    	 userDAO.rs = userDAO.pstmt.executeQuery();
                        
                        while(userDAO.rs.next()){                           
                           
                           double start_t = userDAO.rs.getDouble(1);
                           double end_t = userDAO.rs.getDouble(2);
                           start_hour = start_t;
                           start_minute = (start_t * 10)%10 * 60 / 10;
                           end_hour = end_t;
                           end_minute = (end_t * 10)%10  * 60 / 10;
                           
                        %>
                           
                           <%= (int)start_hour %>시
                           <%= (int)start_minute %>분
                           <span style="font-size: 25;">&nbsp;~&nbsp;</span>
                          
                           <%= (int)end_hour%>시
                           <%= (int)end_minute%>분
                           
                        <%  }
                     }catch(SQLException e){
                        e.printStackTrace();
                     }
                  %>
                  
               </span>
               <input type="button" class="modi" value="수정" id="modify_button_timesleep" onclick='hide("modify_button_timesleep"); show("complete_cancel_timesleep"); hide("infotimesleep"); show("timesleep_modify");'>
                
               <form name="sleepform" action="timesleepAction.jsp">
                  <span id="timesleep_modify" style="display: none">
                  
                     <input type="number" style="width: 40" id='mintime_hour' value="<%= (int)start_hour%>" min="0" max="24" name = "start_hour" required> 시 
                     <input type="number" style="width: 40" id='mintime_minute' value="<%= (int)start_minute%>" min="0" max="59" name = "start_minute" required> 분 &nbsp;~&nbsp;
                     
                     <input type="number" style="width: 40" id='mintime_hour' value="<%= (int)end_hour%>" min="0" max="24" name = "end_hour" required> 시  
                     <input type="number" style="width: 40" id='mintime_minute' value="<%= (int)end_minute%>" min="0" max="59" name = "end_minute" required> 분
                        

                  </span>
                  <span id="complete_cancel_timesleep" style="display: none">
                     <input type="button" class="modi2" style="margin-left: 315" value="수정 취소" id="modify_cancel_timesleep" onclick='show("modify_button_timesleep"); hide("complete_cancel_timesleep"); show("infotimesleep"); hide("timesleep_modify");'>                  
                     <input type="submit" class="modi2" value="수정 완료" id="modify_complete_timesleep" onclick='show("modify_button_timesleep"); hide("complete_cancel_timesleep"); show("infotimesleep"); hide("timesleep_modify");'>
                 </span>
               </form>
            </div>
            
            <!-- memo -->
            <br>
            <div class="tit">
               메모            
            </div>
           
            <div id="memo">
                <span id="infomemo">
                   <%
                  sql = "SELECT memo FROM mypage WHERE userid = ?";
                    String memo_txt = "";
                  try{
                	  userDAO.pstmt = userDAO.conn.prepareStatement(sql);
                	  userDAO.pstmt.setString(1, id);
                	  userDAO.rs = userDAO.pstmt.executeQuery();
                     while(userDAO.rs.next()){  
                        String memo = userDAO.rs.getString(1);
                        memo_txt = memo;
                     %>
                        
                        <%= memo %>
                        
                     <%  }
                  }catch(SQLException e){
                     e.printStackTrace();
                  }
               %>
                </span>
                <input type="button" class="modi" style="margin-top: -2;" value="수정" id="modify_memo" onclick='hide("modify_memo"); show("complete_cancel_memo"); hide("infomemo"); show("memo_modify");'>
                <form name="infomemo" action = "modifymemoAction.jsp">
                   <span id="memo_modify" style="display: none">
                      <input type="text" name="memo" size=45 id="new_memo" value="<%= memo_txt%>">
                   </span>
                   <span id="complete_cancel_memo" style="display: none">
                    
                     <input type="submit" class="modi" style="margin-top: 15;" value="수정 완료" id="modify_complete" onclick='show("modify_memo"); hide("complete_cancel_memo");'>
                     <input type="button" class="modi" style="margin-top: 15;" value="수정 취소" id="modify_cancel" onclick='show("modify_memo"); hide("complete_cancel_memo"); show("infomemo"); hide("memo_modify");'>
                  </span>
                </form>
            </div>
            <br>
            <span id="on">ⓒO(n) 2021</span>
        </div>
    </body>
</html>