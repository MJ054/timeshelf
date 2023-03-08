<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
   <head>
   <meta charset="UTF-8">
   <%
   
   String id = (String)session.getAttribute("id");
  
%>
   
       <script>
         function day(){
             document.getElementById("mainframe").style.display='none'
             document.getElementById("mainiframe").style.display='block'
             document.getElementById("mainiframe").height='1070'
             
            location.href= "login.jsp"
            
         }
         function week(){
             document.getElementById("mainframe").style.display='none'
             document.getElementById("mainiframe").style.display='block'
             document.getElementById("mainiframe").height='650'
             
            	<%--  <%if(id != null){%> location.href= "week.jsp"<%}else {%> location.href= "login.jsp"<%} %>  --%>
            	
            	location.href= "login.jsp"
         }
         function month(){
             document.getElementById("mainframe").style.display='none'
             document.getElementById("mainiframe").style.display='block'
             document.getElementById("mainiframe").height='1050'
             
            	 location.href= "login.jsp"
         }
         function b(){
             document.getElementById("mainframe").style.display='block'
             document.getElementById("mainiframe").style.display='none'
         }
       </script>
       <title>Schedule</title>
       <style>
           @import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Serif+KR:wght@200&display=swap');
           @import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300&display=swap');
           
           header {
               position: relative;
               margin: 0 auto;
               text-align: center;
               width: 1100;
           }
           #logo {
           		width:1100px;
           		margin: 0 auto;
           }
           hr{
               width: 1000px;
               border-width: 2;
               border-style:solid;  
               margin-top: 30;
               color: gainsboro;
           }
           #navi{
           		width:1100px;
           		margin: 0 auto;
           		text-align: center;
           }
           ul{
               text-align: center;
            
           }
           li{
               display: inline-block;              
               margin-left: 80px;
               margin-right: 80px;
               font-size: 20;
           }
           a:visited {
               color: black;
           }
           a:link {              
               color: black;
               text-decoration: none;
           }
           a:hover {
               color: black;
           }
           /*#login:hover {
               color: black;
               font-weight: bold;
           }*/
           section {
               text-align: center;
           }
           /*.login{
               position: absolute;
               
               text-align: right;
               margin-top: 15;
               margin-bottom: -20;
           }*/
           nav>div{
               position: relative;
               margin: 0 auto;
           }
           #mainframe{
               width: 1100px;
               height: 550px;
               border-style:double;
               border-color: gainsboro;
               border-width:thick;
               /*margin-top: 50px;*/
               margin: 0 auto;
               margin-top: 50px;
           }
           #mainframe p{
               font-size: 35px;
               /*font-family: 'Nanum Myeongjo', serif;*/
               font-family: 'Noto Serif KR', serif;
           }
           #innertext{
               height: 200px;
           }
           #topline{
               float: left;
               margin-left: 30px;
               margin-top: 60px;
           }
           #bottomline{
               width: 1000px;
               float:right;
               margin-right: 10px;
               margin-top:-20px;
           }
           #mainframe img{
               width: 300px;
               height: 113px;
               float: right;
               margin-top: 5px;
               margin-left: -30px;
           }
           .sign{
               margin: 0 auto;
               margin-top: 200px;
           }
           .signbutton{
               width: 150px;
               height:70px;
               /*background-color:#a6c1ee;*//*fbc2eb*/
               /*background: linear-gradient(-10deg, #fbc2eb 0%, #a6c1ee 60%);*/
               background-color:gainsboro;
               border-style: none;
               border-radius: 20px;
               text-align: center;
               font-family: 'Montserrat', sans-serif;
               font-size: 25px;
               margin: 5px;
           }
           footer{
               width: 1100px;
               margin: auto;
               text-align: center;
               margin-top: 25px;
           }
           iframe{
               border-style: none;
               display: none;
               margin: auto;
           }
           #dd{
               margin-top : -50px;
               matgin-bottom: 10px;
           }
       </style>
    </head>
    <body style="table-layout: fixed">
        <header>
           <br> 
           <div id = "logo">
            	<img src="image\logo.png" width="250" onclick="b()" id="dd">
            	<!-- <div class="login"> &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="login.html" id="login">로그인</a> /
            	<a href="signup.html" id="login">회원가입</a>
            	</div> -->
            </div>
        </header>
         
        <nav style="margin-top:14px;">
            <div style="width: 1100px;">        
            <hr style="margin-bottom: -5px;">
            <ul>
                <li style="margin-left: 20px;">
                   <a target="mainiframe" id="day"><img src="image\day.png" width="100" onclick="day()"></a>                 
                </li>
                <li>
                    <a target="mainiframe" id="week"><img src="image\week.png" width="100" onclick="week()"></a>   
                </li>
                <li>
                    <a target="mainiframe" id="month"><img src="image\month.png" width="100" onclick="month()"></a>   
                </li>
            </ul>    
        
            <hr style="margin-top: -10px">
            </div>
        </nav>
        <section style="position: relative; margin: 0 auto; ">
            <div id="mainframe">
                <div id="innertext"><div id="topline"><p>예상 시간과 마감 일자를 입력하면</p></div>
                <div id="bottomline"><img src="image\timeshelf.png"><p>자동으로 일정을 정해 주는 맞춤형 시간선반,</p></div></div>
                <div class="sign"><input class="signbutton" type="button" name="login" value="login" onClick="location.href='login.jsp'"><input class="signbutton" type="button" name="signup" value="sign up" onClick="location.href='join.jsp'">
                </div>
            </div>
            <iframe width="1100" height="1160" name="mainiframe" id="mainiframe"></iframe>
        </section>
        <footer>
            <span id="on">ⓒO(n) 2021</span>
        </footer>
    </body>
</html>