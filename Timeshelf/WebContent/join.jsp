<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
 <meta name = "viewport" content = "width-device-width , initial-scale = 1">
<link rel = "stylesheet" href = "css/bootstrap.css">

<title>JSP �Խ��� �� ����Ʈ</title>
  <script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script> <%--���������� ��ũ�� ���ؼ� ������ ���� ������� ������--%>
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
    				$('#idCheckMessage').html('��� ������ ���̵��Դϴ�.');       			
    			}else{       				
    				$('#idCheckMessage').html('����� �� ���� ���̵��Դϴ�.');
    				}        	     		           	
    	}
     })     
  }
      
       function passwordCheckFunction(){
    	   var userPassword1 = $('#userPassword1').val();
    	   var userPassword2 = $('#userPassword2').val();
    	   if(userPassword1 != userPassword2){
    		   $('#passwordCheckMessage').html('��й�ȣ�� ���� ��ġ���� �ʽ��ϴ�');
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
                 <h3 style = "text-align: center;">ȸ������</h3>
                  <div>
                    <div class = "from-group"  >
                        <input type = "text" id = "namen" class= "form-control" placeholder="�̸�" name="userName" maxlength="20">
                    </div>
                    
                    <div class = "from-group">
                        <input type="text"  id = "userID" class= "form-control" placeholder="���̵�" name="userID" maxlength="20" id="userID" style="width: 170px;">
                        <input type="button" class="form-control" value="�ߺ� Ȯ��" onclick="registerCheckFunction();" id="idCheck" style="background-color:#a6c1ee; border-color:#a6c1ee; color:white; ">                  
                        <h5 style = "color: blue;" id="idCheckMessage"></h5>
                    </div>
                    </div>
                    
                    <div class = "from-group">
                        <input type = "password"  id = "userPassword1" class= "form-control" placeholder="��й�ȣ" onkeyup="passwordCheckFunction()" name="userPassword" maxlength="20">
                    </div>
                    
                     <div class = "from-group">
                        <input type = "password"  id = "userPassword2" class= "form-control" placeholder="��й�ȣ Ȯ��" onkeyup="passwordCheckFunction()" name="checkPassword" maxlength="20">
                    <h5 style = "color: blue;" id="passwordCheckMessage"></h5>
                    </div>
                                     
                    <div class = "from-group">
                        <input type = "email"  id = "email" class= "form-control" placeholder="�̸���" name="userEmail" maxlength="20">
                    </div>
                    
                    <div class = "from-group">
                         <input type = "submit" class = "btn btn-primary form-control" value="ȸ������" style="background-color:#a6c1ee; border-color:#a6c1ee;" >
                    </div>
                  </form>
               </div>           
             </div>
         </div>
     <script src = "https://code.jquery.com/jquery-3.1.1.min.js"></script>
     <script src = "js/bootstrap.js"></script>
 </body>
</html>