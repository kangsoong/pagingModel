package model1;

import java.awt.Robot;
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
		
		int flag = 1;
		
		try {			
			conn = this.dataSource.getConnection();			
			String sql = "insert into board1 values ( 0, ?, ?, ?, ?, ?, 0, ?, now() )";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, to.getSubject());
			pstmt.setString( 2, to.getWriter() );
			pstmt.setString( 3, to.getMail());
			pstmt.setString( 4, to.getPassword());
			pstmt.setString( 5, to.getContent());
			pstmt.setString( 6, to.getWip());
			
			if( pstmt.executeUpdate() == 1 ) {
				flag = 0;
			}
			
		} catch( SQLException e ) {
			System.out.println( "[에러] " + e.getMessage() );
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return flag;
	}
	
	// 글 목록 출력
	public BoardListTO boardList(BoardListTO listTO) {
		int cpage = listTO.getCpage();		
		int recordPerPage = listTO.getRecordPerPage();	
		int totalRecord = 0;
		//
		int totalPage = 0;
		
		//
		int blockPerPage = listTO.getBlockPerPage();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<BoardTO> ListTOs = new ArrayList<BoardTO>();
		try {
			conn = this.dataSource.getConnection();

			String sql = "select seq, subject, writer, date_format(wdate, '%Y-%m-%d') wdate, hit, datediff(now(), wdate) wgap from board1 order by seq desc";
			pstmt = conn.prepareStatement( sql );			
			rs = pstmt.executeQuery();			
			rs.last();
			listTO.setTotalRecord(rs.getRow());
			rs.beforeFirst();			
			listTO.setTotalPage(( ( listTO.getTotalRecord() - 1 ) / listTO.getRecordPerPage() ) + 1);
			
			int skip = ( listTO.getCpage() - 1 ) * listTO.getRecordPerPage();
			if( skip != 0 ) rs.absolute( skip );
			for( int i=0 ; i<recordPerPage && rs.next() ; i++ ) {
				BoardTO to = new BoardTO();
				String seq = rs.getString( "seq" );
				String subject = rs.getString( "subject" );
				String writer = rs.getString( "writer" );
				String wdate = rs.getString( "wdate" );
				String hit = rs.getString( "hit" );
				int wgap = rs.getInt( "wgap" );
				to.setSeq(seq);
				to.setSubject(subject);
				to.setWriter(writer);
				to.setWdate(wdate);
				to.setHit(hit);
				to.setWgap(wgap);			
				ListTOs.add(to);
			}
			listTO.setBoardLists(ListTOs);
			
		}catch( SQLException e ) {
			System.out.println( "[에러] " + e.getMessage() );
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		listTO.setStartBlock(listTO.getCpage() - ( listTO.getCpage()-1 ) % listTO.getBlockPerPage());
		listTO.setEndBlock(listTO.getCpage() - ( listTO.getCpage()-1 ) % listTO.getBlockPerPage() + listTO.getBlockPerPage() - 1);
		if( listTO.getEndBlock() >= listTO.getTotalPage()) {
			listTO.setEndBlock(listTO.getTotalPage());
		}
		return listTO;
	}
	
	// 글 상세정보 출력
	public BoardTO boardView(BoardTO to) {
		
		
		return to;
	}
	
	// 글 수정 폼
	public BoardTO boardModify(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;	 
		String subject = "";
		String writer = "";
		String mail[] = null;
		String content = "";
		try {
			conn = this.dataSource.getConnection();	        
			String sql = "select subject, writer, mail, content from board1 where seq=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, to.getSeq() );			
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				subject = rs.getString( "subject" );
				writer = rs.getString( "writer" );
				if( rs.getString( "mail" ) == null ) {
					to.setMail("");
				} else {
					to.setMail(rs.getString( "mail" ));
				}
				content = rs.getString( "content" );
				to.setSubject(subject);
				to.setWriter(writer);				
				to.setContent(content);
			}
		} catch( SQLException e ) {
			System.out.println( "[에러] : " + e.getMessage() );
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
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
	    
		int flag = 2;
		try {			
			conn =this.dataSource.getConnection();
	        
			String sql = "update board1 set subject=?, mail=?, content=? where seq=? and password=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, to.getSubject() );
			pstmt.setString( 2, to.getMail() );
			pstmt.setString( 3, to.getContent() );
			pstmt.setString( 4, to.getSeq() );
			pstmt.setString( 5, to.getPassword() );
			
			int result = pstmt.executeUpdate() ;
			if( result == 0 ) {
				flag = 1;
			} else if( result == 1 ) {
				flag = 0;
			}
		}catch( SQLException e ) {
			System.out.println( "[에러] : " + e.getMessage() );
		}finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return flag;
	}
	
	// 글 삭제 폼
	public BoardTO boardDelete(BoardTO to) {
		String subject = "";
		String writer = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = this.dataSource.getConnection();

			String sql = "select subject, writer from board1 where seq=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, to.getSeq() );
			
			rs = pstmt.executeQuery();
		
			if( rs.next() ) {
				subject = rs.getString( "subject" );
				writer = rs.getString( "writer" );
				to.setSubject(subject);
				to.setWriter(writer);
			}
			
			
		}catch( SQLException e ) {
			System.out.println( "[에러] " + e.getMessage() );
		}finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
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
		
		int flag = 2;
		try {
			conn = this.dataSource.getConnection();

			String sql = "delete from board1 where seq=? and password=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, to.getSeq() );
			pstmt.setString( 2, to.getPassword() );

			int result = pstmt.executeUpdate();
			if( result == 0 ) {
				flag = 1;
			} else if( result == 1 ) {
				flag = 0;
			}
			
		} catch( SQLException e ) {
			System.out.println( "[에러] " + e.getMessage() );
		} finally {
			try {
				if (conn != null) {
					conn.close();
				}
				if (pstmt != null) {
					pstmt.close();
				}
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return flag;
	}
}
