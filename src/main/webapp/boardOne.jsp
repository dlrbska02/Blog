<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // boardNo parameter값 받아오기
	System.out.println("[boardOne.jsp] boardNo : " + boardNo); // 디버깅
	
	Class.forName("org.mariadb.jdbc.Driver"); //  드라이버 연결
	System.out.println("org.mariadb.jdbc.Driver" + "드라이버 연동 완료"); // 디버깅
	
	Connection conn = null; // Connection null값
	String dburl = "jdbc:mariadb://3.38.93.7:3306/blog";
	String dbuser = "root";
	String dbpw = "java1004"; // dbpw 변수에 패스워드 입력

	conn = DriverManager.getConnection(dburl, dbuser, dbpw); // 드라이버 접속
	System.out.println(conn + "드라이버 접속 완료"); // 디버깅
	
	// 쿼리문 작성
	PreparedStatement stmt = conn.prepareStatement("SELECT board_no boardNo, category_name categoryName, board_content boardContent, board_title boardTitle, create_date createDate, update_date updateDate FROM board where board_no = ?");
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	
	Board board = null; // board null 값
	if(rs.next()) { // 다음줄에 값이 있으면 true 없으면 false
		board = new Board(); // board 객체 생성
		board.boardNo = rs.getInt("boardNo"); // 번호
		board.boardTitle = rs.getString("boardTitle"); // 카테고리
		board.categoryName = rs.getString("categoryName"); // 제목
		board.boardContent = rs.getString("boardContent"); // 내용
		board.createDate = rs.getString("createDate"); // 생성날짜
		board.updateDate = rs.getString("updateDate"); // 수정날짜
	}
	
	conn.close(); // connection 해제
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style type="text/css">
	table, th, td {border : 1px solid #6EE3F7;}
	input{
		text-align: center;
	}
	
	@font-face {
	    font-family: 'SpoqaHanSansNeo-Regular';
	    	src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SpoqaHanSansNeo-Regular.woff') format('woff');
	    font-weight: normal;
	    font-style: normal;
	}
	
	body {
		font-family: 'SpoqaHanSansNeo-Regular';
}
</style>
<title>boardOne</title>
</head>
<body>
	<!-- 배너 -->
	<div>
	<jsp:include page="/partial/banner.jsp"></jsp:include>
	</div>
	<div align="center">
		<h1>board 게시글</h1>
		<div class="table table-dark" style="width: 50%">
			<div>게시판 번호</div>
			<div>
				<input readonly="readonly" value="<%= board.boardNo %>" >
			</div>
			<br>
			<div>작성일</div>
			<div class="table-dark">
				<input readonly="readonly" value="<%= board.createDate %>" >
			</div>
			<br>
			<div>수정일</div>
			<div>
				<input readonly="readonly" value="<%= board.updateDate %>" >
			</div>
			<br>
			<div class="table-dark">카테고리</div>
			<div class="table-dark">
				<input readonly="readonly" value="<%= board.categoryName %>" >
			</div>
			<br>
			<div>제목</div>
			<div>
				<input readonly="readonly" value="<%= board.boardTitle %>" >
			</div>
			<br>
			<div class="table-dark">내용</div>
			<div class="table-dark">
				<textarea style="width: 50%; height: 150px; text-align: center;" readonly="readonly"><%= board.boardContent %></textarea>
			</div>
		</div>
		<br>
		<div>
			<a href="<%=request.getContextPath()%>/updateBoardForm.jsp?boardNo=<%= board.boardNo %>" class="btn btn-success">수정</a>&nbsp;
			<a href="<%=request.getContextPath()%>/deleteBoardForm.jsp?boardNo=<%= board.boardNo %>" class="btn btn-danger">삭제</a>&nbsp;
			<a href="<%=request.getContextPath()%>/boardList.jsp?boardList=<%=board.boardNo%>" class="btn btn-info">목록</a>
		</div>
	</div>	
<div>
	<jsp:include page="/partial/footer.jsp"></jsp:include>
</div>
</body>
</html>