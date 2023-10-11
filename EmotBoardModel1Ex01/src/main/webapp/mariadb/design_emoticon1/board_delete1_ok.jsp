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
	String password = request.getParameter("password");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	// 2:시스템 에러 1 : 비밀번호 에러 0 : 정상
	int flag = 2;
	try{			
		DataSource dataSource = (DataSource) new InitialContext().lookup("java:comp/env/jdbc/mariadb3");
		conn=dataSource.getConnection();
		//비밀번호를  select하지 말것
		//비밀번호는 암호화
		String sql = "delete from board2 where seq=? and password=?";
		//값 =>0 or 1(지워진거)
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, seq);
		pstmt.setString(2, password);
		int result = pstmt.executeUpdate();	
		if(result==0){
			//비밀번호 오류
			flag=1;
		}else if(result==1){
			//정상
			flag=0;
		}
				
	}catch(NamingException e){
		out.println("n 에러" + e.getMessage());
	}catch(SQLException e){
		out.println("s 에러"+ e.getMessage());
	}finally{
		if(pstmt!=null)pstmt.close();
		if(conn!=null)conn.close();
	}
	out.println("<script type='text/javascript'>");
	if(flag==0){
		//정상수행
		out.println("alert('글삭제 성공');");
		out.println("location.href='./board_list1.jsp';");
	}else if(flag==1){
		//에러
		out.println("alert('비밀번호 오류');");
		out.println("history.back();");
	}else if(flag==3){
		//에러
		out.println("alert('글삭제 실패');");
		out.println("history.back();");
	}
	out.println("</script>");
	
%>
