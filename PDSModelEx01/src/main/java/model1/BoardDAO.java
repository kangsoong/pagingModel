package model1;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

public class BoardDAO {
	private DataSource dataSource = null;
	private String uploadpath = "C:/java/jsp-workspace/PDSModelEx01/src/main/webapp/upload";
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
			String sql = "insert into pds_board1 values (0,?,?,?,?,?,?,?,0,?,now());";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSubject());
			pstmt.setString(2, to.getWriter());
			pstmt.setString(3, to.getMail());
			pstmt.setString(4, to.getPassword());
			pstmt.setString(5, to.getContent());
			pstmt.setString(6, to.getFilename());
			pstmt.setLong(7, to.getFilesize());
			pstmt.setString(8, to.getWip());
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
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return flag;
	}
	
	// 글 목록 출력
	public ArrayList<BoardTO> boardList() {	
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<BoardTO> listTO = new ArrayList<BoardTO>();
		try{			
			conn=this.dataSource.getConnection();
			String sql = "SET @count=0;";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();		
			sql = "UPDATE pds_board1 SET seq =@count:=@count+1;";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();		
			sql = "select seq,subject, writer,filesize,date_format(wdate,'%Y-%m-%d') wdate,hit, datediff(now(),wdate)wgap from pds_board1 order by seq desc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	
			while(rs.next()){
				BoardTO to = new BoardTO();
				String seq = rs.getString("seq");
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				String wdate = rs.getString("wdate");
				Long filesize = rs.getLong("filesize");
				String hit = rs.getString("hit");
				int wgap = rs.getInt("wgap");
				to.setSeq(seq);
				to.setSubject(subject);
				to.setWriter(writer);
				to.setWdate(wdate);
				to.setFilesize(filesize);
				to.setHit(hit);
				to.setWgap(wgap);
				listTO.add(to);
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
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return listTO;
	}
	
	// 글 상세정보 출력
	public BoardTO boardView(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String seq = to.getSeq();
		try{			
			conn=this.dataSource.getConnection();
			String sql = "update pds_board1 set hit = hit + 1 where seq = ?";
			pstmt = conn.prepareStatement(sql);		
			pstmt.setString(1, seq);		
			pstmt.executeUpdate();
			sql = "select subject, writer,mail,wip,wdate,hit,content,filesize,filename from pds_board1 where seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, seq);
			rs = pstmt.executeQuery();				
			if(rs.next()){
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				String wdate = rs.getString("wdate");
				String hit = rs.getString("hit");
				String mail = rs.getString("mail");
				String wip = rs.getString("wip");
				long filesize = rs.getLong("filesize");
				String filename = rs.getString("filename");
				String content = rs.getString("content").replaceAll("\n", "<br />");
				to.setSubject(subject);
				to.setWriter(writer);
				to.setWdate(wdate);
				to.setFilesize(filesize);
				to.setHit(hit);
				to.setMail(mail);
				to.setWip(wip);
				to.setFilename(filename);
				to.setContent(content);
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
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		
		return to;
	}
	
	// 글 수정 폼
	public BoardTO boardModify(BoardTO to) {
		String subject = "";
		String writer = "";
		String mail[] = null;
		String content = "";
		String filename = "";
		long filesize =0;		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;	  
		String seq = to.getSeq();
		try {			
			conn =this.dataSource.getConnection();	        
			String sql = "select subject, writer, mail, content,filename,filesize from pds_board1 where seq=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, seq );			
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
				filename = rs.getString( "filename" ) ==null ? "" : rs.getString("filename");
				filesize = rs.getLong( "filesize" );
				to.setSubject(subject);
				to.setWriter(writer);
				to.setFilesize(filesize);
				to.setFilename(filename);
				to.setContent(content);
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
		return to;
	}
	
	// 글 수정 기능
	public int boardModifyOk(BoardTO to) {
		String uploadPath ="C:/java/jsp-workspace/PDSModelEx01/src/main/webapp/upload";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int flag = 2;
		String seq = to.getSeq();
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context)initCtx.lookup( "java:comp/env" );
			DataSource dataSource = (DataSource)envCtx.lookup( "jdbc/mariadb3" );
			conn = dataSource.getConnection();
			String sql = "select filename from pds_board1 where seq=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, seq );
			rs = pstmt.executeQuery();	
			String oldfilename = null;
			if(rs.next()){
				oldfilename = rs.getString("filename");
			}
			if(to.getFilename() != null){
				sql = "update pds_board1 set subject=?, mail=?, content=?,filename=?,filesize=? where seq=? and password=?";
				pstmt = conn.prepareStatement( sql );
				pstmt.setString( 1, to.getSubject() );
				pstmt.setString( 2, to.getMail() );
				pstmt.setString( 3, to.getContent() );
				pstmt.setString( 4, to.getFilename() );
				pstmt.setLong( 5, to.getFilesize() );
				pstmt.setString( 6, seq );
				pstmt.setString( 7, to.getPassword() );
			}else{
				sql = "update pds_board1 set subject=?, mail=?, content=? where seq=? and password=?";
				pstmt = conn.prepareStatement( sql );
				pstmt.setString( 1, to.getSubject() );
				pstmt.setString( 2, to.getMail() );
				pstmt.setString( 3, to.getContent() );
				pstmt.setString( 4, seq );
				pstmt.setString( 5, to.getPassword() );
			}		
			int result = pstmt.executeUpdate();
			if( result == 0 ) {
				flag = 1;
				if(to.getFilename() != null){
					File file = new File(uploadPath,to.getFilename());
					file.delete();
				}
			} else if( result == 1 ) {
				flag = 0;
				if(to.getFilename() != null&&oldfilename!=null){
					File file = new File(uploadPath,oldfilename);
					file.delete();
				}
			}
		} catch( NamingException e ) {
			System.out.println( "[에러] : " + e.getMessage() );
		} catch( SQLException e ) {
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
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String subject=null;
		String writer=null;
		try{			
			conn=this.dataSource.getConnection();
			String sql = "select subject, writer from pds_board1 where seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();				
			if(rs.next()){
				subject = rs.getString("subject");
				writer = rs.getString("writer");
				to.setSubject(subject);
				to.setWriter(writer);
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
		int flag = 1;
		String uploadPath ="C:/java/jsp-workspace/PDSModelEx01/src/main/webapp/upload";
		String seq = to.getSeq();
		try{			
			conn=this.dataSource.getConnection();
			String sql = "select filename from pds_board1 where seq=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, seq);
			rs = pstmt.executeQuery();
			String filename=null;
			if(rs.next()){
				filename = rs.getString("filename");
			}
			to.setFilename(filename);
			//비밀번호를  select하지 말것
			//비밀번호는 암호화
			sql = "delete from pds_board1 where seq=? and password=?";
			//값 =>0 or 1(지워진거)
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, seq);
			pstmt.setString(2, to.getPassword());
			int result = pstmt.executeUpdate();	
			if(result==0){
				//비밀번호 오류
				flag=1;
			}else if(result==1){
				//정상
				File file = new File(uploadPath,filename);
				file.delete();
				flag=0;
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
			} catch (SQLException e) {
				System.out.println("에러: " + e.getMessage());
			}
		}
		return flag;
	}
}
