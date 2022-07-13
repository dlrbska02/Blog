<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	// 한글 깨짐 방지
	request.setCharacterEncoding("utf-8");	

	// update form에서 넘어와야 하는 인자값
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // 게시판 번호
	String categoryName = request.getParameter("categoryName"); // 게시판 카테고리
	String boardTitle = request.getParameter("boardTitle"); // 게시판 제목
	String boardContent = request.getParameter("boardContent"); // 게시판 내용
	String boardPw = request.getParameter("boardPw"); // 게시판 비밀번호
	
	// 디버깅 코드
	System.out.println(boardNo + " <--boardNo");
	System.out.println(categoryName + " categoryName");
	System.out.println(boardTitle + " <--boardTitle");
	System.out.println(boardContent + " <--boardContent");
	System.out.println(boardContent + " <--boardContent");
	System.out.println(boardPw + " <--boardPw");
	
	// vo 패키지 사용하여 Board 생성
	Board b = new Board();
	b.boardNo = boardNo;
	b.categoryName = categoryName;
	b.boardTitle = boardTitle;
	b.boardContent = boardContent;
	b.boardPw = boardPw;
	
	// MySql 연결
	// 0) MySql 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공"); // 디버깅 코드
	
	// 1) MySql RDBMS에 접속(IP주소, 접속계정 아이디, 패스워드)
	// 연결 초기화
	Connection conn = null;
	String dburl = "jdbc:mariadb://3.38.93.7:3306/blog";
	String dbuser = "root";
	String dbpw = "java1004";
	// Connection타입 연결된 데이터베이스에 SQL쿼리 명령을 전송할 수 있는 메서드를 가진 타입
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn + " <-- conn");	// 디버깅 코드
	
	// 2) UPDATE SQL 쿼리 문자열 저장
	String updateSql = "UPDATE BOARD SET category_name=?, board_title=?, board_content=?, update_date = NOW() WHERE board_no=? and board_pw=?";
	// UPDATE SQL 쿼리 저장
	PreparedStatement updateStmt = conn.prepareStatement(updateSql);
	System.out.println(updateSql + " <-- updateSql"); // 디버깅 코드
	// 요청받은 값 저장
	updateStmt.setString(1, b.categoryName);
	updateStmt.setString(2, b.boardTitle);
	updateStmt.setString(3, b.boardContent);
	updateStmt.setInt(4, b.boardNo);
	updateStmt.setString(5, b.boardPw);
	
	// 3) DB 연결 상태 확인
    // 몇행을 입력했는지 return 하는 코드
	int row = updateStmt.executeUpdate();
	if(row == 0) {
		// 수정이 1개도 안될시, 다시, 특정 게시판 번호의 delete form으로 리턴하는 코드
		System.out.println("수정실패");
		response.sendRedirect(request.getContextPath() + "/deleteBoardForm.jsp?boardNo=" + b.boardNo);
	} else if(row == 1) {
		// 수정이 성공하면, 특정 게시판 번호의 board one 화면으로 돌아간다
		System.out.println("수정성공");
		response.sendRedirect(request.getContextPath() + "/boardOne.jsp?boardNo=" + b.boardNo);
	} else {
		// 에러 코드
		System.out.println("수정에러");
	}
	
	// 4) 연결종료
	conn.close();
%>