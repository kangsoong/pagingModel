<%@page import="model1.BoardDAO"%>
<%@page import="model1.BoardTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>

<%
	request.setCharacterEncoding( "utf-8" );
	BoardTO to = new BoardTO();
	String cpage = request.getParameter( "cpage" );
	String seq = request.getParameter( "seq" );
	String password = request.getParameter( "password" );
    
	String subject = request.getParameter( "subject" );
	String mail = "";
	if(!request.getParameter( "mail1" ).equals( "" ) && !request.getParameter( "mail2" ).equals( "" )) {
		mail = request.getParameter( "mail1" ) + "@" + request.getParameter( "mail2" );
	}
	
	String content = request.getParameter( "content" );
    to.setSeq(seq);
    to.setPassword(password);
    to.setSubject(subject);
    to.setMail(mail);
    to.setContent(content);
    BoardDAO dao = new BoardDAO();
	int flag = dao.boardModifyOk(to);	
    
	out.println( "<script type='text/javascript'>" );
	if(flag == 0) {
		out.println( "alert('글수정 성공');" );
		out.println( "location.href='board_view1.jsp?seq=" + seq + "&cpage=" + cpage + "';" );
	} else if(flag == 1) {
		out.println( "alert('비밀번호 오류');" );
		out.println( "history.back();" );
	} else {
		out.println( "alert('글수정 에러');" );
		out.println( "history.back();" );
	}
	out.println( "</script>" );
%>