package model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class MemberDAO {
	private DataSource dataSource = null;
	
	public MemberDAO() {
		// connection pool을 이용한 db연결
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			this.dataSource = (DataSource) envCtx.lookup("jdbc/mariadb4");
		} catch (NamingException e) {
			System.out.println("에러: " + e.getMessage());
		}
	}	
	public int login_ok(MemberTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder strHtml = new StringBuilder();
		//정상 : 0/ 비정상 : 1
		int flag = 1;
		try{			
			conn=this.dataSource.getConnection();
			String sql = "select name,mail,grade from member1 where id=? and password=password(?);";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getId());
			pstmt.setString(2, to.getPassword());
			rs = pstmt.executeQuery();
			if (rs.next()) {				
	            flag = 0;	            
	        }
		}catch(SQLException e){
			System.out.println("s 에러"+ e.getMessage());
		}finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return flag;
	}
	public MemberTO login_page(MemberTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder strHtml = new StringBuilder();
		//정상 : 0/ 비정상 : 1
		int flag = 1;
		try{			
			conn=this.dataSource.getConnection();
			String sql = "select id from member1 where id=? and password=password(?);";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getId());
			pstmt.setString(2, to.getPassword());
			rs = pstmt.executeQuery();
			if (rs.next()) {				
	            flag = 0;	            
	        }
		}catch(SQLException e){
			System.out.println("s 에러"+ e.getMessage());
		}finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
				if (rs != null) {
					rs.close();
				}
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return to;
	}
	
	
}
