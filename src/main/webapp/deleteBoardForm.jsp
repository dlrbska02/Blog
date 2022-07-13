<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import ="java.util.*"%>
<%@ page import = "vo.*" %>
<%
	int boardNo = Integer.parseInt(request.getParameter("boardNo")); // boardNo parameter값 받아오기
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
<title>deleteBoardForm</title>
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
	<h1>글 삭제</h1>
		<form name="deleteBoard" method="post" action="<%=request.getContextPath()%>/deleteBoardAction.jsp">
			<div>
				게시판번호
				<input type="number" name="boardNo" value="<%=boardNo %>" readonly="readonly">
			</div>
			<div>
				비밀번호&emsp;
				<input type="password" id="boardPw"  name="boardPw" placeholder="비밀번호를 입력해주세요.">
			</div>
			<div>
				<br>
				<button type = "button" onclick="validityCk()" class="btn btn-danger">삭제</button>&emsp;<a href="<%=request.getContextPath()%>/boardOne.jsp?boardNo=<%=boardNo%>" class="btn btn-primary">뒤로</a>
			</div>
		</form>
	</div>
</div>
<br>
		<!-- footer -->
	<div>
		<jsp:include page="/partial/footer.jsp"></jsp:include>
	</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
// 유효성 체크
function validityCk(){
	if($("#boardPw").val() == ""){
		alert('비밀번호를 입력해주세요.');
		return;
	} else {
		deleteBoard.submit();
	}
};
</script>
</html>