<%-- 
  - Author(s): Grayson Cox, Sebastian Kazun
  - Date: April 16, 2019
  --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file="./db_info.jsp"%>
<html>
<head>
	<title>Results</title>
	<style>
		table, th, td {
			border: 1px solid black;
			border-collapse: collapse;
		}
		th, td {
			padding: 15px;
			text-align: left;
		}
		table#t01 {
			width: 100%;    
			background-color: #f1f1c1;
		}
	</style>
</head>
<body>
	<h3>Query Results</h3>

	<table style="width:100%">
	<%
		Connection conn = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;

		// Java way for handling an error using try catch
		try {
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(db_url, db_user, db_pswd);


			//switch case that handles execution of each query depending on the page accessed
			switch (request.getHeader("Referer")) {
				case "http://localhost:8080/project/q1.jsp": //the case (query number)
					//the query to execute
					stmt = conn.prepareStatement(	
						"SELECT t.retweet_count, t.textbody, t.posting_user, u.category, u.sub_category "
						+ "FROM tweet t, user u "
						+ "WHERE t.posting_user = u.screen_name "
						+ "AND t.posted_year = ? "
						+ "AND t.posted_month = ? " 
						+ "ORDER BY retweet_count DESC "
						+ "LIMIT ?;");
					
					//setting user input to fill ? in above query
					stmt.setInt(1, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(2, Integer.parseInt(request.getParameter("month")));
					stmt.setInt(3, Integer.parseInt(request.getParameter("k")));
					rs = stmt.executeQuery();
					//query executes and results are then displayed
					%>
							<tr>
								<th>Retweets</th>
								<th>Textbody</th>
								<th>User</th>
								<th>Category</th>
								<th>Subcategory</th>
							</tr>
					<%
					//displays the results
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("retweet_count") + "</td>");
						out.println("<td>" + rs.getString("textbody") + "</td>");
						out.println("<td>" + rs.getString("posting_user") + "</td>");
						out.println("<td>" + rs.getString("category") + "</td>");
						out.println("<td>" + rs.getString("sub_category") + "</td>");
						out.println("</tr>");
					}
					break;
				case "http://localhost:8080/project/q2.jsp":
					stmt = conn.prepareStatement(
						"SELECT u.screen_name, u.category, t.textbody, t.retweet_count "
						+ "FROM hashtag h "
						+ "INNER JOIN tweet t "
						+ "INNER JOIN user u "
						+ "ON u.screen_name = t.posting_user "
						+ "ON t.tid = h.tid "
						+ "WHERE h.hashtagname = ? "
						+ "AND t.posted_month = ? "
						+ "AND t.posted_year = ? "
						+ "ORDER BY retweet_count DESC "
						+ "LIMIT ?;");

					stmt.setString(1, request.getParameter("hashtag"));
					stmt.setInt(2, Integer.parseInt(request.getParameter("month")));
					stmt.setInt(3, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(4, Integer.parseInt(request.getParameter("k")));
					rs = stmt.executeQuery();
					%>
					<tr>
						<th>screen_name</th>
						<th>category</th>
						<th>textbody</th>
						<th>retweet_count</th>
					</tr>
					<%
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("screen_name") + "</td>");
						out.println("<td>" + rs.getString("category") + "</td>");
						out.println("<td>" + rs.getString("textbody") + "</td>");
						out.println("<td>" + rs.getString("retweet_count") + "</td>");
						out.println("</tr>");
					}
					break;
				case "http://localhost:8080/project/q3.jsp":
					stmt = conn.prepareStatement(

					"SELECT distinct a.hashtagname, group_concat(a.ofstate) as states, count(*) AS state_cnt "
					+ "FROM ( SELECT h.hashtagname, t.posted_year, u.ofstate, count(*) AS tweet_cnt "
					+ "		FROM tweet t "
					+ "		INNER JOIN hashtag h ON h.tid = t.tid "
					+	"	INNER JOIN user u ON u.screen_name = t.posting_user "
					+	"	WHERE t.posted_year = ? AND u.screen_name = t.posting_user "
					+	"	GROUP BY h.hashtagname, u.ofstate, t.posted_year "
					+ ") AS a "
					+ "GROUP BY a.hashtagname "
					+ "ORDER BY state_cnt DESC "
					+ "LIMIT ?;");

					stmt.setInt(1, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(2, Integer.parseInt(request.getParameter("k")));
					rs = stmt.executeQuery();
					%>
					<tr>
						<th>hashtagname</th>
						<th>states</th>
						<th>state_cnt</th>
					</tr>
					<%
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("hashtagname") + "</td>");
						out.println("<td>" + rs.getString("states") + "</td>");
						out.println("<td>" + rs.getString("state_cnt") + "</td>");
						out.println("</tr>");
					}
					break;
				case "http://localhost:8080/project/q6.jsp":
					String[] hashtags = request.getParameter("hashtags").split(",");
					String s = "(";
					for (int i = 0; i < hashtags.length - 1; i++) {
						s += "?,";
					}
					s += "?)";
					stmt = conn.prepareStatement(
					
					"SELECT u.screen_name, u.ofstate "
					+ "FROM user u, hashtag h, tweet t "
					+ "WHERE h.hashtagname IN " + s 
					+ " AND h.tid = t.tid AND t.posting_user = u.screen_name "
					+ "GROUP BY u.screen_name HAVING COUNT( u.screen_name) = ? "
					+ "ORDER BY u.numFollowers DESC "
					+ "LIMIT ?;");


					for (int i = 0; i < hashtags.length; i++) {
						stmt.setString(i + 1, hashtags[i]);
					}
					stmt.setInt(hashtags.length + 1, hashtags.length);
					stmt.setInt(hashtags.length + 2, Integer.parseInt(request.getParameter("k")));
					rs = stmt.executeQuery();
					%>
					<tr>
						<th>screen_name</th>
						<th>ofstate</th>
					</tr>
					<%
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("screen_name") + "</td>");
						out.println("<td>" + rs.getString("ofstate") + "</td>");
						out.println("</tr>");
					}
					break;
				case "http://localhost:8080/project/q10.jsp":
					String[] states = request.getParameterValues("states");
					String s2 = "(";
					for (int i = 0; i < states.length - 1; i++) {
						s2 += "?, ";
					}
					s2 += "?)";
					stmt = conn.prepareStatement(
						
						"SELECT DISTINCT h.hashtagname, GROUP_CONCAT(DISTINCT u.ofstate) as states "
						+ "FROM user u "
						+ "INNER JOIN tweet t "
						+ "INNER JOIN hashtag h "
						+ "ON t.tid = h.tid "
						+ "ON u.screen_name = t.posting_user "
						+ "WHERE u.ofstate IN " + s2
						+ "AND t.posted_year = ? "
						+ "AND t.posted_month = ? "
						+ "GROUP BY h.hashtagname;");

					stmt.setInt(states.length + 1, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(states.length + 2, Integer.parseInt(request.getParameter("month")));
					for (int i = 0; i < states.length; i++) {
						stmt.setString(i + 1, states[i]);
					}
					rs = stmt.executeQuery();
					%>
					<tr>
						<th>hashtagname</th>
						<th>states</th>
					</tr>
					<%
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("hashtagname") + "</td>");
						out.println("<td>" + rs.getString("states") + "</td>");
						out.println("</tr>");
					}
					break;
				case "http://localhost:8080/project/q15.jsp":
					stmt = conn.prepareStatement(
						"SELECT u.screen_name, u.ofstate, l.url "
						+ "FROM user u "
						+ "INNER JOIN tweet t "
						+ "INNER JOIN url l "
						+ "WHERE u.screen_name = t.posting_user "
						+ "AND u.sub_category = ? "
						+ "AND l.tid = t.tid "
						+ "AND t.posted_year = ? "
						+ "AND t.posted_month = ?;");
					stmt.setString(1, request.getParameter("sub_category"));
					stmt.setInt(2, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(3, Integer.parseInt(request.getParameter("month")));
					rs = stmt.executeQuery();
					%>
					<tr>
						<th>screen_name</th>
						<th>ofstate</th>
						<th>url</th>
					</tr>
					<%
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("screen_name") + "</td>");
						out.println("<td>" + rs.getString("ofstate") + "</td>");
						out.println("<td>" + rs.getString("url") + "</td>");
						out.println("</tr>");
					}	
					break;
				case "http://localhost:8080/project/q23.jsp":
					String[] months = request.getParameter("months").split(",");
					String s3 = "(";
					for (int i = 0; i < months.length - 1; i++) {
						s3 += "?,";
					}
					s3 += "?)";
					stmt = conn.prepareStatement(
						"SELECT distinct h.hashtagname, COUNT(h.hashtagname) as cnt "
						+ "FROM hashtag h, user u, tweet t "
						+ "WHERE h.tid=t.tid "
						+ "AND t.posting_user = u.screen_name "
						+ "AND u.sub_category = ? "
						+ "AND t.posted_month IN " + s3
						+ " AND t.posted_year = ? "
						+ "GROUP BY (h.hashtagname) "
						+ "ORDER BY COUNT(h.hashtagname) DESC "
						+ "LIMIT ?;");
					stmt.setString(1, request.getParameter("sub_category"));
					for (int i = 0; i < months.length; i++) {
						stmt.setInt(i + 2, Integer.parseInt(months[i]));
					} 
					
					stmt.setInt(months.length + 2, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(months.length + 3, Integer.parseInt(request.getParameter("k")));
					rs = stmt.executeQuery();
					%>
					<tr>
						<th>hashtagname</th>
						<th>cnt</th>
					</tr>
					<%
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("hashtagname") + "</td>");
						out.println("<td>" + rs.getString("cnt") + "</td>");
						out.println("</tr>");
					}
					break;
				case "http://localhost:8080/project/q27.jsp":
					stmt = conn.prepareStatement(
							"SELECT DISTINCT posting_user, posted, SUM(retweet_count) sum "
							+ "FROM tweet "
							+ "WHERE posted_year = ? "
							+ "AND posted_month = ? "
							+ "GROUP BY posting_user "
							+ "UNION "
							+ "SELECT posting_user, posted, SUM(retweet_count) sum "
							+ "FROM tweet "
							+ "WHERE posted_year = ? "
							+ "AND posted_month = ? "
							+ "GROUP BY posting_user "
							+ "ORDER BY sum DESC "
							+ "LIMIT ?;");
					stmt.setInt(1, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(2, Integer.parseInt(request.getParameter("month1")));
					stmt.setInt(3, Integer.parseInt(request.getParameter("year")));
					stmt.setInt(4, Integer.parseInt(request.getParameter("month2")));
					stmt.setInt(5, Integer.parseInt(request.getParameter("k")));
					rs = stmt.executeQuery();
					%>
							<tr>
								<th>posting_user</th>
								<th>posted</th>
								<th>sum</th>
							</tr>
					<%
					while (rs.next()) {
						out.println("<tr>");
						out.println("<td>" + rs.getString("posting_user") + "</td>");
						out.println("<td>" + rs.getString("posted") + "</td>");
						out.println("<td>" + rs.getString("sum") + "</td>");
						out.println("</tr>");
					}
					break;
				
			}
		} catch (SQLException e) {
			out.println("An exception occurred: " + e.getMessage());
		} finally {
			if (rs!= null) rs.close();
			if (stmt!= null) stmt.close();
			if (conn != null) conn.close();
		}
	%>
	</table>
	<br/><br/>
	
	<button type="button" name="back" onclick="history.back()">Back to query</button>
</body>
</html>