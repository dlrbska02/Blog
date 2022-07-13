<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.Board" %>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩(한글깨짐방지)
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // boardNo parameter값 받아오기
	String boardPw = request.getParameter("boardPw"); // 입력한 비밀번호 받아오기
	// Board 생성
	Board board = new Board();
	board.boardNo = boardNo;
	board.boardPw = boardPw;
	System.out.println("boardNo:"+boardNo);
	System.out.println("boardPw:"+boardPw);
	
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 연결
	System.out.println("org.mariadb.jdbc.Driver" + "드라이버 연동 완료"); // 디버깅
	
	Connection conn = null; // 커넥션 널값
	String dburl = "jdbc:mariadb://3.38.93.7:3306/blog";
	String dbuser = "root";
	String dbpw = "java1004"; // dbpw 변수에 패스워드 담기
	
	conn = DriverManager.getConnection(dburl, dbuser, dbpw); // 드라이버 접속
	System.out.println(conn + "드라이버 접속 완료"); // 디버깅
	
	// 쿼리문 작성
	String sql = "DELETE FROM board WHERE board_no=? AND board_pw=?"; // sql변수에 쿼리문 담기
	PreparedStatement stmt = conn.prepareStatement(sql);
	//  값 넣기
	stmt.setInt(1, board.boardNo); 	  
	stmt.setString(2, board.boardPw); 
	
	int row = stmt.executeUpdate();
	if(row == 0) {
		System.out.println("삭제 실패");
		response.sendRedirect(request.getContextPath() + "/deleteBoardForm.jsp?boardNo=" + board.boardNo);
	} else if(row == 1) {
		System.out.println("삭제 성공");
		response.sendRedirect(request.getContextPath() + "/boardList.jsp");
	} else {
		System.out.println("오류");  // 예외
	}
	conn.close(); // connection 해제/ DB접속 종료
%>