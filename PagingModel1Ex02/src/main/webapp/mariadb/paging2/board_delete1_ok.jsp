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
	String seq = request.getParameter( "seq" );
	String password = request.getParameter( "password" );
	to.setSeq(seq);
	to.setPassword(password);
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardDeleteOk(to);	
	out.println( "<script type='text/javascript'>" );
	if( flag == 0 ) {
		out.println( "alert( '글삭제 성공' );" );
		out.println( "location.href='./board_list1.jsp';" );
	} else if( flag == 1 ) {
		out.println( "alert( '비밀번호 오류' );" );
		out.println( "history.back();" );
	} else if( flag == 2 ) {
		out.println( "alert( '글삭제 실패' );" );
		out.println( "history.back();" );
	}
	out.println( "</script>" );
%>