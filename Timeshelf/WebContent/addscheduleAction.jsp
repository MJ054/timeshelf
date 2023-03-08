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
<title>JSP �Խ��� �� ����Ʈ</title>
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
                     if(state.equals("insert")){  //insert ����
                          result = userDAOa.InSchedule(request.getParameter("name"), request.getParameter("deadline"), importance, ex_time, memo, id);                       
                          }
                       else if(state.equals("update")){  //update ����                                 
                              int num_schedule = Integer.parseInt(request.getParameter("ns"));  
                              result = userDAOa.modifyschedule(id, name_schedule, deadline, importance, ex_time, memo, num_schedule);
                                                
                        }                     
                  }else{  //delete ����
                     result = 0;
                  }
       
                       if(result == -1){   //����
                          PrintWriter script = response.getWriter();
                          script.println("<script>");
                          script.println("alert('����')");
                          script.println("history.back()");
                          script.println("</script>");
                       }  
                       else{  //����
                          PrintWriter script = response.getWriter();
                          script.println("<script>");
                          if(del!=null){
                             script.println("alert('���� �Ϸ�')");
                             script.println("location.href = 'month.jsp'");
                          }
                          else if(state.equals("insert")){
                             script.println("alert('�߰� ����')");
                             script.println("location.href = 'addschedule.jsp'");
                          }
                          else{
                             script.println("alert('���� �Ϸ�')");
                             script.println("location.href = 'month.jsp'");
                          }                     
                           script.println("</script>");
               
                           
                           
                           
                           /* --����-- */
                           ResultSet r1, r2, r3; //r1 ����������, r2 ���� ����, r3 �Ϲ�����
                          r1 = null;
                          r2 = null;
                          r3 = null;
                          UserDAO userDAO = new UserDAO();
                          UserDAO userDAO2 = new UserDAO();
                          UserDAO userDAO3 = new UserDAO();
                          double max_time = 0; //���� �ϳ� �ּ� ���� �ð�
                          double min_time = 0; //���� �ϳ� �ִ� ���� �ð�
                          double start = 0; //���� ���� �ð�
                          double end = 0; //���� ���� �ð�
                          double mid_time = 0;
                          double duration; //�Ϸ� ���డ���� �����ð�

                          SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                          Date to_day = new Date(); //���� ��¥.
                          String dateString = sdf.format(to_day);
                          Date t = sdf.parse(dateString);
                          Calendar today= Calendar.getInstance(); //deadline���� ���� ��¥ ����
                          today.setTime(t);
                          Calendar cal = Calendar.getInstance(); // while�� ���� ���� ��¥ ����
                          
                          
                          
                          //schedule_per_day ���̺� ���ڵ� ���� ����, schedule ���̺� dur_time, overtime �ʱ�ȭ
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
                             System.out.println("\n--------���� in 210---------\n");
                              e.printStackTrace();
                          } 
                       
                          //mypage ���� ���� ��� �˰��� ���� ����
                          mid_time = (min_time+max_time)/2;
                          
                          if(end > start)
                             duration = end - start;
                          else
                             duration = end+24 -start; // ���� ������ ������ end�� �� ���
                           
                             
                          /* --�˰���-- */
                          while(true){
                             String dt2 = cal.get(Calendar.YEAR) + "-" + (cal.get(Calendar.MONTH)+1) + "-" + cal.get(Calendar.DAY_OF_MONTH);
                             dt2 = dt2 + " 01:01:01";
                             
                             //���� ���� r2 ��������
                             userDAO2.pstmt = userDAO2.conn.prepareStatement("SELECT num_schedule, deadline, ex_time, dur_time FROM schedule WHERE schedule.userid = ? AND schedule.importance >=4 AND datediff( schedule.deadline, ? ) >=0 AND datediff( schedule.deadline, ? ) <= 2 ORDER BY importance DESC;", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                               userDAO2.pstmt.setString(1, id);
                                userDAO2.pstmt.setString(2, dt2);
                                userDAO2.pstmt.setString(3, dt2);
                               r2 = userDAO2.pstmt.executeQuery();
                               
                               //�Ϲ� ���� r3 ��������
                               userDAO3.pstmt = userDAO3.conn.prepareStatement("SELECT num_schedule, deadline, ex_time, dur_time FROM schedule WHERE schedule.userid = ? AND num_schedule NOT IN (SELECT num_schedule FROM schedule WHERE schedule.userid = ? AND schedule.importance >=4 AND datediff( schedule.deadline, ? ) >=0 AND datediff( schedule.deadline, ? ) <= 2) ORDER BY importance DESC;", ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                               userDAO3.pstmt.setString(1, id);
                                userDAO3.pstmt.setString(2, id);
                                userDAO3.pstmt.setString(3, dt2);
                                userDAO3.pstmt.setString(4, dt2);
                               r3 = userDAO3.pstmt.executeQuery();
                           
                             double dur = duration; //duration���� while�� ���� �ʱ�ȭ �ؾ��ϹǷ� duration�� ���� �ٲ�� �ȵ�.
                          
                             //���� ���� �˰���
                             while(r2.next()){
                                //�� ������ ���ؼ� extime, durtime, deadline ��������
                                double ext = r2.getDouble("ex_time"); //���� ��ü ���� �ð�: �Ϸ� �� ���� ���� �ð� ���� ��
                                double dur_ex = r2.getDouble("dur_time");//���� ��ġ���� ���� ���� �ð� Ȯ�ο�
                                Date de_ad = r2.getDate("deadline"); // cal���� ����� ���� deadline�� Ķ������! 
                                String deadString = sdf.format(de_ad);
                                Date d = sdf.parse(deadString);
                                Calendar dead = Calendar.getInstance( );
                                dead.setTime ( d );
                           
                                //�ش� ������ �̹� ��ġ �Ϸ�� ��� ���� ��������
                                if(dur_ex == 0)
                                   continue; 
                           
                                double count = 0; //�Ʒ� while�� ���鼭 �ϼ� ���� ����
                                while( !today.after(dead)){
                                   count++;
                                   today.add( cal.DATE, 1 );
                                   
                                 }
                                
                                if(count == 0){//deadline�� �����µ� ���� ���� �ȵ� �ð��� �ִ� ��� = �ð��� ���ڶ�� ��� -> overtime ������Ʈ
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
                                         System.out.println("\n--------���� in 277---------\n");
                                         e.printStackTrace();
                                      }
                                   }
                                   continue;//�̿� �ش�Ǵ� �ٸ� ������ �ִ��� Ȯ���ؾ� �ϹǷ�
                                }
                                
                                today.setTime(cal.getTime()); // ���� ���� deadline������ �ϼ� ����� ���� today �ʱ�ȭ.
                                
                                
                                /* --pctime ����-- */
                                //pctime�� �ش��ϴ� �������� �Ϸ翡 �����Ǵ� �ð�
                                double pctime = dur_ex / ( count ); //�⺻ ���� = ��հ�
                           
                                if(dur <= min_time)//���� ���� ���� ������ �ð��� min_time���� ������ ���� ��¥��
                                      continue;
                                
                                if(pctime < mid_time){//�Ϸ� ����ð��� mid_time���� ���� �� ��ü ���� �ð��� mid_time���� ������ Ȯ��
                                   if(dur_ex <= mid_time)
                                      pctime = dur_ex;
                                   else if(pctime < min_time)//��ü ���� �ð��� mid_time���� ũ���� pctime�� min_time���� ������ mid_time���� ����
                                       pctime = mid_time;
                                }
                           
                                if(pctime >= max_time)//�Ϸ� ����ð��� max_time���� Ŭ ��, max_time���� ����
                                   pctime = max_time;
                           
                                if(dur_ex-pctime < min_time){//pctime ���� ��, ���� �ð��� min_time ���� ���� ��
                                  if(dur_ex <= max_time)//���� �ð� ��ü�� max_time���� ���� �� ���� �ð� ���� ����
                                     pctime = dur_ex;
                                  else//�׷��� ������ ������ ������ �����ϰ� �����ϵ���(dur_ex-pctime<min_time�̸� ������ ������ �����)
                                     pctime = dur_ex/2.0;
                               }
                                  
                               if(pctime >= dur){//���� �Ϸ� ���� �ð����� ���� ����ð��� ū ��� dur��ŭ ����
                                  pctime = dur;
                               }
                                
                                //������ pctime���� schedule_per_day�� insert
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
                                   dur_ex -= pctime;//deadline�϶� overtime ������Ʈ�� ���� �ش� ���� ���� ����ð� �谨
                                   dur -= pctime;//�Ϸ� ���� ����ð� �񱳸� ���� �Ϸ� ���� ����ð� �谨
                                   userDAO4.pstmt.executeUpdate();
                                } catch(Exception e){
                                   System.out.println("\n--------���� in 334---------\n");
                                   e.printStackTrace();
                                }
                                
                                //schedule ���̺� ������Ʈ
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
                                   System.out.println("\n--------���� in 349---------\n");
                                   e.printStackTrace();
                                }
                                
                                if( today.compareTo(dead) == 0 ){//insert �� ������ deadline�ε� ���� ���� ��ġ�� �ȵǾ�����
                                   try{
                                      UserDAO userDAO5 = new UserDAO();
                                      int tmpt = r2.getInt("num_schedule");
                                      userDAO5.pstmt = userDAO5.conn.prepareStatement("UPDATE schedule SET schedule.overtime = ? , schedule.dur_time = 0 WHERE schedule.userid = ? AND schedule.num_schedule = ?");
                                      userDAO5.pstmt.setDouble(1, dur_ex);
                                      userDAO5.pstmt.setString(2, id);
                                      userDAO5.pstmt.setInt(3, tmpt);
                                      userDAO5.pstmt.executeUpdate();
                                   } catch(Exception e){
                                      System.out.println("\n--------���� in 364---------\n");
                                      e.printStackTrace();
                                   }
                           
                                }
                             }
                             
                             //�Ϲ� ���� �˰���
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
                                         System.out.println("\n--------���� in 403---------\n");
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
                                   System.out.println("\n--------���� in 458---------\n");
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
                                   System.out.println("\n--------���� in 473---------\n");
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
                                      System.out.println("\n--------���� in 489---------\n");
                                      e.printStackTrace();
                                   }
                                }
                             }              
                             
                             //���� ����: dur�� 0�� �ǰų�, schedule ���� ��� �������� ���� ������ ���(���� ����, �Ϲ�����)
                             //while(true)�� ��: �����͸� ���� ó������ ������ ������ ��Ÿ���� ��¥++
                             //while(true)�� ���� Ȯ��: �ش� loop�� ��¥(cal) ���Ŀ� ������ ������ ����-> ��� ������ dur_ex�� 0�϶�
                             
                             //���� while(true)�� ������ ���� ����
                             r2.beforeFirst();//�������� ���� ������ ���� �����͸� ���� ó������
                             r3.beforeFirst();//�Ϲ����� ���� ������ ���� �����͸� ���� ó������
                             
                             //���� ���� Ȯ���� ���� ����
                             boolean isOver = true;//�ʱⰪ
                             
                             //���� ������ ���ؼ� ���� ���� Ȯ��
                             while(r2.next()){
                                double dur_ex = r2.getDouble("dur_time");
                                Date de_ad = r2.getDate("deadline");
                                
                                String deadString = sdf.format(de_ad);
                                Date d = sdf.parse(deadString);
                                Calendar dead = Calendar.getInstance( );
                                dead.setTime ( d );
                                
                                //�� �����̶� �ȳ������� ���
                                if(dur_ex != 0 && dead.compareTo(cal) >= 0)//deadline�� �������� ���� ������ �����ð��� ������
                                {
                                   isOver = false;
                                   break;
                                }
                             }
                             //���� ���� Ȯ���� �� ���� ������ ������ ���������� while(true)�� ��� ����
                             if(isOver == false){
                                cal.add ( cal.DATE, +1);
                                continue;
                             }
                             
                             //�Ϲ� ������ ���ؼ� ���� ���� Ȯ��
                             while(r3.next()){
                                double dur_ex = r3.getDouble("dur_time");
                                Date de_ad = r3.getDate("deadline");
                                
                                String deadString = sdf.format(de_ad);
                                Date d = sdf.parse(deadString);
                                Calendar dead = Calendar.getInstance( );
                                dead.setTime ( d );
                                
                                //�� �����̶� �ȳ������� ���
                                if(dur_ex != 0 && dead.compareTo(cal) >= 0)
                                {   
                                   isOver = false;
                                   break;
                                }
                             }
                             //�Ϲ� ���� Ȯ���� �� ���� ������ ������ ���������� while(true)�� ��� ����
                             if(isOver == true)
                                break;
                             
                             cal.add ( cal.DATE, +1);//���� ���� �Ϸ� �߰�
                                
                          }
                
                         }
         %>
   </body>
   </html>