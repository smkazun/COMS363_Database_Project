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
	<title>Delete user</title>
</head>
<body>
	<h1>Delete user</h1>
    <form method="post" action="">
        screen_name: <input type="text" name="screen_name">
        <input type="submit" value="Submit">
    </form>
    <%
          //connection setup
          Connection conn = null;
          Statement stmt = null;
          ResultSet rs = null;

          //get user input
          String screen_name = request.getParameter("screen_name");
    
    //if user input recieved, attempt to delete from db
    if(screen_name != null){
          try {
              //get connection
              Class.forName("com.mysql.jdbc.Driver");
              conn = DriverManager.getConnection(db_url, db_user, db_pswd);

              //execute deletion
              stmt = conn.createStatement();
              String sql = "DELETE FROM user where user.screen_name = '"+ screen_name +"';";
              Integer result = stmt.executeUpdate(sql);

              if(result == 1){
                  out.println("user deleted");
              }
              else{
                  out.println("user could not be deleted");
              }

          } catch (SQLException e) {
              out.println("An exception occurred: " + e.getMessage());
          } finally {
              //close resources
              if (rs!= null) rs.close();
              if (stmt!= null) stmt.close();
              if (conn != null) conn.close();
          }
    }
  %>

</body>
</html>