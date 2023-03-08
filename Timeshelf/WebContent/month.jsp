<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import = "user.UserDAO"  %>
<%@ page import = "user.Schedule"  %>
<%@ page import = "java.util.ArrayList" %>

<%
Calendar cal = Calendar.getInstance();
String strYear = request.getParameter("year");
String strMonth = request.getParameter("month");

int year = cal.get(Calendar.YEAR);
int month = cal.get(Calendar.MONTH);
int date = cal.get(Calendar.DATE);

String id = (String)session.getAttribute("id");

if(strYear != null)

{
  year = Integer.parseInt(strYear);
  month = Integer.parseInt(strMonth);
}else{
}

//년도/월 셋팅

cal.set(year, month, 1);

int startDay = cal.getMinimum(java.util.Calendar.DATE);
int endDay = cal.getActualMaximum(java.util.Calendar.DAY_OF_MONTH);
int start = cal.get(java.util.Calendar.DAY_OF_WEEK);
int newLine = 0;

 
//오늘 날짜 저장.

Calendar todayCal = Calendar.getInstance();

SimpleDateFormat sdf = new SimpleDateFormat("yyyMMdd");

int intToday = Integer.parseInt(sdf.format(todayCal.getTime()));

%>

<html lang="ko">

<HEAD>

       <TITLE>캘린더</TITLE>

       <meta http-equiv="content-type" content="text/html; charset=utf-8">

       <script type="text/javaScript" language="javascript"> 
       </script>

       <style TYPE="text/css">

             body {
             scrollbar-face-color: darkgray;
             scrollbar-highlight-color: darkgray;
             scrollbar-3dlight-color: #FFFFFF;
             scrollbar-shadow-color: darkgray;
             scrollbar-darkshadow-color: darkgray;
             scrollbar-track-color: #FFFFFF;
             scrollbar-arrow-color: darkgray;
             width: 1000px;  
             margin: 0 auto;
             }

             tr {margin:0px auto; border-style:solid;}
             td {font-family: "돋움"; font-size: 14pt; color:#000000; background-color:#FFFFFF;}
             th {font-family: "돋움"; font-size: 9pt; color:#000000;}
             select {font-family: "돋움"; font-size: 9pt; color:#595959;}
             #userdiv{background-color:rgba(102,153,255,0.2); width:118px;border-radius: 5px;margin-bottom:-12px;}
             #user{font-size: 13pt;}
          #num_schedule{display:none;}
             .divDotText {

             overflow:hidden;
             text-overflow:ellipsis;

             }
             #year_month{ display: inline-block; margin-top:0px;}
             .div{
                text-align: center;
                width:100px;
                border-style: solid;
                border-color: darkgray;
                border-radius: 20px;
                margin-bottom: 10px;
                 
                padding: 10px;
                display: inline-block;
            }

           .divscroll{
            overflow:auto;         
            padding: 5px;
            width:130px;
            height:140px;
            font-size:15px;
         }
           .divscroll::-webkit-scrollbar {
             width: 1px;
              
           }
           .divscroll::-webkit-scrollbar-thumb {
             background-color: white;
             border-radius: 10px;
           }
          .divscroll::-webkit-scrollbar-track {
             background-color: white;
               border-radius: 10px;
             box-shadow: inset 0px 0px 5px white;
           }

            A:link { font-size:9pt; font-family:"돋움";color:#000000; text-decoration:none; }
            A:visited { font-size:9pt; font-family:"돋움";color:#000000; text-decoration:none; }
            A:active { font-size:9pt; font-family:"돋움";color:#000000; text-decoration:none; }
            A:hover { font-size:9pt; font-family:"돋움";color:#000000;text-decoration:none;font-weight: bold;}

       </style>

</HEAD>

<BODY>

<form name="calendarFrm" id="calendarFrm" action="" method="post">

<DIV id="content" style="width:712px;">

<!--날짜 네비게이션  -->

<table width="1000" border="0" cellspacing="1" cellpadding="1" id="KOO" bgcolor="WHITE" style="border:1px solid WHITE">

<tr>

<td height="60">
       <table width="1000" border="0" cellspacing="0" cellpadding="0">

       <tr>
             <td height="10">
             </td>
       </tr>
       
      <!--  button -->
       <tr>
             <td align="center" >
                    <a href="<c:url value='/month.jsp' />?year=<%=year-1%>&amp;month=<%=month%>" target="_self">
                           <b>&lt;&lt;</b><!-- 이전해 --><!-- button을 클릭하면 year,month 정보를 넘기며 같은 페이지로 넘어간다. -->
                    </a>

                    <%if(month > 0 ){ %>
                    <a href="<c:url value='/month.jsp' />?year=<%=year%>&amp;month=<%=month-1%>" target="_self">
                           <b>&lt;</b><!-- 이전달 -->
                    </a>

                    <%} else {%>
                           <b>&lt;</b>
                    <%} %>

                    &nbsp;&nbsp;
               <div id='year_month'>
                    <%=year%>년

                    <%=month+1%>월</div>

                    &nbsp;&nbsp;

                    <%if(month < 11 ){ %>

                    <a href="<c:url value='/month.jsp' />?year=<%=year%>&amp;month=<%=month+1%>" target="_self">

                           <!-- 다음달 --><b>&gt;</b>

                    </a>

                    <%}else{%>

                           <b>&gt;</b>

                    <%} %>

                    <a href="<c:url value='/month.jsp' />?year=<%=year+1%>&amp;month=<%=month%>" target="_self">
                           <!-- 다음해 --><b>&gt;&gt;</b>
                    </a>

             </td>
       </tr>

       </table>

</td>
</tr>
</table>

<br>

<table width="1000"  border="0" cellspacing="1" cellpadding="1" bgcolor="#FFFFFF">

<THEAD>
<TR bgcolor="#CECECE">
       <TD>
       <DIV align="center" class="div"><font color="red">일</font></DIV>
       </TD>

       <TD width='100px'>
       <DIV align="center" class="div">월</DIV>
       </TD>

       <TD width='100px'>
       <DIV align="center" class="div">화</DIV>
       </TD>

       <TD width='100px'>
       <DIV align="center" class="div">수</DIV>
       </TD>

       <TD width='100px'>
       <DIV align="center" class="div">목</DIV>
       </TD>

       <TD width='100px'>
       <DIV align="center" class="div">금</DIV>
       </TD>

       <TD width='100px'>
       <DIV align="center" class="div"><font color="#529dbc">토</font></DIV>
       </TD>
</TR>
</THEAD>
<TBODY>
<TR>

<%

//처음 빈공란 표시

for(int index = 1; index < start ; index++ )
{
  out.println("<TD >&nbsp;</TD>");
  newLine++;
}

 
for(int index = 1; index <= endDay; index++) 
{
       String color = "";

       if(newLine == 0){          color = "RED";
       }else if(newLine == 6){    color = "#529dbc";
       }else{                     color = "BLACK"; };

 

       String sUse =  Integer.toString(year);
       String sUseDate = Integer.toString(year);
       
       sUse+="-";

       sUseDate += Integer.toString(month+1).length() == 1 ? "0" + Integer.toString(month+1) : Integer.toString(month+1);
       
       sUse += Integer.toString(month+1).length() == 1 ? "0" + Integer.toString(month+1) : Integer.toString(month+1);
       sUse += "-";

       sUseDate += Integer.toString(index).length() == 1 ? "0" + Integer.toString(index) : Integer.toString(index);

       sUse += Integer.toString(index).length() == 1 ? "0" + Integer.toString(index) : Integer.toString(index);
       

       int iUseDate = Integer.parseInt(sUseDate);


       String backColor = "WHITE";

       if(iUseDate == intToday ) {

            backColor = "rgba(204,204,204,0.2)";

       }

       out.println("<TD valign='top' align='left' height='150px' bgcolor='"+backColor+"' nowrap>");
     
       %>

       <font color='<%=color%>'>

             <%=index %>

       </font>
 

       <%
       out.println("<BR>");
       out.println("<DIV class='divscroll'>");
                 
       UserDAO userDAO = new UserDAO();
       ArrayList<Schedule> list = userDAO.findSchedule(sUse,id); 
       //findSchedule 함수를 이용해 특정 날짜 스케줄을 가져온다.
       for(int i = 0; i<list.size();i++){         
          // month.jsp에서 addschedule.jsp로 넘어갈 때 update 상태와 shcedule의 number를 넘겨준다.
          out.println("<a id='user' href='addschedule.jsp?update=update&num_schedule="
                       +list.get(i).getnum_schedule()+"'><div id='userdiv'>"
                       +list.get(i).getName_schedule()
                       +"</div></a><br>");
       
       } 
       
       out.println("<BR>");
       out.println("</DIV>");  
       out.println("</TD>");

       newLine++;

       if(newLine == 7)

       {

         out.println("</TR>");

         if(index <= endDay)

         {

           out.println("<TR>");

         }

         newLine=0;

       }

}

//마지막 공란 LOOP

while(newLine > 0 && newLine < 7)

{

  out.println("<TD>&nbsp;</TD>");

  newLine++;

}

%>

</TR>
</TBODY>
</TABLE>
</DIV>
</form>
</BODY>
</HTML>