<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.util.*" %>
<%@ page import ="java.sql.*" %>
<%@ page import ="vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩(한글깨짐방지)	
	
	//파라미터값 가져오기
	String boardTitle = request.getParameter("boardTitle");	
	String boardContent = request.getParameter("boardContent");
	String boardPw = request.getParameter("boardPw");
	String categoryName = request.getParameter("categoryName");
	
	//디버깅
	System.out.println(boardTitle+"  <--제목");	
	System.out.println(boardContent+"  내용");	
	System.out.println(boardPw+"  <--비번");	
	System.out.println(categoryName+"  <--카테고리 이름");
   /*
      INSERT INTO board(
            category_name
            , board_title
            , board_content
            , board_pw
            , create_date
            , update_date
      ) VALUES (
         ?, ?, ?, ?, NOW(), NOW()
      )
   */
   Class.forName("org.mariadb.jdbc.Driver");					// 드라이버 로딩
   System.out.println("성공");									// 로딩 성공
   Connection conn = null;										// connection null 값
   String dburl = "jdbc:mariadb://3.38.93.7:3306/blog";
   String dbuser = "root";
   String dbpw = "java1004";									// 비밀번호
   conn = DriverManager.getConnection(dburl, dbuser, dbpw);		// 위의 3개를 변수화하여 db접속
   																				// 카테고리 이름,제목 내용 비밀번호 작성날짜 수정 날짜를 추가하는 sql문 작성
   String sql=" INSERT INTO board(category_name , board_title , board_content, board_pw, create_date, update_date) VALUES ( ?, ?, ?, ?, NOW(), NOW())";
   PreparedStatement stmt = conn.prepareStatement(sql);							// sql문 실행
	// stmt의 ? 표현식값을 완성한다.
	stmt.setString(1, categoryName);								
	stmt.setString(2, boardTitle);
	stmt.setString(3, boardContent); // ? 순서대로 값 입력
	stmt.setString(4, boardPw);
	
	int row = stmt.executeUpdate();	 // 몇행을 입력했는지 return
	
	if(row == 1) {
		System.out.println(row+"행 입력성공"); // 디버깅
	} else {
		System.out.println("입력실패");	// 디버깅
	}
	conn.close(); // connection 해제
   
   response.sendRedirect(request.getContextPath()+"/boardList.jsp");
%>