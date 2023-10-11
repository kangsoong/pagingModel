<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="model1.BoardTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="model1.BoardDAO"%>
<%@page import="model1.BoardListTO"%>

<%
	request.setCharacterEncoding( "utf-8" );
	BoardTO to = new BoardTO();
	String subject = request.getParameter( "subject" );
	String writer = request.getParameter( "writer" );
	String mail = ""; 
	if( !request.getParameter( "mail1" ).equals("") 
			&& !request.getParameter( "mail2" ).equals("") ) {
		mail = request.getParameter( "mail1" ) + "@" + request.getParameter( "mail2" );
	}
			
	String password = request.getParameter( "password" );
	String content = request.getParameter( "content" );	
	String wip = request.getRemoteAddr();
	to.setSubject(subject);
	to.setSubject(subject);
	to.setWriter(writer);
	to.setMail(mail);
	to.setPassword(password);
	to.setContent(content);
	to.setWip(wip);
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardWriteOk(to);
	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert( '글쓰기 성공' );" );
		out.println( "location.href='./board_list1.jsp';" );
	} else if( flag == 1 ) {
		out.println( "alert( '글쓰기 실패' );" );
		out.println( "history.back();" );
	}
	out.println( "</script>" );
%>