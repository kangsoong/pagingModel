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
	String seq = request.getParameter("seq");
	String cpage = request.getParameter("cpage");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	//정상 : 0/ 비정상 : 1
	int flag = 1;
	StringBuilder sbHtml = new StringBuilder();
	int boardCount = 0;
	String subject = null;
	String writer = null;
	String wdate = null;
	String hit = null;
	String emoticon = null;
	String mail = null;
	String wip = null;
	String content = null;
	try{			
		DataSource dataSource = (DataSource) new InitialContext().lookup("java:comp/env/jdbc/mariadb3");
		conn=dataSource.getConnection();
		String sql = "update board2 set hit = hit + 1 where seq = ?";		
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, seq);
		rs = pstmt.executeQuery();
		sql = "select subject, writer, wdate,hit,emoticon,mail,wip,content from board2 where seq=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, seq);
		rs = pstmt.executeQuery();
		if(rs.next()){
			subject = rs.getString("subject");
			writer = rs.getString("writer");
			wdate = rs.getString("wdate");
			hit = rs.getString("hit");
			emoticon = rs.getString("emoticon");
			mail = rs.getString("mail");
			wip = rs.getString("wip");
			content = rs.getString("content");
			
		}
		sbHtml.append("<tr>");
		sbHtml.append("<th width='10%'>제목</th>");
		sbHtml.append("<td width='60%'>(<img src='../../images/emoticon/" + emoticon + ".png' width='15'/>)&nbsp;" + subject + "</td>");
		sbHtml.append("<th width='10%'>등록일</th>");
		sbHtml.append("<td width='20%'>" + wdate + "</td>");
		sbHtml.append("</tr>");
		sbHtml.append("<tr>");
		sbHtml.append("<th>글쓴이</th>");
		sbHtml.append("<td>" + writer + "(" + mail + ")(" + wip + ")</td>");
		sbHtml.append("<th>조회</th>");
		sbHtml.append("<td>" + hit + "</td>");
		sbHtml.append("</tr>");
		sbHtml.append("<tr>");
		sbHtml.append("<td colspan='4' height='200' valign='top' style='padding: 20px; line-height: 160%'>" + content + "</td>");
		sbHtml.append("</tr>");
		
		
	}catch(NamingException e){
		out.println("n 에러" + e.getMessage());
	}catch(SQLException e){
		out.println("s 에러"+ e.getMessage());
	}finally{
		if(pstmt!=null)pstmt.close();
		if(conn!=null)conn.close();
	}
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
			<%= sbHtml.toString() %>
			</table>
		</div>

		<div class="btn_area">
			<div class="align_left">
				<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jsp?cpage=<%=cpage %>'" />
			</div>
			<div class="align_right">
				<input type="button" value="수정" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_modify1.jsp?seq=<%=seq %>&cpage=<%=cpage %>'" />
				<input type="button" value="삭제" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_delete1.jsp?seq=<%=seq %>&cpage=<%=cpage %>'" />
				<input type="button" value="쓰기" class="btn_write btn_txt01" style="cursor: pointer;" onclick="location.href='board_write1.jsp?cpage=<%=cpage %>'" />
			</div>
		</div>	
		<!--//게시판-->
	</div>
</div>
<!-- 하단 디자인 -->

</body>
</html>
