<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import = "user.UserDAO"  %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "user.Schedule" %>
<%@ page import="java.util.*" %>
<meta name = "viewport" content = "width-device=width", initial-scale = "1">
<%
Calendar cal = Calendar.getInstance();
String strYear = request.getParameter("year");
String strMonth = request.getParameter("month");
String strDate = request.getParameter("date");

int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH);
int date = cal.get(Calendar.DATE);

if(strYear != null)
{
  year = Integer.parseInt(strYear);
  month = Integer.parseInt(strMonth);
  date = Integer.parseInt(strDate);
}else{
}

%>

<html lang="ko">

<HEAD>

       <TITLE>캘린더</TITLE>

       <meta http-equiv="content-type" content="text/html; charset=utf-8">

<style>

     @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Serif+KR:wght@200&display=swap');
     
     *{
     font-family: 'Noto Serif KR', serif;
     }
            
            body{     
              padding-top:30px;
              width: 80%;             
              margin: 0 auto;
            }
         
           
           
            #todolist{
                border-style: solid;          
                border-radius: 20px;                     
                border-color: gainsboro;
                overflow-x:hidden;
                height: 700px;          
            }
            #content{
                font-size: 25;
                text-align: center;
                margin-top: 5;
            }
                    
            #tdl{          
                width: 30%;  
                display : block;
                margin : auto;
            }
            
            .Allschedule{
                 padding: 10px;
                 padding-left: 50px;
                 font-size: 24;
                 display:inline-block;
                
            }
            
             .Allschedule2{           
                 padding-left: 7%;
                 font-size: 20;
                 
                 
            }
            
            a{
               text-decoration:none;
               
            }
            
            #a1{
               margin-left: 5%;
            }
     
         
    </style>    
</HEAD>

<BODY>

<div  id="todolist"'>              
    <img id="tdl" src ="image\tdl.png">
               
               <%--날짜 표시 --%>              
<form name="calendarFrm" id="calendarFrm" action="" method="post">
<DIV id="content">
                  
                  
                    <a href="<c:url value='/daily.jsp' />?year=<%=year+1%>&amp;month=<%=month%>&amp;date=<%=date%>" target="_self">
                           <!-- 다음해 --> <img src = "image\up.png" style="width:25; heigth: 25 ">
                    </a>     
                    
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     
                     <%if(month < 11 ){ %>
                    <a href="<c:url value='/daily.jsp' />?year=<%=year%>&amp;month=<%=month+1%>&amp;date=<%=date%>" target="_self">
                           <!-- 다음달 --> <img src = "image\up.png" style="width:25; heigth: 25">

                    </a>
                    <%}else{%>                                   
                            <img src = "image\up.png" style="width:25; heigth: 25">
                    <%} %>
                    
                     &nbsp;&nbsp;
                    <% int[] dateM = {31,29,31,30,31,30,31,31,30,31,30,31};                 
                    %>
                    <%if(date < dateM[month] ){ %>
                    <a href="<c:url value='/daily.jsp' />?year=<%=year%>&amp;month=<%=month%>&amp;date=<%=date+1%>" target="_self">
                          <!-- 다음달 --> <img src = "image\up.png" style="width:25; heigth: 25">
                    </a>
                    <%}else{%>
                           <img src = "image\up.png" style="width:25; heigth: 25">
                    <%} %>               

                   
                    <br>

                    &nbsp;&nbsp;

                    <%=year%>년

                    <%=month+1%>월
                    
                    <%=date%>일

                    &nbsp;&nbsp;
                    
                    
                     <br>
                     <a href="<c:url value='/daily.jsp' />?year=<%=year-1%>&amp;month=<%=month%>&amp;date=<%=date%>" target="_self">
                           <img src = "image\down.png" style="width:25; heigth: 25"><!-- 이전해 -->
                    </a>

 					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

                    <%if(month > 0 ){ %>

                    <a href="<c:url value='/daily.jsp' />?year=<%=year%>&amp;month=<%=month-1%>&amp;date=<%=date%>" target="_self">
                            <img src = "image\down.png" style="width:25; heigth: 25"><!-- 이전달 -->
                    </a>

                    <%} else {%>
                            <img src = "image\down.png" style="width:25; heigth: 25">
                    <%} %>
                    
                    
                     &nbsp;&nbsp;
                    
                     <%if(date > 1 ){ %>

                    <a href="<c:url value='/daily.jsp' />?year=<%=year%>&amp;month=<%=month%>&amp;date=<%=date-1%>" target="_self">
                            <img src = "image\down.png" style="width:25; heigth: 25"><!-- 이전날 -->
                    </a>

                    <%} else {%>
                            <img src = "image\down.png" style="width:25; heigth: 25">
                    <%} %>
                    
                     
<br>
</DIV>
</form>

<%
   String id = (String)session.getAttribute("id");   
   String findDate = year+"-"+(month+1)+"-"+date;
   UserDAO userDAO = new UserDAO();
   ArrayList<Schedule> todolist = userDAO.findToDoList(findDate,id);
   
   int size = todolist.size();
   int a = 0;
   ArrayList<String> memo = new ArrayList<String>();
   ArrayList<String> deadline = new ArrayList<String>();
   
   out.println("<DIV>"); 
   for(int i = 0; i< size; i++){
	   
	   double ex_time = todolist.get(i).getEx_time();
	   int hour =  (int)ex_time;
	   int minute = (int)Math.round((ex_time * 10)%10 * 6);
	   
	   
	   if (minute == 0){
		  out.println("<DIV style='width:auto;'>"+
	               "<DIV  class = 'Allschedule' id='schedule"+i+"''>" + "•  "+todolist.get(i).getName_schedule()+" / "+hour+"시간"+"</DIV>"
	               +"</DIV>");
	   }
	   else{
	   out.println("<DIV style='width:auto;'>"+
	               "<DIV  class = 'Allschedule' id='schedule"+i+"''>" + "•  "+todolist.get(i).getName_schedule()+" / "+hour+"시간 "+minute+"분"+"</DIV>"
	               +"</DIV>");
	   }
	   out.println("<DIV class = 'Allschedule2' id= 'dd"+i+"'>");
	   out.println(todolist.get(i).getDeadline()+"<br>"+todolist.get(i).getMemo()+"<br>");
	   if(todolist.get(i).getOvertime()>0)
	   out.println(todolist.get(i).getOvertime()+"시간 부족!");
	   out.println("</DIV>");
	   
   }
   out.println("</DIV>");
  int k = 0;
%>


<script type="text/javascript">  

for(i = 0; i< <%=size%>;i++){
	document.getElementById("dd"+ i).style.display ='none';

	 (function (m){ 
	     document.getElementById("schedule"+m).addEventListener('click', function () {
	    	if(document.getElementById("dd"+ m).style.display == 'none')
	           document.getElementById("dd"+ m).style.display ='block';
	    	else{
	    		 document.getElementById("dd"+ m).style.display ='none';
	    	}
		});
	 })(i); 
}

</script>

</div>
</BODY>
</HTML>