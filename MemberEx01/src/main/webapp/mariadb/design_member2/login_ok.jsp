<%@page import="model1.MemberDAO"%>
<%@page import="model1.MemberTO"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="util.Cookies" %>
<%
	//아이디 패스워드 받아옴
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	
	MemberTO to = new MemberTO();
	to.setId(id);
	to.setPassword(password);
	MemberDAO dao = new MemberDAO();
	int flag = dao.login_ok(to);
	
	//리다이렉션
	out.println("<script type='text/javascript'>");
	if(flag==0){
		//정상수행
		response.addCookie(Cookies.createCookie("cid", id));
		response.addCookie(Cookies.createCookie("cgroup", "B"));
		out.println("alert('로그인 성공');");
		out.println("location.href='logout.jsp';");
	}else if(flag==1){
		//에러
		out.println("alert('아이디 비번 오류');");
		out.println("history.back();");
	}else{
		out.println("alert('기타 오류');");
		out.println("history.back();");
	}
	out.println("</script>");
%>