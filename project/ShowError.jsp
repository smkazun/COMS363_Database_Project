<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!--isErrorPage is important  -->
<%@ page isErrorPage="true"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Error</title>
</head>
<body>
	<p>An error has occured</p>
	<p>
		<%
			exception.printStackTrace(response.getWriter());
		%>
		
		<br />
		<form action="login.jsp">
		<input type="submit" value="BACK" />
	</form>
	</p>
</body>
</html>