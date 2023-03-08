<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <meta name = "viewport" content = "width-device-width , initial-scale = 1">
<link rel = "stylesheet" href = "css/bootstrap.css">

<title>JSP 게시판 웹 사이트</title>
  <script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script> <%--제이쿼리를 링크를 통해서 가지고 오는 방식으로 가져옴--%>
    <script src = "js/bootstrap.js"></script> 
    <script type="text/javascript">
    function registerCheckFunction(){
	    var userID = $('#userID').val();
    	$.ajax({
    		type: 'POST',
    		url: './UserRegisterCheckServlet',
    		data: {userID:userID},
    		success: function(result){
    			if(result == 1){       			
    				$('#idCheckMessage').html('사용 가능한 아이디입니다.');       			
    			}else{       				
    				$('#idCheckMessage').html('사용할 수 없는 아이디입니다.');
    				}        	     		           	
    	}
     })     
  }
      
       function passwordCheckFunction(){
    	   var userPassword1 = $('#userPassword1').val();
    	   var userPassword2 = $('#userPassword2').val();
    	   if(userPassword1 != userPassword2){
    		   $('#passwordCheckMessage').html('비밀번호가 서로 일치하지 않습니다');
    	   } else{
    		   $('#passwordCheckMessage').html('');
    	   }
    	   
       }
        	
   </script>
<style>
@import url('https://fonts.googleapis.com/css2?family=Nanum+Myeongjo&family=Noto+Serif+KR:wght@200&display=swap');
    
     .from-group{
     width: 300px;
     padding:10px;
     margin: auto;
     }
     
     *{
     font-family: 'Noto Serif KR', serif;
     }
     
     #idCheck{
     display: inline-block;
       width: 90px;
       
     }
     
</style>
    
</head>
 <body>  
   
    <div style="text-align : center;">
    <a href="mainHome.jsp"><img src ="image\logo.png"  width ="200" height ="200"></a>
    </div>
     <div class="container">
         <div class = "col-lg-4"></div>
         <div class = "col-lg-4">
             <div class = "jumbotron" style= "padding-top: 20px">
                <form metod="post" action="joinAction.jsp">
                 <h3 style = "text-align: center;">회원가입</h3>
                  <div>
                    <div class = "from-group"  >
                        <input type = "text" id = "namen" class= "form-control" placeholder="이름" name="userName" maxlength="20">
                    </div>
                    
                    <div class = "from-group">
                        <input type="text"  id = "userID" class= "form-control" placeholder="아이디" name="userID" maxlength="20" id="userID" style="width: 170px;">
                        <input type="button" class="form-control" value="중복 확인" onclick="registerCheckFunction();" id="idCheck" style="background-color:#a6c1ee; border-color:#a6c1ee; color:white; ">                  
                        <h5 style = "color: blue;" id="idCheckMessage"></h5>
                    </div>
                    </div>
                    
                    <div class = "from-group">
                        <input type = "password"  id = "userPassword1" class= "form-control" placeholder="비밀번호" onkeyup="passwordCheckFunction()" name="userPassword" maxlength="20">
                    </div>
                    
                     <div class = "from-group">
                        <input type = "password"  id = "userPassword2" class= "form-control" placeholder="비밀번호 확인" onkeyup="passwordCheckFunction()" name="checkPassword" maxlength="20">
                    <h5 style = "color: blue;" id="passwordCheckMessage"></h5>
                    </div>
                                     
                    <div class = "from-group">
                        <input type = "email"  id = "email" class= "form-control" placeholder="이메일" name="userEmail" maxlength="20">
                    </div>
                    
                    <div class = "from-group">
                         <input type = "submit" class = "btn btn-primary form-control" value="회원가입" style="background-color:#a6c1ee; border-color:#a6c1ee;" >
                    </div>
                  </form>
               </div>           
             </div>
         </div>
     <script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
     <script src = "js/bootstrap.js"></script>
 </body>
</html>