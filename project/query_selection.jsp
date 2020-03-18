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
<title>Query Selection</title>
</head>
<body>

  <% 

		boolean loginFailure = false;
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    //if user input recieved, attempt to login
    if (username != null  && password != null) {

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

      //
      try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(db_url, db_user, db_pswd);   
        
        //checks username and password against db
        stmt = conn.prepareStatement("SELECT * FROM db_user WHERE user_name = ? AND password = SHA1(?)");
        stmt.setString(1, username);
        stmt.setString(2, password);
        rs = stmt.executeQuery();

        //set authentication and adminstrator privileges
        if (rs.next()) {
          session.setAttribute("authenticated", true);
          session.setAttribute("Admin", rs.getString("admin_status").equals("1"));
        }
        else { //else login failed
          loginFailure = true;
        }
            
      } catch (SQLException e) {
              out.println("An exception occurred: " + e.getMessage());
              
      } finally {
        //close resources
        if (conn != null) conn.close();
        if(stmt != null) stmt.close();
        if(rs != null) rs.close();
      }
  }
  
	//if invalid username or password, simply redirects back to login 
  if (loginFailure) {
    response.sendRedirect("login.jsp");
    
  }
		
	%>
  
	<h1>Select a query to run</h1>
	<%
        Connection conn = null;
        ResultSet rs = null;
        boolean isAdmin = true;
        isAdmin = (boolean)session.getAttribute("Admin"); //gets admin status

        session.setAttribute("username", request.getParameter("username"));
        session.setAttribute("password", request.getParameter("password"));

		try {
      //get connection
      Class.forName("com.mysql.jdbc.Driver");
      conn = DriverManager.getConnection(db_url, db_user, db_pswd);
      
    %>
    <form> 
        <a href="q1.jsp">Q1: Most influential tweets for a given time</a><br><br>
        <a href="q2.jsp">Q2: Most influential users for given hashtags</a><br><br>
        <a href="q3.jsp">Q3: Most widespread hashtags</a><br><br>
        <a href="q6.jsp">Q6: Users with similar interests</a><br><br>
        <a href="q10.jsp">Q10: Common interest among users in given states</a><br><br>
        <a href="q15.jsp">Q15: URLs shared by given party</a><br><br>
        <a href="q23.jsp">Q23: Most used hashtags</a><br><br>
        <a href="q27.jsp">Q27: Most influential users for given time</a>
    </form>
  <%
      //if admin, shows options to insert and delete users. If not admin, this will not be viewable
      if (isAdmin) {
        %>
          <h1>Admin tools</h1>
          <a href="insert_user.jsp">Insert user</a><br><br>
          <a href="delete_user.jsp">Delete user</a>
        <%
      }
		} catch (SQLException e) {
            out.println("An exception occurred: " + e.getMessage());
            response.sendRedirect("login.jsp");
		} finally {
      //close resources
			if (conn != null) conn.close();
		}
	%>
</body>
</html>