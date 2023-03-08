<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@page import="user.UserDAO" %>
<%@ page import = "java.util.ArrayList" %>
<%@ page import = "user.Schedule" %>

    
<%
 Calendar cal = Calendar.getInstance();
 String strYear = request.getParameter("year");
 String strMonth = request.getParameter("month"); 

 
 int year = cal.get(Calendar.YEAR);
 int month = cal.get(Calendar.MONTH);
 int date = cal.get(Calendar.DATE);

 if(strYear != null)
 {
   year = Integer.parseInt(strYear);
   month = Integer.parseInt(strMonth);
 }else{
 }
 
 
 ArrayList<Schedule> arr;
 String name_schedule =  null;
 String deadline =  null;
 int importance = 0;
 Double ex_time =  0.0;
 String memo =  null;
 String ex=null;

 String ns = request.getParameter("num_schedule");
 String state = request.getParameter("update");
 
 //addschedule에서 update 와 insert 구분
 if(state != null){  //update 인 상태
	 UserDAO userDAO = new UserDAO();
	 arr = userDAO.findSchedule2(ns); 
	 name_schedule  = arr.get(0).getName_schedule();	 
	 deadline = arr.get(0).getDeadline();
	 importance = arr.get(0).getimprotance();	
	 ex_time = arr.get(0).getEx_time();
	 memo = arr.get(0).getMemo();	 
	 ex = Double.toString(ex_time);
	 
 }else{  //insert 상태
	 state = "insert";
 }
	 %>
 
<html>
    <head>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/i18n/jquery-ui-i18n.min.js"></script>
  
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/timepicker/1.3.5/jquery.timepicker.min.js"></script>


