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
	<title>Insert user</title>
</head>
<body>
	<h1>Insert user</h1>

    <form method="post" action="">
        screen_name: <input type="text" name="screen_name">
        <br><br>
        name: <input type="text" name="name">
        <br><br>
        sub_category: <input name="sub_category">
        <br><br>
        category: <input type="text" name="category">
        <br><br>
        ofstate: <select name="states">
                <option value="AL">Alabama</option>
                <option value="AK">Alaska</option>
                <option value="AZ">Arizona</option>
                <option value="AR">Arkansas</option>
                <option value="CA">California</option>
                <option value="CO">Colorado</option>
                <option value="CT">Connecticut</option>
                <option value="DE">Delaware</option>
                <option value="DC">District of Columbia</option>
                <option value="FL">Florida</option>
                <option value="GA">Georgia</option>
                <option value="HI">Hawaii</option>
                <option value="ID">Idaho</option>
                <option value="IL">Illinois</option>
                <option value="IN">Indiana</option>
                <option value="IA">Iowa</option>
                <option value="KS">Kansas</option>
                <option value="KY">Kentucky</option>
                <option value="LA">Louisiana</option>
                <option value="ME">Maine</option>
                <option value="MD">Maryland</option>
                <option value="MA">Massachusetts</option>
                <option value="MI">Michigan</option>
                <option value="MN">Minnesota</option>
                <option value="MS">Mississippi</option>
                <option value="MO">Missouri</option>
                <option value="MT">Montana</option>
                <option value="NE">Nebraska</option>
                <option value="NV">Nevada</option>
                <option value="NH">New Hampshire</option>
                <option value="NJ">New Jersey</option>
                <option value="NM">New Mexico</option>
                <option value="NY">New York</option>
                <option value="NC">North Carolina</option>
                <option value="ND">North Dakota</option>
                <option value="OH">Ohio</option>
                <option value="OK">Oklahoma</option>
                <option value="OR">Oregon</option>
                <option value="PA">Pennsylvania</option>
                <option value="RI">Rhode Island</option>
                <option value="SC">South Carolina</option>
                <option value="SD">South Dakota</option>
                <option value="TN">Tennessee</option>
                <option value="TX">Texas</option>
                <option value="UT">Utah</option>
                <option value="VT">Vermont</option>
                <option value="VA">Virginia</option>
                <option value="WA">Washington</option>
                <option value="WV">West Virginia</option>
                <option value="WI">Wisconsin</option>
                <option value="WY">Wyoming</option>
              </select> 
        <br><br>
        numFollowers: <input type="text" name="numFollowers">
        <br><br>
        numFollowing: <input type="text" name="numFollowing">
        <br><br>
        <input type="submit" value="Submit">
    </form>
	
	<br><br>
	<button type="button" name="back" onclick="history.back()">Back to query</button>

  <%
          //connection setup
          Connection conn = null;
          Statement stmt = null;
          ResultSet rs = null;

          //get user input
          String screen_name = request.getParameter("screen_name");
          String name = request.getParameter("name");
          String sub_category = request.getParameter("sub_category");
          String category = request.getParameter("category");
          String ofstate = request.getParameter("states");
          String numFollowers = request.getParameter("numFollowers");
          String numFollowing = request.getParameter("numFollowing");
    
    //if user input recieved, attempt to insert into db
    if(screen_name != null && name != null && sub_category != null && category != null && ofstate != null && numFollowers != null && numFollowing != null){
          try {
              //get connection
              Class.forName("com.mysql.jdbc.Driver");
              conn = DriverManager.getConnection(db_url, db_user, db_pswd);

              //execute insertion
              stmt = conn.createStatement();
              String sql = "INSERT INTO user(screen_name, name, sub_category, category, ofstate, numFollowers, numFollowing) "+
                            "VALUES('" + screen_name +"','" + name +"','" + sub_category + "','" + category +"','" +
                            ofstate + "','" + numFollowers + "','" + numFollowing + "')";
              Integer result = stmt.executeUpdate(sql);
              if(result == 1){
                out.println("user added");
              }
              else{
                out.println("error occured");
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