<%@page import="model1.BoardDAO"%>
<%@page import="model1.BoardTO"%>
<%@page import="java.net.InetAddress"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>

<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.sql.DataSource"%>
<%
	request.setCharacterEncoding("utf-8");
	BoardTO to = new BoardTO();
	
	to.setSubject(request.getParameter("subject"));
	to.setWriter(request.getParameter("writer"));
	to.setPassword(request.getParameter("password"));
	to.setMail("");	
	if(!request.getParameter("mail1").equals("") && !request.getParameter("mail2").equals("") ){
		to.setMail(request.getParameter("mail1") + "@" + request.getParameter("mail2"));
	}
	to.setContent(request.getParameter("content"));
	to.setEmot(request.getParameter("emot"));
	to.setWip(InetAddress.getLocalHost().getHostAddress());
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardWriteOk(to);	
	out.println("<script type='text/javascript'>");
	if(flag==0){
		//정상수행
		out.println("alert('글쓰기 성공');");
		out.println("location.href='./board_list1.jsp';");
	}else if(flag==1){
		//에러
		out.println("alert('글쓰기 실패');");
		out.println("history.back();");
	}
	out.println("</script>");
%>