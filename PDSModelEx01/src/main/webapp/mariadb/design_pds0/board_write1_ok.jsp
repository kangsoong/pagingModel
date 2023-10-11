<%@page import="model1.BoardDAO"%>
<%@page import="model1.BoardTO"%>
<%@page import="java.net.InetAddress"%>
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
	BoardTO to = new BoardTO();
	String subject = multi.getParameter("subject");
	String writer = multi.getParameter("writer");
	String mail = "";
	if(!multi.getParameter("mail1").equals("") && !multi.getParameter("mail2").equals("") ){
		mail = multi.getParameter("mail1") + "@" + multi.getParameter("mail2");
	}			
	String password = multi.getParameter("password");
	String content = multi.getParameter("content");
	String wip = InetAddress.getLocalHost().getHostAddress();//ip주소 불러오는 함수
	String filename = multi.getFilesystemName("upload");
	long filesize = 0;
	if(multi.getFile("upload")!=null){
		filesize = multi.getFile("upload").length();
	}
	to.setSubject(subject);
	to.setWriter(writer);
	to.setMail(mail);
	to.setPassword(password);
	to.setContent(content);
	to.setWip(wip);
	to.setFilename(filename);
	to.setFilesize(filesize);
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