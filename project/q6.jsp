<%-- 
  - Author(s): Grayson Cox
  - Date: April 27, 2019
  --%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ include file="./db_info.jsp"%>
<html>
<head>
<title>Q6</title>
</head>
<body>
    <form method="post" action="results.jsp">
        Number of users: <input type="number" name="k">
        <br><br>
        Hashtags (Separated by commas): <input type="text" name="hashtags">
        <br><br>
        <input type="submit" value="Execute">
    </form>
</body>

</html>