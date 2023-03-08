<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
    
    
 <%@ page import = "user.User"  %>
 <%@ page import = "java.util.ArrayList" %>
 <%@ page import = "user.UserDAO" %>
 <%@ page import = "java.io.PrintWriter" %>
 <% request.setCharacterEncoding("UTF-8"); %>
 
  <%@page import="java.sql.SQLException"%>
 <%@page import="java.sql.DriverManager"%>
 <%@page import="java.sql.ResultSet"%>
 <%@page import="java.sql.PreparedStatement"%>
 <%@page import="java.sql.Connection"%>
 <%@ page import = "user.UserDAO"  %>
 <%@ page import = "user.User"  %>
 <%@ page import = "java.io.PrintWriter" %>
 <%@ page import = "java.util.*" %>
 <%@ page import = "java.text.SimpleDateFormat" %>
 <%@ page import = "java.util.Calendar" %>
 
<%--  <jsp:useBean id = "user" class = "user.User" scope="page"/>
 <jsp:setProperty name="user" property = "userID" />
 <jsp:setProperty name="user" property = "userPassword" /> --%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP 게시판 웹 사이트</title>
</head>
<body>
      <%                                      
                  String id = (String)session.getAttribute("id");   
                  String state = request.getParameter("state"); 
                  String del = request.getParameter("del");                  
                  String prefer_time;
                  int result = -1;
                  
                  UserDAO userDAOa = new UserDAO();
                  
                  if(del == null){  //insesrt or update               	  
                     int importance = Integer.parseInt(request.getParameter("importance"));        
                     String ET = request.getParameter("ex_time");         
                     Double ex_time = (Double.parseDouble(ET.substring(0, 2))*60+Double.parseDouble(ET.substring(3)))/60.0;      
                     String memo = request.getParameter("memo");
                     String deadline = request.getParameter("deadline");
                     String name_schedule = request.getParameter("name");
                     
                     if(memo == "") 
                          memo = null;
                     if(state.equals("insert")){  //insert 상태
                          result = userDAOa.InSchedule(request.getParameter("name"), request.getParameter("deadline"), importance, ex_time, memo, id);                       
                          }
                       else if(state.equals("update")){  //update 상태                                 
                              int num_schedule = Integer.parseInt(request.getParameter("ns"));  
                              result = userDAOa.modifyschedule(id, name_schedule, deadline, importance, ex_time, memo, num_schedule);
                                                
                        }                     
                  }else{  //delete 상태
                     result = 0;
                  }
       
                       if(result == -1){   //실패
                          PrintWriter script = response.getWriter();
                          script.println("<script>");
                          script.println("alert('오류')");
                          script.println("history.back()");
                          script.println("</script>");
                       }  
                       else{  //성공
                          PrintWriter script = response.getWriter();
                          script.println("<script>");
                          if(del!=null){
                             script.println("alert('삭제 완료')");
                             script.println("location.href = 'month.jsp'");
                          }
                          else if(state.equals("insert")){
                             script.println("alert('추가 성공')");
                             script.println("location.href = 'addschedule.jsp'");
                          }
                          else{
                             script.println("alert('수정 완료')");
                             script.println("location.href = 'month.jsp'");
                          }                     
                           script.println("</script>");
               
                           
                           
                           
                           /* --선언-- */
                           ResultSet r1, r2, r3; //r1 마이페이지, r2 급한 일정, r3 일반일정
                          r1 = null;
                          r2 = null;
                          r3 = null;
                          UserDAO userDAO = new UserDAO();
                          UserDAO userDAO2 = new UserDAO();
                          UserDAO userDAO3 = new UserDAO();
                          double max_time = 0; //일정 하나 최소 수행 시간
                          double min_time = 0; //일정 하나 최대 수행 시간
                          double start = 0; //일정 시작 시간
                          double end = 0; //일정 종료 시간
                          double mid_time = 0;
                          double duration; //하루 수행가능한 일정시간

                          SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                          Date to_day = new Date(); //현재 날짜.
                          String dateString = sdf.format(to_day);
                          Date t = sdf.parse(dateString);
                          Calendar today= Calendar.getInstance(); //deadline까지 남은 날짜 계산용
                          today.setTime(t);
                          Calendar cal = Calendar.getInstance(); // while문 도는 기준 날짜 역할
                          
                          
                          
                          //schedule_per_day 테이블 레코드 전부 삭제, schedule 테이블 dur_time, overtime 초기화
                          UserDAO userDAOd = new UserDAO();
                           userDAOd.pstmt = userDAOd.conn.prepareStatement("DELETE FROM schedule_per_day WHERE userid = ?;");
                           userDAOd.pstmt.setString(1, id);
                           userDAOd.pstmt.executeUpdate();
                           userDAOd.pstmt = userDAOd.conn.prepareStatement("UPDATE schedule SET dur_time = ex_time, overtime = 0 WHERE userid = ?;");
                             userDAOd.pstmt.setString(1, id);
                             userDAOd.pstmt.executeUpdate();
                          
                          try{
                             
                               userDAO.pstmt = userDAO.conn.prepareStatement("SELECT * FROM mypage WHERE mypage.userid = ?;");
                                userDAO.pstmt.setString(1, id);
                                
                               userDAO.rs = userDAO.pstmt.executeQuery();
                               userDAO.rs.next();
                               
                             max_time = userDAO.rs.getDouble("max_time");
                             min_time = userDAO.rs.getDouble("min_time");
                             
                             start = userDAO.rs.getDouble("start_t");
                             end = userDAO.rs.getDouble("end_t");
                             r1 = userDAO.rs;
                             
                          } catch(Exception e){
                             System.out.println("\n--------에러 in 210---------\n");
                              e.printStackTrace();
                          } 
                       
                          //mypage 설정 사항 기반 알고리즘 변수 세팅
                          mid_time = (min_time+max_time)/2;
                          
                          if(end > start)
                             duration = end - start;
                          else
                             duration = end+24 -start; // 자정 지나서 새벽이 end일 때 고려
                           
                             
                          /* --알고리즘-- */
                          while(true){
                             String dt2 = cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH)+1) + "-" + cal.get(Calendar.DAY_OF_MONTH);
                             dt2 = dt2 + " 01:01:01";
                             
                             //급한 일정 r2 가져오기
                             userDAO2.pstmt = userDAO2.conn.prepareStatement("SELECT num_schedule, deadline, ex_time, dur_time FROM schedule WHERE schedule.userid = ? AND schedule.importance >=4 AND datediff( schedule.deadline, ? ) >=0 AND datediff( schedule.deadline, ? ) <= 2 ORDER BY importance DESC;", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                               userDAO2.pstmt.setString(1, id);
                                userDAO2.pstmt.setString(2, dt2);
                                userDAO2.pstmt.setString(3, dt2);
                               r2 = userDAO2.pstmt.executeQuery();
                               
                               //일반 일정 r3 가져오기
                               userDAO3.pstmt = userDAO3.conn.prepareStatement("SELECT num_schedule, deadline, ex_time, dur_time FROM schedule WHERE schedule.userid = ? AND num_schedule NOT IN (SELECT num_schedule FROM schedule WHERE schedule.userid = ? AND schedule.importance >=4 AND datediff( schedule.deadline, ? ) >=0 AND datediff( schedule.deadline, ? ) <= 2) ORDER BY importance DESC;", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                               userDAO3.pstmt.setString(1, id);
                                userDAO3.pstmt.setString(2, id);
                                userDAO3.pstmt.setString(3, dt2);
                                userDAO3.pstmt.setString(4, dt2);
                               r3 = userDAO3.pstmt.executeQuery();
                           
                             double dur = duration; //duration으로 while문 마다 초기화 해야하므로 duration은 값이 바뀌면 안됨.
                          
                             //급한 일정 알고리즘
                             while(r2.next()){
                                //한 일정에 대해서 extime, durtime, deadline 가져오기
                                double ext = r2.getDouble("ex_time"); //일정 전체 수행 시간: 하루 당 일정 수행 시간 구할 때
                                double dur_ex = r2.getDouble("dur_time");//아직 배치되지 않은 수행 시간 확인용
                                Date de_ad = r2.getDate("deadline"); // cal과의 계산을 위해 deadline을 캘린더로! 
                                String deadString = sdf.format(de_ad);
                                Date d = sdf.parse(deadString);
                                Calendar dead = Calendar.getInstance( );
                                dead.setTime ( d );
                           
                                //해당 일정이 이미 배치 완료된 경우 다음 일정으로
                                if(dur_ex == 0)
                                   continue; 
                           
                                double count = 0; //아래 while문 돌면서 일수 차이 계산용
                                while( !today.after(dead)){
                                   count++;
                                   today.add( cal.DATE, 1 );
                                   
                                 }
                                
                                if(count == 0){//deadline이 지났는데 아직 배정 안된 시간이 있는 경우 = 시간이 모자라는 경우 -> overtime 업데이트
                                   if(dur_ex != 0){
                                      try{
                                         UserDAO userDAO5 = new UserDAO();
                                         int tmpt = r2.getInt("num_schedule");
                                         userDAO5.pstmt = userDAO5.conn.prepareStatement("UPDATE schedule SET schedule.overtime = ? , schedule.dur_time = 0 WHERE schedule.userid = ? AND schedule.num_schedule = ?");
                                         userDAO5.pstmt.setDouble(1, dur_ex);
                                         userDAO5.pstmt.setString(2, id);
                                         userDAO5.pstmt.setInt(3, tmpt);
                                         userDAO5.pstmt.executeUpdate();
                                      } catch(Exception e){
                                         System.out.println("\n--------에러 in 277---------\n");
                                         e.printStackTrace();
                                      }
                                   }
                                   continue;//이에 해당되는 다른 일정이 있는지 확인해야 하므로
                                }
                                
                                today.setTime(cal.getTime()); // 다음 일정 deadline까지의 일수 계산을 위해 today 초기화.
                                
                                
                                /* --pctime 설정-- */
                                //pctime은 해당하는 한일정당 하루에 배정되는 시간
                                double pctime = dur_ex / ( count ); //기본 설정 = 평균값
                           
                                if(dur <= min_time)//오늘 남은 수행 가능한 시간이 min_time보다 작으면 다음 날짜로
                                      continue;
                                
                                if(pctime < mid_time){//하루 수행시간이 mid_time보다 작을 때 전체 수행 시간도 mid_time보다 작은지 확인
                                   if(dur_ex <= mid_time)
                                      pctime = dur_ex;
                                   else if(pctime < min_time)//전체 수행 시간은 mid_time보다 크지만 pctime이 min_time보다 작으면 mid_time으로 설정
                                       pctime = mid_time;
                                }
                           
                                if(pctime >= max_time)//하루 수행시간이 max_time보다 클 때, max_time으로 설정
                                   pctime = max_time;
                           
                                if(dur_ex-pctime < min_time){//pctime 설정 후, 남은 시간이 min_time 보다 작을 때
                                  if(dur_ex <= max_time)//남은 시간 자체가 max_time보다 작을 때 남은 시간 전부 수행
                                     pctime = dur_ex;
                                  else//그렇지 않으면 반으로 나눠서 적절하게 수행하도록(dur_ex-pctime<min_time이면 반으로 나누면 충분함)
                                     pctime = dur_ex/2.0;
                               }
                                  
                               if(pctime >= dur){//남은 하루 수행 시간보다 일정 수행시간이 큰 경우 dur만큼 수행
                                  pctime = dur;
                               }
                                
                                //설정한 pctime으로 schedule_per_day에 insert
                                try{
                                   UserDAO userDAO4 = new UserDAO();
                                   int tmpt = r2.getInt("num_schedule");
                                   String dt = cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH)+1) + "-" + cal.get(Calendar.DAY_OF_MONTH);
                                   dt = dt + " 01:01:01";
                                   userDAO4.pstmt = userDAO4.conn.prepareStatement("INSERT INTO schedule_per_day(per_num_schedule, userid, num_schedule, per_extime, execute_day) VALUE (0,  ?, ?, ?, ?)");
                                   userDAO4.pstmt.setString(1, id);
                                   userDAO4.pstmt.setInt(2, tmpt);
                                   userDAO4.pstmt.setDouble(3, pctime);
                                   userDAO4.pstmt.setString(4, dt);
                                   dur_ex -= pctime;//deadline일때 overtime 업데이트를 위해 해당 일정 남은 수행시간 삭감
                                   dur -= pctime;//하루 남은 수행시간 비교를 위해 하루 남은 수행시간 삭감
                                   userDAO4.pstmt.executeUpdate();
                                } catch(Exception e){
                                   System.out.println("\n--------에러 in 334---------\n");
                                   e.printStackTrace();
                                }
                                
                                //schedule 테이블 업데이트
                                try{
                                   UserDAO userDAO9 = new UserDAO();
                                   double tmpt = r2.getDouble("dur_time");
                                   int scheid = r2.getInt("num_schedule");
                                   userDAO9.pstmt = userDAO9.conn.prepareStatement("UPDATE schedule SET schedule.dur_time = ? WHERE schedule.userid = ? AND schedule.num_schedule = ?");
                                   userDAO9.pstmt.setDouble(1, tmpt-pctime);
                                   userDAO9.pstmt.setString(2, id);
                                   userDAO9.pstmt.setInt(3, scheid);
                                   userDAO9.pstmt.executeUpdate();
                                } catch(Exception e){
                                   System.out.println("\n--------에러 in 349---------\n");
                                   e.printStackTrace();
                                }
                                
                                if( today.compareTo(dead) == 0 ){//insert 후 오늘이 deadline인데 아직 전부 배치가 안되었을때
                                   try{
                                      UserDAO userDAO5 = new UserDAO();
                                      int tmpt = r2.getInt("num_schedule");
                                      userDAO5.pstmt = userDAO5.conn.prepareStatement("UPDATE schedule SET schedule.overtime = ? , schedule.dur_time = 0 WHERE schedule.userid = ? AND schedule.num_schedule = ?");
                                      userDAO5.pstmt.setDouble(1, dur_ex);
                                      userDAO5.pstmt.setString(2, id);
                                      userDAO5.pstmt.setInt(3, tmpt);
                                      userDAO5.pstmt.executeUpdate();
                                   } catch(Exception e){
                                      System.out.println("\n--------에러 in 364---------\n");
                                      e.printStackTrace();
                                   }
                           
                                }
                             }
                             
                             //일반 일정 알고리즘
                             while(r3.next())
                             {
                                double ext = r3.getDouble("ex_time");
                                double dur_ex = r3.getDouble("dur_time");
                                 Date de_ad = r3.getDate("deadline");
                                String deadString = sdf.format(de_ad);
                                Date d = sdf.parse(deadString);
                                Calendar dead = Calendar.getInstance( );
                                dead.setTime (d);
                              
                                
                                if(dur_ex == 0) 
                                   continue; 
                              
                                double count = 0;
                                while( !today.after(dead)){
                                   count++;
                                   today.add( cal.DATE, 1 );
                                  }
                                
                                if(count == 0){
                                   if(dur_ex != 0){
                                      try{
                                         UserDAO userDAO7 = new UserDAO();
                                         int tmpt = r3.getInt("num_schedule");
                                         userDAO7.pstmt = userDAO7.conn.prepareStatement("UPDATE schedule SET schedule.overtime = ?, schedule.dur_time = 0 WHERE schedule.userid = ? AND schedule.num_schedule = ?;");
                                         userDAO7.pstmt.setDouble(1, dur_ex);
                                         userDAO7.pstmt.setString(2, id);
                                         userDAO7.pstmt.setInt(3, tmpt);
                                         userDAO7.pstmt.executeUpdate();
                                      } catch(Exception e){
                                         System.out.println("\n--------에러 in 403---------\n");
                                         e.printStackTrace();
                                      }
                                   }
                                   continue;
                                }
                                
                                today.setTime(cal.getTime());
                                
                                
                                double pctime = dur_ex / ( count );
                                 
                                if(dur <= min_time)
                                      continue;
                                
                                if(pctime < mid_time){
                                   if(dur_ex <= mid_time)
                                      pctime = dur_ex;
                                   else if(pctime < min_time)
                                      pctime = mid_time;
                                }
                           
                                if(pctime >= max_time)
                                   pctime = max_time;
                                
                                if(dur_ex-pctime < min_time){
                                  if(dur_ex <= max_time)
                                     pctime = dur_ex;
                                  else
                                     pctime = dur_ex/2.0;
                               }
                                  
                               if(pctime >= dur){
                                  pctime = dur;
                               }
                                
                              
                                try{
                                   UserDAO userDAO6 = new UserDAO();
                                    int tmpt = r3.getInt("num_schedule");
                                    String dt = cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH)+1) + "-" + cal.get(Calendar.DAY_OF_MONTH);
                                   //dt = dt +"01:01:01";//
                                    userDAO6.pstmt = userDAO6.conn.prepareStatement("INSERT INTO schedule_per_day(per_num_schedule, userid, num_schedule, per_extime, execute_day) VALUE (?,?, ?, ? , ?)");
                                   userDAO6.pstmt.setInt(1, 0);
                                   userDAO6.pstmt.setString(2, id);
                                   userDAO6.pstmt.setInt(3, tmpt);
                                   userDAO6.pstmt.setDouble(4, pctime);
                                   userDAO6.pstmt.setString(5, dt);
                                   dur_ex -= pctime;
                                   dur -= pctime;
                                   userDAO6.pstmt.executeUpdate();
                                } catch(Exception e){
                                   System.out.println("\n--------에러 in 458---------\n");
                                   e.printStackTrace();
                                }
                                   
                                
                                try{
                                   UserDAO userDAO10 = new UserDAO();
                                   double tmpt = r3.getDouble("dur_time");
                                   int scheid = r3.getInt("num_schedule");
                                   userDAO10.pstmt = userDAO10.conn.prepareStatement("UPDATE schedule SET schedule.dur_time = ? WHERE schedule.userid = ? AND schedule.num_schedule = ?");
                                   userDAO10.pstmt.setDouble(1, tmpt-pctime);
                                   userDAO10.pstmt.setString(2, id);
                                   userDAO10.pstmt.setInt(3, scheid);
                                   userDAO10.pstmt.executeUpdate();
                                } catch(Exception e){
                                   System.out.println("\n--------에러 in 473---------\n");
                                   e.printStackTrace();
                                }
                           
                          
                                if( today.compareTo(dead) == 0 ){
                                   try{
                                      UserDAO userDAO7 = new UserDAO();
                                      int tmpt = r3.getInt("num_schedule");
                                      userDAO7.pstmt = userDAO7.conn.prepareStatement("UPDATE schedule SET schedule.overtime = ?, schedule.dur_time = 0 WHERE schedule.userid = ? AND schedule.num_schedule = ?");
                                      userDAO7.pstmt.setDouble(1, dur_ex);
                                      userDAO7.pstmt.setString(2, id);
                                      userDAO7.pstmt.setInt(3, tmpt);
                                      userDAO7.pstmt.executeUpdate();
                                    } catch(Exception e){
                                      System.out.println("\n--------에러 in 489---------\n");
                                      e.printStackTrace();
                                   }
                                }
                             }              
                             
                             //종료 조건: dur이 0이 되거나, schedule 내의 모든 스케줄을 전부 돌았을 경우(급한 일정, 일반일정)
                             //while(true)문 내: 포인터를 가장 처음으로 돌리고 오늘을 나타내는 날짜++
                             //while(true)문 종료 확인: 해당 loop문 날짜(cal) 이후에 배정할 일정이 없음-> 모든 일정의 dur_ex가 0일때
                             
                             //다음 while(true)문 루프를 위한 세팅
                             r2.beforeFirst();//급한일정 다음 루프를 위해 포인터를 가장 처음으로
                             r3.beforeFirst();//일반일정 다음 루프를 위해 포인터를 가장 처음으로
                             
                             //일정 종료 확인을 위한 변수
                             boolean isOver = true;//초기값
                             
                             //급한 일정에 대해서 일정 종료 확인
                             while(r2.next()){
                                double dur_ex = r2.getDouble("dur_time");
                                Date de_ad = r2.getDate("deadline");
                                
                                String deadString = sdf.format(de_ad);
                                Date d = sdf.parse(deadString);
                                Calendar dead = Calendar.getInstance( );
                                dead.setTime ( d );
                                
                                //한 일정이라도 안끝났으면 계속
                                if(dur_ex != 0 && dead.compareTo(cal) >= 0)//deadline이 안지났고 아직 수행할 일정시간이 남았음
                                {
                                   isOver = false;
                                   break;
                                }
                             }
                             //급한 일정 확인한 후 아직 수행할 일정이 남아있으면 while(true)문 계속 돌음
                             if(isOver == false){
                                cal.add ( cal.DATE, +1);
                                continue;
                             }
                             
                             //일반 일정에 대해서 일정 종료 확인
                             while(r3.next()){
                                double dur_ex = r3.getDouble("dur_time");
                                Date de_ad = r3.getDate("deadline");
                                
                                String deadString = sdf.format(de_ad);
                                Date d = sdf.parse(deadString);
                                Calendar dead = Calendar.getInstance( );
                                dead.setTime ( d );
                                
                                //한 일정이라도 안끝났으면 계속
                                if(dur_ex != 0 && dead.compareTo(cal) >= 0)
                                {   
                                   isOver = false;
                                   break;
                                }
                             }
                             //일반 일정 확인한 후 아직 수행할 일정이 남아있으면 while(true)문 계속 돌음
                             if(isOver == true)
                                break;
                             
                             cal.add ( cal.DATE, +1);//기준 일자 하루 추가
                                
                          }
                
                         }
         %>
   </body>
   </html>