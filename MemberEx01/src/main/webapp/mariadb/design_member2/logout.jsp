<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="javax.servlet.http.Cookie"%>
<%@page import="model1.MemberDAO"%>
<%@page import="model1.MemberTO"%>
<%@page import="util.Cookies"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	Cookies cookies = new Cookies(request);
	if(!cookies.exists("cid")||!cookies.exists("cgroup")){
		//로그인 안함
	}else if(cookies.getValue("cid").equals("")||cookies.getValue("cgroup").equals("") ){
		out.println("<script type='text/javascript'>");
		out.println("alert('로그인 해야함');");
		out.println("location.href='login_form.jsp';");
		out.println("</script>");		
	}else{
		String id = cookies.getValue("cid");
		String loginTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../../css/member.css">
<script type="text/javascript">
	window.onload = function(){
		document.getElementById("lbtn").onclick = function(){
			// alert("클릭");
			if(document.lfrm.id.value.trim() == ""){
				alert("아이디를 입력하세요.")
				return;
			}
			if(document.lfrm.password.value.trim() == ""){
				alert("비밀번호를 입력하세요.")
				return;
			}
			document.lfrm.submit();
		};
	};
</script>
</head>
<body>

<div class="header">
	<h1>My Website</h1>
	<p>Resize the browser window to see the effect.</p>
</div>

<div class="topnav">
	<a href="#">Link</a>
	<a href="#">Link</a>
	<a href="#">Link</a>
	<div class="loginrow">
		<!--
		<form action="" method="" name="" >
			<label for="id" class="login">아이디</label>
			<input type="text" id="id" name="id" />
			/&nbsp;&nbsp;
			<label for="password" class="login">비밀번호</label>
			<input type="password" id="password" name="password" />
			<input type="button" id="" value="회원가입" />
			<input type="button" id="" value="로  그  인" />
		</form>
		-->
		<label class="login">아이디</label>
		<label class="login"><%=id %></label>
		/&nbsp;&nbsp;
		<label class="login">로그인 시간</label>
		<label class="login"><%=loginTime %></label>
		<input type="button" id="" value="정보수정" />
		<input type="button" id="" value="로그아웃" />
	</div>
</div>

<div class="row">
	<div class="leftcolumn">
		<div class="card">
			<h2>TITLE HEADING</h2>
			<h5>Title description, Dec 7, 2017</h5>
			<div class="fakeimg" style="height:200px;">Image</div>
			<p>Some text..</p>
			<p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
		</div>
		<div class="card">
			<h2>TITLE HEADING</h2>
			<h5>Title description, Sep 2, 2017</h5>
			<div class="fakeimg" style="height:200px;">Image</div>
			<p>Some text..</p>
			<p>Sunt in culpa qui officia deserunt mollit anim id est laborum consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco.</p>
		</div>
  	</div>
  	<div class="rightcolumn">
    	<div class="card">
			<h2>About Me</h2>
			<div class="fakeimg" style="height:100px;">Image</div>
			<p>Some text about me in culpa qui officia deserunt mollit anim..</p>
		</div>
		<div class="card">
			<h3>Popular Post</h3>
			<div class="fakeimg"><p>Image</p></div>
			<div class="fakeimg"><p>Image</p></div>
			<div class="fakeimg"><p>Image</p></div>
		</div>
		<div class="card">
			<h3>Follow Me</h3>
			<p>Some text..</p>
		</div>
	</div>
</div>

<div class="footer">
	<h2>Footer</h2>
</div>

</body>
</html>
<%
	}
%>