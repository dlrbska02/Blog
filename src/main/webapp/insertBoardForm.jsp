<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import ="java.util.*"%>
<%
	Class.forName("org.mariadb.jdbc.Driver"); // 드라이버 연결
	Connection conn = null; // 커넥션 널값
	String dburl = "jdbc:mariadb://3.38.93.7:3306/blog";
	String dbuser = "root";
	String dbpw = "java1004"; // dbpw 변수에 패스워드 담기
	conn = DriverManager.getConnection(dburl, dbuser, dbpw); // 드라이버 접속
	String sql = "SELECT category_name categoryName FROM category ORDER BY category_name ASC"; // sql변수에 쿼리문 담기
	PreparedStatement stmt = conn.prepareStatement(sql); // stmt 에 쿼리문 담기
	ResultSet rs = stmt.executeQuery(); // 결과값 저장
	System.out.println(conn + " <-- conn"); // con값 디버깅 
	ArrayList<String> list = new ArrayList<String>(); // 배열선언
	while(rs.next()) { // next() 메소드를 통해, 선택되는 행을 바꿀 수 있다. 다음행이 내려갈 다음행이 있을 경우 TRUE를 반환하고, 없을 경우 FALSE를 반환한다.
		list.add(rs.getString("categoryName"));
	}
	conn.close(); // connection 해제/ DB접속 종료
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>InsertBoardForm</title>
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
	<h1>게시글 입력</h1>
		<form name="insertBoard" method="post" action="<%=request.getContextPath()%>/insertBoardAction.jsp">
			<div style="width: 50%;">
			<table class="table table-dark table-striped">
				<tr>
					<td>카테고리</td>
					<td>
						<select name="categoryName" class="form-select">
							<%
								for(String s : list) {
							%>
									<option value="<%=s%>"><%=s%></option>
							<%		
								}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td>
						<input id="boardTitle" type="text" name="boardTitle"  class="form-select">
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea id="boardContent" name="boardContent" rows="5" cols="80"  class="form-select"></textarea>
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input id="boardPw" name="boardPw" type="password"  class="form-select">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<button type="button" onclick="validityCk()" class="btn btn-success">등록</button>&nbsp;
						<a href="<%=request.getContextPath()%>/boardList.jsp" class="btn btn-primary">뒤로</a>
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
		insertBoard.submit();
	}
};
</script>
</html>