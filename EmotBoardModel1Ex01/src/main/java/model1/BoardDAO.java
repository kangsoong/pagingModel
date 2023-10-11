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

public class BoardDAO {
	private DataSource dataSource = null;
	
	public BoardDAO() {
		// connection pool을 이용한 db연결
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context) initCtx.lookup("java:comp/env");
			this.dataSource = (DataSource) envCtx.lookup("jdbc/mariadb3");
		} catch (NamingException e) {
			System.out.println("에러: " + e.getMessage());
		}
	}
	
	// 각 페이지당 1개의 메서드
	
	// 작성 폼
	public void boardWrite(BoardTO to) {
		
	}
	
	// 작성 기능
	// return: 글 작성 성공시 0 / 실패시 1
	public int boardWriteOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder strHtml = new StringBuilder();
		//정상 : 0/ 비정상 : 1
		int flag = 1;
		try{			
			conn=this.dataSource.getConnection();
			String sql = "insert into board2 values (0,?,?,?,?,?,0,?,now(),?);";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSubject());
			pstmt.setString(2, to.getWriter());
			pstmt.setString(3, to.getMail());
			pstmt.setString(4, to.getPassword());
			pstmt.setString(5, to.getContent());
			pstmt.setString(6, to.getWip());
			pstmt.setString(7, to.getEmot());
			if(pstmt.executeUpdate()==1){
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
	
	// 글 목록 출력
	public ArrayList<BoardTO> boardList() {
		int cpage = 1; //1페이지 시작
		int recordPerPage = 10;
		Connection conn = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		ResultSet rs = null;
		int boardCount = 0;
		int lastpage = 0;
		int blockPerPage = 5;
		ArrayList<BoardTO> datas = new ArrayList<BoardTO>();
		try{			
			conn=this.dataSource.getConnection();	
			String sql1 = "SET @count=0;";
			pstmt1 = conn.prepareStatement(sql1);
			rs = pstmt1.executeQuery();		
			String sql2 = "UPDATE board2 SET seq =@count:=@count+1;";
			pstmt2 = conn.prepareStatement(sql2);
			rs = pstmt2.executeQuery();		
			String sql = "select seq,subject, writer,date_format(wdate,'%Y-%m-%d') wdate,hit,emoticon, datediff(now(),wdate)wgap from board2 order by seq desc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	
			while(rs.next()){
				BoardTO to = new BoardTO();
				String seq = rs.getString("seq");
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				String wdate = rs.getString("wdate");
				String hit = rs.getString("hit");
				String emoticon = rs.getString("emoticon");
				int wgap = rs.getInt("wgap"); 
				to.setSeq(seq);
				to.setSubject(subject);
				to.setWriter(writer);
				to.setWdate(wdate);
				to.setHit(hit);
				to.setEmot(emoticon);
				datas.add(to);
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
		return datas;
	}
	
	// 글 상세정보 출력
	public BoardTO boardView(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = this.dataSource.getConnection();
		
			String sql = "select subject, writer, mail, wip, date_format(wdate, '%Y.%m.%d %h:%m') wdate, hit, content from board1 where seq=?";
		
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
		
			rs.next();
		
			String subject = rs.getString("subject");
			String writer = rs.getString("writer");
			String mail = rs.getString("mail");
			String wip = rs.getString("wip");
			String wdate = rs.getString("wdate");
			String hit = rs.getString("hit");
			String content = rs.getString("content").replaceAll("\n", "<br />");
			
			to.setSubject(subject);
			to.setWriter(writer);
			to.setMail(mail);
			to.setWip(wip);
			to.setWdate(wdate);
			to.setHit(hit);
			to.setContent(content);
		
			sql = "update board1 set hit=hit+1 where seq=?";
		
			if (pstmt != null) {
				pstmt.close();
			}
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			// int result = pstmt.executeUpdate();
			pstmt.executeUpdate();
		
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
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
	
	// 글 수정 폼
	public BoardTO boardModify(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn =this.dataSource.getConnection();
			
			String sql = "select writer, subject, content, mail from board1 where seq=?";
		
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
		
			rs.next();
			to.setSubject(rs.getString("writer"));
			to.setWriter(rs.getString("subject"));
			to.setMail(rs.getString("mail"));
			to.setContent(rs.getString("content").replaceAll("\n", "<br />"));
			
			// System.out.println("mail: "+ rs.getString("mail"));
			// 메일이 빈칸이 아니면 분할해서 추가
			/*if(!rs.getString("mail").equals("")){
				mail1 = rs.getString("mail").split("@")[0];
				mail2 = rs.getString("mail").split("@")[1];
			}*/
			
		
		}  catch (SQLException e) {
			System.out.println(e.getMessage());
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
	
	// 글 수정 기능
	public int boardModifyOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		// 정상:0 비밀번호오류:1 이상:2
		int flag=2;
		String sql = "";
		
		try{
			conn = this.dataSource.getConnection();
			
			sql = "update board1 set subject=?, content=?, mail=? where seq=? and password=?";
				
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSubject());
			pstmt.setString(2, to.getContent());
			pstmt.setString(3, to.getMail());
			pstmt.setString(4, to.getSeq());
			pstmt.setString(5, to.getPassword());
				
			int result = pstmt.executeUpdate();
			if(result == 1){
				// 성공
				flag = 0;
			} else if(result == 0){
				// 비밀번호 오류
				flag = 1;
			}
			
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
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
	
	// 글 삭제 폼
	public BoardTO boardDelete(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			// DataSource dataSource = (DataSource)((Context)new InitialContext().lookup("java:comp/env")).lookup("jdbc/mariadb3");
		
			conn = this.dataSource.getConnection();
			
			String sql = "select subject, writer from board1 where seq=?";
		
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
		
			if(rs.next()) {
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
			}		
		} catch (SQLException e) {
			System.out.println(e.getMessage());
		} finally {
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
	
	// 글 삭제 기능
	public int boardDeleteOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String sql = "";
		int flag  = 0;
		try{
			conn =this.dataSource.getConnection();
			
			// 비밀번호를 프로그램적으로 가져오지 말 것
			// 비밀번호는 암호화 필요
			
			sql = "delete from board1 where seq=? and password=?";
				
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			pstmt.setString(2, to.getPassword());
				
			int result = pstmt.executeUpdate();
			if(result == 1){
				// 성공
				flag = 0;
			} else if(result == 0){
				// 비밀번호 오류
				flag = 1;
			}
			
			
		} catch (SQLException e) {
			System.out.println(e.getMessage());
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
}
