<%@page import="model1.BoardTO"%>
<%@page import="model1.BoardDAO"%>
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
	String seq = request.getParameter("seq");
	to.setSeq(seq);
	BoardDAO dao = new BoardDAO();	
	to = dao.boardView(to);
	StringBuilder sbHtml = new StringBuilder();
	String subject = to.getSubject();
	String writer = to.getWriter();
	String wdate = to.getWdate();
	String hit = to.getHit();
	String mail = to.getMail();
	String wip = to.getWip();
	long filesize = to.getFilesize();
	String filename = to.getFilename();
	String content = to.getContent();
	
	//앤터키 <br>로 바꾸기
	
	sbHtml.append("<table>");
	sbHtml.append("<tr>");
	sbHtml.append("<th width='10%'>제목</th>");
	sbHtml.append("<td width='60%'>" + subject + "</td>");
	sbHtml.append("<th width='10%'>등록일</th>");
	sbHtml.append("<td width='20%'>" + wdate + "</td>");
	sbHtml.append("</tr>");
	sbHtml.append("<tr>");
	sbHtml.append("<th>작성자</th>");
	sbHtml.append("<td>" + writer + "(" + mail + ")(" + wip + ")</td>");
	sbHtml.append("<th>조회</th>");
	sbHtml.append("<td>" + hit + "</td>");
	sbHtml.append("</tr>");
	sbHtml.append("<tr>");
	sbHtml.append("<th>첨부 파일</th>");
	if(filename!=null){
		sbHtml.append("<td><a href='./download.jsp?filename=" + filename + "'>" + filename + "(" + (filesize/1024) + " Kbyte)</td>");
		//sbHtml.append("<td><a href='../../upload/" + filename + "'>" + filename + "(" + (filesize/1024) + " Kbyte)</td>");
	}else{
		sbHtml.append("<td>없음</td>");
	}			
	sbHtml.append("<th></th>");
	sbHtml.append("</tr>");
	sbHtml.append("<tr>");
	sbHtml.append("<td colspan='4' height='200' valign='top' style='padding: 20px; line-height: 160%'>" + content + "</td>");
	sbHtml.append("</tr>");
	sbHtml.append("</table>");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="../../css/board.css">
</head>

<body>
<!-- 상단 디자인 -->
<div class="con_title">
	<h3>게시판</h3>
	<p>HOME &gt; 게시판 &gt; <strong>게시판</strong></p>
</div>
<div class="con_txt">
	<div class="contents_sub">
		<!--게시판-->
		<div class="board_view">
			<table>
			<%=sbHtml.toString() %>
			</table>
		</div>

		<div class="btn_area">
			<div class="align_left">
				<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jsp'" />
			</div>
			<div class="align_right">
				<input type="button" value="수정" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_modify1.jsp?seq=<%=seq %>'" />
				<input type="button" value="삭제" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_delete1.jsp?seq=<%=seq %>'" />
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.jsp'" />
			</div>
		</div>
		<!--//게시판-->
	</div>
</div>
<!-- 하단 디자인 -->

</body>
</html>
