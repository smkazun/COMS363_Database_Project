<%-- 
  - Author(s): Grayson Cox, Sebastian Kazun
  - Date: April 27, 2019
  --%>
<%@ page language="java" contentType="text/html"%>

<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.*" %>

<%@ include file="./db_info.jsp"%>
<!-- any error is redirected to ShowError.jsp -->
<%@ page errorPage="ShowError.jsp"%>
  
  

<!DOCTYPE html>
<html>
<head>
<meta charset = "ISO-8859-1">
  <title>Login</title>
</head>

<!-- The login page. JSP starts in query_selection.jsp -->
<body>
    <form method="post" action="query_selection.jsp">
        Username: <input type="text" name="username">
        <br><br>
        Password: <input type="password" name="password">
        <br><br>
        <input type="submit" value="Login">
    </form>

</body>
</html>