<script type="text/javascript">
    function CheckSelect(){
        var ctrlSelect = document.getElementById("lstFavorite");
        if( ctrlSelect.selectedIndex == 0){
            alert("관심사항을 선택하시오.");
            ctrlSelect.focus();
        }else{
            window.alert("당신의 관심사항 : " + ctrlSelect.value );
        }
    }
    
    function modi(a){     
       document.getElementById(a).style.visibility='visible'
    }
    
    function preferO(a){     
       document.getElementById(a).style.visibility='visible'
    }
    
    function preferX(a){
       document.getElementById(a).style.visibility='hidden'
    }
 </script> 
   <style>
   
           #addsch{
                border-style: solid;
                display: block;
                border-radius: 20px;
                width: 590;
                height: 560;
               
                border-color: gainsboro;
                 margin: 0px auto;
            }
            
            #todolist{
                border-style: solid;
                display: inline-block;
                border-radius: 20px;
                width: 300;
                height: 560;
                border-color: gainsboro;
            }
            .name{      
                display: inline-block;
                text-align: left;
                margin: 20 0 20 50;
                width: 200;
                font-size: 18; 
                
            }
            .buttonD{
                margin: auto;
                border-style: solid;
                padding: 7 20 7 20;
                border-radius: 3px;
                font-size: 15;
                font-weight: 600;
                width: 160;
                text-align: center;
                display: inline-block;
            }
            .input{
                padding : 6;
                display: inline-block;  
                border-radius: 5px;
                border-color: black;
                font-size: 16;
            }
            #main{
                width: 932;
                margin: auto;
            }
            #tdl{          
                font-size: 20;
                text-align: center;
                margin-top: 20;
            }
            #tdl2{
                padding: 20;
            }
           select {
            width: 120px;
            top: 1.5px;
			-webkit-appearance: none;
			-moz-appearance: none;
			appearance: none;
}

            select::-ms-expand{
                display:none;
            }
            
            .hide{
                 display:none; 
            }
            
            #add{
             text-align: center;
            
            }
    </style>    
  </head>
  <body>
     <br>
       <div id="main">
        <div id="addsch">
           <form name="myfrom" metod="post" action="addscheduleAction.jsp">
              <br>
                       
               <input class = "hide" type="text" name="ns" id="ns" value=<%=ns%>>
               <input class = "hide" type="text" name="state" value=<%=state%> id="state" > 
               <br>
                             
               <span class="name">일정 이름</span> <input type="text" class="input" name = "name" <%if(name_schedule != null){%>value="<%=name_schedule%>"<%} %> required><br>
              
               <span class="name">예정 날짜</span> <input type="text" class="input" id="deadline" name = "deadline"<%if(deadline != null){%>value=<%=deadline%><%} %> required><br>
                <script>
                 $(function() {
               	  $.datepicker.setDefaults($.datepicker.regional['ko']);
                     $("#deadline").datepicker();
                    });
                 
                </script>
               <span class="name">중요도</span> <input type="range" value="3" min="1" max="5" name = "importance" id="importance" required><br>
               <span class="name">예상시간</span> <input type="text" value="00:00" class="input" id="ex_time" name = "ex_time" id="ex_time" size=15><br>                         
          <script>   
            
             <%
             if(importance != 0){ %>
            	 document.getElementById("importance").value=<%=importance%>; 
            	 <% }
             %>
             
             <%if(ex_time != 0.0){
               double ex_time2 = ex_time;
          	   int hour =  (int)ex_time2;
          	   int minute = (int)Math.round((ex_time * 10)%10 * 6);
          	   
          	  String hour2 = String.format("%02d", hour);
          	 //System.out.print("Hour"+hour2);
          	 String minute2 = String.format("%02d", minute);
			 
             %>
             
            if(<%=hour%><10){
            	 document.getElementById("ex_time").value = "0"+<%=hour%>;
            	  }else{
            		  document.getElementById("ex_time").value = <%=hour%>;
            }
             
             if(<%=minute%><10){
            	 document.getElementById("ex_time").value += ":0"+<%=minute%>;
            	  }else{
            		  document.getElementById("ex_time").value +=":"+<%=minute%>;
            }
          
          
             <%} %> 
               
               $(document).ready(function(){
            	    $("#hour").change(function(){
            	    	if($("#hour option:selected").val()=="NO") 
            	    		$('#min').attr('disabled',true);
            	    	else
            	    		$("#min").attr("disabled",false);

            	    });
            	});
               
              function MyFunction(){
            	  $("#hour option:eq(0)").attr("disabled", "disabled").hide();
 
              }
                  
              function MyFunction2(){
            	  $("#hour option:eq(0)").removeAttr("disabled").show();
              }
              
              /*  $(function() {
                $('#ex_time').timepicker({
            	    timeFormat: 'HH:mm',
            	    interval: 10,
            	    minTime: '0',
            	    maxTime: '23:59pm',
            	    defaultTime: '8',
            	    startTime: '0:00',
            	    dynamic: false,
            	    dropdown: true,
            	    scrollbar: true
            	});      
               }); */
               
            
                $(function() {
                      $("#ex_time2").timepicker({
    	                 timeFormat: 'HH:mm',
    	      			 interval: 30,
    	   				 minTime: '0',
    	   				 maxTime: '23:00pm',
    	   				 defaultTime: '8',
    	   				 startTime: '0:00',
    	   				 dynamic: false,
    	   				 dropdown: true,
    	    			 scrollbar: true  
   				  });
			   });       
               
                
                function del(){               
                    document.location.href="deleteAction.jsp?del="+<%=ns%>;
                }   
                             
			  </script>
               <span class="name">메모</span> <input type="text" class="input"  name = "memo" size="34" <%if(memo != null){%>value="<%=memo%>"<%} %>><br><br><br>
               
                <!--  update or insert 상태에 따라 버튼이 다르게 나타난다. -->
               <div id="add">
              <input class="buttonD" type="submit" <%if(importance != 0){%>value=<%="수정"%><%}else{%>value="일정추가"<%}%> > 
               <%if(state.equals("update")){%> <button type="button" id="buttonDel" class="buttonD" onclick="del()">삭제</button><%} %>     
               </div>
           </form>             
        </div>                
      </div>               
    </body>
</html>