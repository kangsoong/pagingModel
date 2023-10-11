<%@page import="model1.BoardDAO"%>
<%@page import="model1.BoardTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="java.io.File" %>

<%
	
	String uploadPath ="C:/java/jsp-workspace/PDSModelEx01/src/main/webapp/upload";
	int maxFileSize = 2*1024*1024;
	String encType = "utf-8";
	MultipartRequest multi = new MultipartRequest(request,uploadPath,maxFileSize,encType,new DefaultFileRenamePolicy());

	String seq = multi.getParameter( "seq" );
	String password = multi.getParameter( "password" );
    
	String subject = multi.getParameter( "subject" );
	String mail = "";
	if(!multi.getParameter( "mail1" ).equals( "" ) && !multi.getParameter( "mail2" ).equals( "" )) {
		mail = multi.getParameter( "mail1" ) + "@" + multi.getParameter( "mail2" );
	}
	
	String content = multi.getParameter( "content" );	
	String newfilename = multi.getFilesystemName("upload");
	long newfilesize = 0;
	if(multi.getFile("upload")!=null){
		newfilesize = multi.getFile("upload").length();
	}
	BoardTO to =new BoardTO();
	to.setSeq(seq);
	to.setPassword(password);
	to.setSubject(subject);
	to.setMail(mail);
	to.setContent(content);
	to.setFilename(newfilename);
	to.setFilesize(newfilesize);
	BoardDAO dao = new BoardDAO();
	int flag = dao.boardModifyOk(to);
	out.println( "<script type='text/javascript'>" );
	if(flag == 0) {
		out.println( "alert('글수정 성공');" );
		out.println( "location.href='board_view1.jsp?seq=" + seq + "';" );
	} else if(flag == 1) {
		out.println( "alert('비밀번호 오류');" );
		out.println( "history.back();" );
	} else {
		out.println( "alert('글수정 에러');" );
		out.println( "history.back();" );
	}
	out.println( "</script>" );
%>
