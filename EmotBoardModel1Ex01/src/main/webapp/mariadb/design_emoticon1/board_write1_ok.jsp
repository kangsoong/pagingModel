<%@page import="java.net.InetAddress"%>
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
	String subject = request.getParameter("subject");
	String writer = request.getParameter("writer");
	String mail = "";
	if(!request.getParameter("mail1").equals("") && !request.getParameter("mail2").equals("") ){
		mail = request.getParameter("mail1") + "@" + request.getParameter("mail2");
	}
			
	String password = request.getParameter("password");
	String content = request.getParameter("content");
	String wip = InetAddress.getLocalHost().getHostAddress();//ip주소 불러오는 함수
	//String wip = request.getRemoteAddr();//ip주소 불러오는 함수
	String emoticon = request.getParameter("emot");
	//System.out.println(subject);
	//System.out.println(writer);
	//System.out.println(mail);
	//System.out.println(password);
	//System.out.println(content);
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	StringBuilder strHtml = new StringBuilder();
	//정상 : 0/ 비정상 : 1
	int flag = 1;
	try{			
		DataSource dataSource = (DataSource) new InitialContext().lookup("java:comp/env/jdbc/mariadb3");
		conn=dataSource.getConnection();
		String sql = "insert into board2 values (0,?,?,?,?,?,0,?,now(),?);";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, subject);
		pstmt.setString(2, writer);
		pstmt.setString(3, mail);
		pstmt.setString(4, password);
		pstmt.setString(5, content);
		pstmt.setString(6, wip);
		pstmt.setString(7, emoticon);
		if(pstmt.executeUpdate()==1){
			flag = 0;
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
		out.println("alert('글쓰기 성공');");
		out.println("location.href='./board_list1.jsp';");
	}else if(flag==1){
		//에러
		out.println("alert('글쓰기 실패');");
		out.println("history.back();");
	}
	out.println("</script>");
%>