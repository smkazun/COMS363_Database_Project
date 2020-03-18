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
<title>Q23</title>
</head>
<body>
    <%
        //connections setup
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
    %>
    <form method="post" action="results.jsp">
        Sub category: <select name="sub_category">
            <%
            //gets all sub categories stored in the database and allows user to select them from dropdown menu
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(db_url, db_user, db_pswd);

                //execute query
                stmt = conn.prepareStatement("SELECT DISTINCT sub_category FROM user;");
                rs = stmt.executeQuery();
                while (rs.next()) {
                    out.println("<option value=\"" + rs.getString("sub_category") + "\">" + rs.getString("sub_category") + "</option>");
                }
            } catch (SQLException e) {
                out.println("An exception occurred: " + e.getMessage());
            } finally {
                //close resources
                if (rs!= null) rs.close();
                if (stmt!= null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
        </select>
        <br><br>
        Number of hashtags: <input type="number" name="k">
        <br><br>
        List of months (e.g., 1,2,3) (no spaces): <input type="text" name="months">
        <br><br>
        Year: <input type="number" name="year">
        <br><br>
        <input type="submit" value="Execute">
    </form>
    <%
        // Do query
    %>
</body>

</html>