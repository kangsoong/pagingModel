<%@page import="model1.MemberDAO"%>
<%@page import="model1.MemberTO"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@page import="util.Cookies" %>
<%
	//���̵� �н����� �޾ƿ�
	request.setCharacterEncoding("utf-8");
	String id = request.getParameter("id");
	String password = request.getParameter("password");
	
	MemberTO to = new MemberTO();
	to.setId(id);
	to.setPassword(password);
	MemberDAO dao = new MemberDAO();
	int flag = dao.login_ok(to);
	
	//�����̷���
	out.println("<script type='text/javascript'>");
	if(flag==0){
		//�������
		response.addCookie(Cookies.createCookie("cid", id));
		response.addCookie(Cookies.createCookie("cgroup", "B"));
		out.println("alert('�α��� ����');");
		out.println("location.href='logout.jsp';");
	}else if(flag==1){
		//����
		out.println("alert('���̵� ��� ����');");
		out.println("history.back();");
	}else{
		out.println("alert('��Ÿ ����');");
		out.println("history.back();");
	}
	out.println("</script>");
%>