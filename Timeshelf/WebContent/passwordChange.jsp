<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name = "viewport" content = "width-device=width", initial-scale = "1">
<link rel = "stylesheet" href = "css/bootstrap.css">
<title>��й�ȣ ����</title>
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
     
</style>
</head>
<body>
  
  <form metod="post" action="passwordChangeAction.jsp">
                 <h3 style = "text-align: center;">��й�ȣ ����</h3><br><br>
                    
                    <div class = "from-group">
                        <input type = "password"  id = "nowpassword" class= "form-control" placeholder="���� ��й�ȣ" name="userPassword" maxlength="20">
                    </div>
                    
                     <div class = "from-group">
                        <input type = "password"  id = "newpassword1" class= "form-control" placeholder="�� ��й�ȣ" name="newPassword1" maxlength="20">
                    <h5 style = "color: blue;" id="passwordCheckMessage"></h5>
                    </div>
                    
                    <div class = "from-group">
                        <input type = "password"  id = "newpassword2" class= "form-control" placeholder="�� ��й�ȣ Ȯ��" name="newPassword2" maxlength="20">
                    <h5 style = "color: blue;" id="passwordCheckMessage"></h5>
                    </div>
                                                    
                    <div class = "from-group">
                         <input type = "submit" class = "btn btn-primary form-control" value="Ȯ��" style="background-color:#a6c1ee; border-color:#a6c1ee;" >
                    </div>
    </form>
                  
</body>
</html>