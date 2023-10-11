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
	String subject=null;
	String writer=null;
	//정상 : 0/ 비정상 : 1
	int flag = 1;
	try{			
		DataSource dataSource = (DataSource) new InitialContext().lookup("java:comp/env/jdbc/mariadb3");
		conn=dataSource.getConnection();
		String sql = "select subject, writer from board2 where seq = ?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, seq);
		rs = pstmt.executeQuery();				
		if(rs.next()){
			subject = rs.getString("subject");
			writer = rs.getString("writer");
		}
		
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
<script type="text/javascript">
	window.onload = function(){
		document.getElementById('e_dbtn').onclick = function(){
			if(document.e_dfrm.password.value.trim()==''){
				alert('비밀번호를 입력하셔야 합니다.');
				return;
			}
			document.e_dfrm.submit();
			
		}
	}
</script>
<body>
<!-- 상단 디자인 -->
<div class="con_title">
	<h3>게시판</h3>
	<p>HOME &gt; 게시판 &gt; <strong>게시판</strong></p>
</div>
<div class="con_txt">
	<form action="./board_delete1_ok.jsp" method="post" name="e_dfrm">
		<div class="contents_sub">	
		<input type="hidden" name="seq" value="<%=seq %>"/>
			<!--게시판-->
			<div class="board_write">
				<table>
				<tr>
					<th class="top">글쓴이</th>
					<td class="top"><input type="text" name="writer" value="<%= writer %>" class="board_view_input_mail" maxlength="5" readonly/></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="subject" value="<%=subject %>" class="board_view_input" readonly/></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="password" value="" class="board_view_input_mail"/></td>
				</tr>
				</table>
			</div>
			
			<div class="btn_area">
				<div class="align_left">
					<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jspcpage=<%=cpage %>'" />
					<input type="button" value="보기" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_view1.jsp?seq=<%=seq %>&cpage=<%=cpage %>'" />
				</div>
				<div class="align_right">
					<input type="button" id = "e_dbtn" value="삭제" class="btn_write btn_txt01" style="cursor: pointer;" />
				</div>
			</div>
			<!--//게시판-->
		</div>
	</form>
</div>
<!-- 하단 디자인 -->

</body>
</html>
