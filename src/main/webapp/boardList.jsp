<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8"); // 인코딩

	// boardList페이지 실행하면 최근 10개의 목록을 보여 주고 1page로 설정
	int currentPage = 1; // 현재페이지의 기본값이 1페이지
	if(request.getParameter("currentPage") != null) { // 이전, 다음 링크를 통해서 들어왔다면
		currentPage	= Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage+ "<-- currentPage");
	
	String categoryName = "";
	if(request.getParameter("categoryName") != null) {
		categoryName = request.getParameter("categoryName");
	}
	
	
	// 페이지 바뀌면 끝이 아니고, 가지고 오는 데이터가 변경되어야 한다.
	/*
		알고리즘
		SELECT .... LIMIT ?,10"
		
		currentpage	beginRow
		1			0
		2			10
		3			20
		4			30
		
		? <----- (currentpage-1)*10
	*/
	
	final int rowPerPage = 10;
	
	int beginRow = (currentPage-1)*rowPerPage; // 현재페이지가 변경되면 biginRow도 변경된다. -> 가져오는 데이터 변경된다.
	
	int displayPage = 10;// 화면에 표시할 갯수
	int startPage = ((currentPage - 1) / displayPage) * displayPage + 1;
	int endPage = startPage + displayPage - 1;
	

	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = null;
	String dburl = "jdbc:mariadb://3.38.93.7:3306/blog";
	String dbuser = "root";
	String dbpw = "java1004";
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn + " <-- conn");
	/*
		SELECT category_name categoryName, COUNT(*) cnt
		FROM board
		GROUP BY category_name
	*/
	String categorySql = "SELECT category_name categoryName, COUNT(*) cnt FROM board GROUP BY category_name";
	PreparedStatement categoryStmt = conn.prepareStatement(categorySql);
	ResultSet categoryRs = categoryStmt.executeQuery();
	
	// 쿼리에 결과를 Category, Board VO로 저장할 수 없다. -> HashMap을 사용해서 저장하자!
	ArrayList<HashMap<String, Object>> categoryList = new ArrayList<HashMap<String, Object>>();
	while(categoryRs.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("categoryName", categoryRs.getString("categoryName"));
		map.put("cnt", categoryRs.getInt("cnt"));
		categoryList.add(map);
	}
	
	// boardList
	String boardSql = null;
	PreparedStatement boardStmt = null;
	if(categoryName.equals("")) {
		boardSql = "SELECT board_no boardNo, category_name categoryName, board_title boardTitle, create_date createDate FROM board ORDER BY create_date DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, beginRow);
		boardStmt.setInt(2, rowPerPage);
	} else {
		boardSql = "SELECT board_no boardNo, category_name categoryName, board_title boardTitle, create_date createDate FROM board WHERE category_name =? ORDER BY create_date DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, categoryName);
		boardStmt.setInt(2, beginRow);
		boardStmt.setInt(3, rowPerPage);
	}
	ResultSet boardRs = boardStmt.executeQuery();
	ArrayList<Board> boardList = new ArrayList<Board>();
	while(boardRs.next()) {
		Board b = new Board();
		b.boardNo = boardRs.getInt("boardNo");
		b.categoryName = boardRs.getString("categoryName");
		b.boardTitle = boardRs.getString("boardTitle");
		b.createDate = boardRs.getString("createDate");
		boardList.add(b);
	}
	
	int totalRow = 0; // select count(*) from board;
		String totalRowSql = "SELECT COUNT(*) cnt FROM board";
		PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
		ResultSet totalRowRs = totalRowStmt.executeQuery();
		if(totalRowRs.next()) {
			totalRow = totalRowRs.getInt("cnt");
			System.out.println(totalRow + "<--totalRow(1000)");
		}
		int lastPage = 0;
		if(totalRow / rowPerPage == 0){
			lastPage = totalRow / rowPerPage;
		} else {
			lastPage = (totalRow / rowPerPage) + 1;
		}
		
	conn.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardList</title>
 <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/css/bootstrap.min.css">
  <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.1/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<style type="text/css">
	table, th, td {
		border: 1px solid #6EE3F7;
		text-align: center;
	}
	ul{
   list-style:none;
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
<body style="background-color: silver;">
	<!-- 배너 -->
	<div>
	<jsp:include page="/partial/banner.jsp"></jsp:include>
	</div>
	<div>
		
		<!-- category별 게시글 링크 메뉴 -->
	
	<div class="row">
		<span class="col-sm-1"></span>
			<%
				for(HashMap<String, Object> m : categoryList) {
			%>
					<span class="col-sm-1">
						<a href="<%=request.getContextPath()%>/boardList.jsp?categoryName=<%=m.get("categoryName")%>"class="btn btn-dark" class="badge badge-primary"><%=m.get("categoryName")%>(<%=m.get("cnt")%>)</a>
					</span>
			<%		
				}
			%>
		<span class="col-sm-1"></span>
	</div>
	</div>
	<br>
		<!-- 게시글 리스트 -->
	
	<div class="row">
	<div class="col-sm-4">
		<p align="center"></p>
	</div>
		<div class="col-sm-4 text-black rounded">
		<h1 class="font-weight-bold" align="center">게시글 목록</h1>
	</div>
		<div class="col-sm-4">
		<p align="center"></p>
	</div>
	</div>
		<div class="table-responsive-sm">  
		<table class="table table-dark table-hover">
		<thead>
			<tr>
				<th>카테고리</th>
				<th>제목</th>
				<th>만든날짜</th>
			</tr>
		</thead>
		<tbody>
			<%
			for(Board b : boardList) {
			%>
				<tr>
					<td><%=b.categoryName%></td>
					<td><a href="<%=request.getContextPath()%>/boardOne.jsp?boardNo=<%=b.boardNo%>"><%=b.boardTitle%></a></td>
					<td><%=b.createDate%></td>
				</tr>
			<%	
			}
			%>
		</tbody>
	</table>
		</div>
		<div align="right">
		<span><a href="<%=request.getContextPath()%>/insertBoardForm.jsp" class="btn btn-primary">게시글 입력</a></span>
		</div>
		<div align="center">
				<a class="btn btn-primary" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=1&categoryName=<%=categoryName%>">처음으로</a>
			<%
				if(currentPage > 1) { // 현재페이지가 1이면 이전페이지가 존재해서는 안된다.
			%>
				<a href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=currentPage-1%>&categoryName=<%=categoryName%>" class="btn btn-info">이전</a>
			<%   
			
				}
			%>
			<%
				for(int i=startPage; i<=endPage; i++){ // 스타트 페이지 를 i에 지정 for을 통한 반복문 실행
					if(endPage<=lastPage){
			%>
				<a href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>" class="btn btn-info"><%=i%></a>
				
			<%
					} else if(endPage>lastPage){
			%>
				<a href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=i%>&categoryName=<%=categoryName%>" class="btn btn-info"><%=i%></a>
			<%
				}
				if(i == lastPage){
					break;
				}
			}
			if(currentPage != lastPage){
			%>
				<a href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=currentPage+1%>&categoryName=<%=categoryName%>" class="btn btn-info">다음</a>
			<%
				}
			%>
				<a class="btn btn-primary" href="<%=request.getContextPath()%>/boardList.jsp?currentPage=<%=lastPage%>&categoryName=<%=categoryName%>">끝으로</a>
		</div>
	<!-- footer -->
	<div>
		<jsp:include page="/partial/footer.jsp"></jsp:include>
	</div>
</body>
</html>