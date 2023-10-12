<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="util.Cookies" %>
<%
	response.addCookie(Cookies.createCookie("cid","","", -1));
	response.addCookie(Cookies.createCookie("cgroup","","",-1));
	out.println("<script type='text/javascript'>");
	out.println("alert('·Î±×¾Æ¿ô µÊ');");
	out.println("location.href='login.jsp';");
	out.println("</script>");
%>