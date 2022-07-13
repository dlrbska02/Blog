<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*"%>
<%@ page import ="vo.*" %>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 연결
	System.out.println("드라이버 로딩 성공");
	
	Connection conn = null; // 커넥션 널값
	String dburl = "jdbc:mariadb://3.38.93.7:3306/blog";
	String dbuser = "root";
	String dbpw = "java1004"; // dbpw 변수에 패스워드 담기
	conn = DriverManager.getConnection(dburl, dbuser, dbpw); // 드라이버 접속
	System.out.println(conn + " <-- conn"); // con값 디버깅 

	String boardOnesql = "select board_no boardNo, category_name categoryName, board_title boardTitle, board_content boardContent, board_pw boardPw, create_date createDate, update_date updateDate from board WHERE board_no = ?"; // sql변수에 쿼리문 담기
	PreparedStatement stmt = conn.prepareStatement(boardOnesql); // stmt 에 쿼리문 담기
	stmt.setInt(1,boardNo);
	ResultSet boardOneRs = stmt.executeQuery(); // 결과값 저장
	System.out.println(boardOneRs + "<--boardOneRs"); // 디버깅

	Board board = null;
	if(boardOneRs.next()) { // true값일때만 커서 옮기면서
		board = new Board(); // board값 담을 새로운 리스트 생성
		board.boardNo = boardOneRs.getInt("boardNo");
		board.categoryName = boardOneRs.getString("categoryName");
		board.boardTitle =  boardOneRs.getString("boardTitle");
		board.boardContent = boardOneRs.getString("boardContent");
		board.createDate =  boardOneRs.getString("createDate");
		board.updateDate =  boardOneRs.getString("updateDate");
	}
	
	// category 목록
	String categorySql = "SELECT category_name categoryName FROM category";
	PreparedStatement categoryStmt = conn.prepareStatement(categorySql);
	ResultSet categoryRs = categoryStmt.executeQuery();
	ArrayList<String> categoryList = new ArrayList<String>();
	while(categoryRs.next()) { // categoryRs ->
		categoryList.add(categoryRs.getString("categoryName"));
	}
	conn.close(); // connection 해제/ DB접속 종료
	/*
		UPDATE board SET
			category_name = ?,
			board_title = ?,
			board_content = ?,
			update_date = NOW()
		WHERE board_no = ? AND board_pw = ?
	*/
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
<title>insertBoardForm</title>
<style type="text/css">
	table, td {
		border: 1px solid #6EE3F7;
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
</head>
<body>
<div class="containor">
	<!-- 배너 -->
	<div>
	<jsp:include page="/partial/banner.jsp"></jsp:include>
	</div>
	<div align="center">
	<h1>수정</h1>
		<form name= "updateBoard" method="post" action="<%=request.getContextPath()%>/updateBoardAction.jsp">
		<div style="width: 50%;">
			<table class="table table-dark table-striped">
				<tr>
					<td>게시글 번호</td>
					<td><input type="text" name="boardNo" value="<%=board.boardNo%>"readonly></td>
				</tr>
				<tr>
					<td>카테고리 이름</td>
					<td>	
						<select name="categoryName">
							<%
								for(String s : categoryList) {
									if(s.equals(board.categoryName)) {
							%>
										<option value="<%=s%>"><%=s%></option>
							<%		
									} else {
							%>
										<option value="<%=s%>"><%=s%></option>
							<%
									}
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td>
						<input id="boardTitle" type="text" name="boardTitle">
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea id="boardContent" name="boardContent" rows="5" cols="80"></textarea>
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input id="boardPw" name="boardPw" type="password" class="form-select">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button  type = "button" onclick="validityCk()" class="btn btn-success">수정</button>&nbsp;
						<a href="<%=request.getContextPath()%>/boardOne.jsp?boardNo=<%=board.boardNo%>" class="btn btn-primary">뒤로</a>&nbsp;
					</td>
				</tr>
			</table>
			</div>
		</form>
	</div>
</div>
<div>
	<jsp:include page="/partial/footer.jsp"></jsp:include>
</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
// 유효성 체크
function validityCk(){
	if($("#boardTitle").val() == ""){
		alert('제목을 입력해주세요.');
		return;
	} else if($("#boardContent").val() == ""){
		alert('내용을 입력해주세요.');
		return;
	} else if($("#boardPw").val() == ""){
		alert('비밀번호를 입력해주세요.');
		return;
	} else {
		updateBoard.submit();
	}
};
</script>
</html>