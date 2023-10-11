package model1;

import java.util.ArrayList;

public class BoardListTO {
	private int cpage; //현제 페이지
	private int recordPerPage; //한 화면에 몇개의 게시물
	private int blockPerPage; //한 화면에 몇 페이지 까지
	private int totalPage; //총 페이지 수
	private int totalRecord; //총 게시물 수
	private int startBlock; //화면 밑의 첫번째 페이지
	private int endBlock; // 화면 밑의 마지막 페이지
	private ArrayList<BoardTO> boardLists;
	public BoardListTO() {
		// TODO Auto-generated constructor stub
		this.cpage = 1;
		this.recordPerPage=10;
		this.blockPerPage=5;
		this.totalPage=1;
		this.totalRecord=0;
	}
	public int getCpage() {
		return cpage;
	}
	public void setCpage(int cpage) {
		this.cpage = cpage;
	}
	public int getRecordPerPage() {
		return recordPerPage;
	}
	public void setRecordPerPage(int recordPerPage) {
		this.recordPerPage = recordPerPage;
	}
	public int getBlockPerPage() {
		return blockPerPage;
	}
	public void setBlockPerPage(int blockPerPage) {
		this.blockPerPage = blockPerPage;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getTotalRecord() {
		return totalRecord;
	}
	public void setTotalRecord(int totalRecord) {
		this.totalRecord = totalRecord;
	}
	public int getStartBlock() {
		return startBlock;
	}
	public void setStartBlock(int startBlock) {
		this.startBlock = startBlock;
	}
	public int getEndBlock() {
		return endBlock;
	}
	public void setEndBlock(int endBlock) {
		this.endBlock = endBlock;
	}
	public ArrayList<BoardTO> getBoardLists() {
		return boardLists;
	}
	public void setBoardLists(ArrayList<BoardTO> boardLists) {
		this.boardLists = boardLists;
	}
	
}
