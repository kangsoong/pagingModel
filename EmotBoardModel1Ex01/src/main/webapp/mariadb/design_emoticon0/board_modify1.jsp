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
	request.setCharacterEncoding( "utf-8" );
	
	String seq = request.getParameter( "seq" );
	String cpage = request.getParameter("cpage");
    
	String subject = "";
	String writer = "";
	String mail[] = null;
	String content = "";
	String emoticon = "";
    
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
    StringBuilder html = new StringBuilder();
	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup( "java:comp/env" );
		DataSource dataSource = (DataSource)envCtx.lookup( "jdbc/mariadb3" );
		
		conn = dataSource.getConnection();
        
		String sql = "select subject, writer, mail, content, emoticon from board2 where seq=?";
		pstmt = conn.prepareStatement( sql );
		pstmt.setString( 1, seq );
		
		rs = pstmt.executeQuery();
		if( rs.next() ) {
			subject = rs.getString( "subject" );
			writer = rs.getString( "writer" );
			if( rs.getString( "mail" ) == null ) {
				mail = new String[] { "", "" };
			} else {
				mail = rs.getString( "mail" ).split( "@" );
			}
			content = rs.getString( "content" );
			emoticon = rs.getString( "emoticon" );
		}
		for(int i=1;i<=45;i++){
			if(i%15==1){
				html.append("<tr>");
			}			
			html.append("<td>");
			if(i<10){
				if(i==Integer.valueOf(emoticon.substring(4))){					
					html.append("<img src='../../images/emoticon/emot0" + i + ".png' width='25'/><br />");
					html.append("<input type='radio' name='emot' value='emot0" + i + "' class='input_radio' checked='checked' />");
				}else{
					html.append("<img src='../../images/emoticon/emot0" + i + ".png' width='25'/><br />");
					html.append("<input type='radio' name='emot' value='emot0" + i + "' class='input_radio' />");
				}				
			} else{
				if(i==Integer.valueOf(emoticon.substring(4))){
					html.append("<img src='../../images/emoticon/emot" + i + ".png' width='25'/><br />");
					html.append("<input type='radio' name='emot' value='emot" + i + "' class='input_radio' checked='checked' />");
				}else{
					html.append("<img src='../../images/emoticon/emot" + i + ".png' width='25'/><br />");
					html.append("<input type='radio' name='emot' value='emot" + i + "' class='input_radio' />");
				}	
			}
			
			html.append("</td>");
			if(i%15==0){
				html.append("</tr>");
			}	
		}
		
		
		
	} catch( NamingException e ) {
		System.out.println( "[에러] : " + e.getMessage() );
	} catch( SQLException e ) {
		System.out.println( "[에러] : " + e.getMessage() );
	} finally {
		if( rs != null ) rs.close();
		if( pstmt != null ) pstmt.close();
		if( conn != null ) conn.close();
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
<script type="text/javascript">
	window.onload = function(){
		document.getElementById('ubtn').onclick = function(){
			if(document.ufrm.subject.value.trim() == ''){
				alert('제목을 입력해야됨');
				return;
			}
			if(document.ufrm.password.value.trim() == ''){
				alert('비밀번호를 입력해야됨');
				return;
			}
			document.ufrm.submit();
		}
	}
</script>
</head>

<body>
<!-- 상단 디자인 -->
<div class="con_title">
	<h3>게시판</h3>
	<p>HOME &gt; 게시판 &gt; <strong>게시판</strong></p>
</div>
<div class="con_txt">
	<form action="./board_modify1_ok.jsp" method="post" name="ufrm">
		<div class="contents_sub">	
		<input type="hidden" name="seq" value="<%=seq %>"/>
			<!--게시판-->
			<div class="board_write">
				<table>
				<tr>
					<th class="top">글쓴이</th>
					<td class="top"><input type="text" name="writer" value="<%=writer %>" class="board_view_input_mail" maxlength="5" readonly/></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="subject" value="<%=subject %>" class="board_view_input" /></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="password" value="" class="board_view_input_mail"/></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea name="content" class="board_editor_area"><%=content %></textarea></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td><input type="text" name="mail1" value="<%=mail[0] %>" class="board_view_input_mail"/> @ <input type="text" name="mail2" value="<%=mail[1] %>" class="board_view_input_mail"/></td>
				</tr>
				<tr>
					<th>이모티콘</th>
					<td align="center">
						<table>
						<%=html  %>						
						</table>
					</td>
				</tr>
				</table>
			</div>
			
			<div class="btn_area">
				<div class="align_left">
					<input type="button" value="목록" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_list1.jsp?cpage=<%=cpage %>'" />
					<input type="button" value="보기" class="btn_list btn_txt02" style="cursor: pointer;" onclick="location.href='board_view1.jsp?seq=<%=seq %>&cpage=<%=cpage %>'" />
				</div>
				<div class="align_right">
					<input type="button" id="ubtn" value="수정" class="btn_write btn_txt01" style="cursor: pointer;" />
				</div>
			</div>
			<!--//게시판-->
		</div>
	</form>
</div>
<!-- 하단 디자인 -->

</body>
</html>
