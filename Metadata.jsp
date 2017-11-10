<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.HashMap,
 java.util.Iterator,
 java.util.Map"
%>

<%
	HttpSession this_session = request.getSession();
	
	String loginUser = "mytestuser";
	String loginPassword = "mypassword";
	String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

	response.setContentType("text/html");

	Class.forName("com.mysql.jdbc.Driver").newInstance();

	Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPassword);

	Statement statement = dbcon.createStatement();
		
    String email = request.getParameter("email");
	String password = request.getParameter("password");
	String count_query = "SELECT count(*) from employees where email = '" + email + "' AND password = '" + password + "';";
	
	ResultSet rs = statement.executeQuery(count_query);
	rs.next();
	
	if(this_session.getAttribute("empLoginSuccess") == null)
		this_session.setAttribute("empLoginSuccess", false);
	
	if(rs.getInt(1) == 0 && !(boolean)this_session.getAttribute("empLoginSuccess"))
	{
		rs.close();
		this_session.setAttribute("empLoginSuccess", false);
				
		response.sendRedirect("/BrickBreakerMovies/_dashboard.jsp?er=true");
	}
	else
	{
		rs.close();

		this_session.setAttribute("empLoginSuccess", true);
%>

<html>
<title>BrickBreaker Movies</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<style>
h0 {font-size: 85px;}
hr {
	color: #000000;
	height: 3px;
}
</style>
<body>
	<header class="w3-container w3-cyan">
		<div class="w3-transparent w3-center w3-jumbo">
			<h0 class="w3-opacity">
			<b><a href="/BrickBreakerMovies/EmployeeDashboard.jsp">Employee Dashboard</a></b></h0>
		</div>
		<div class="w3-container w3-transparent w3-right">
			<a href="/BrickBreakerMovies/_dashboard.jsp?out=true">Sign Out</a>
		</div>
	</header>
	<div class="w3-container w3-light-gray">
		<%
			HashMap<String, HashMap<String, String>> tableInfo = new HashMap<String, HashMap<String, String>>();
			
			rs = statement.executeQuery("show tables;");
		
			while(rs.next())
			{
				DatabaseMetaData databaseMetaData = dbcon.getMetaData();
				ResultSet tableColumns = databaseMetaData.getColumns(null, "moviedb", rs.getString(1), "%");
				
				tableInfo.put(rs.getString(1), new HashMap<String, String>());
				while(tableColumns.next())
				{
					tableInfo.get(rs.getString(1)).put(tableColumns.getString(4), tableColumns.getString(6));
				}

			}
			
			Iterator it = tableInfo.entrySet().iterator();
			while (it.hasNext())
			{
				Map.Entry pair = (Map.Entry)it.next();

		%>
		
				<TABLE border>
					<tr>
						  <td><%out.print(pair.getKey());%></td>
						  <td></td>
					</tr>
		
			<%
				
				Iterator it2 = ((HashMap<String, HashMap<String, String>>) pair.getValue()).entrySet().iterator();
				while(it2.hasNext())
				{
					Map.Entry pair2 = (Map.Entry)it2.next();
			%>
					<tr>
						  <td><%out.print((String)pair2.getKey());%></td>
						  <td><%out.print((String)pair2.getValue());%></td>
					</tr>
			<%
					it2.remove();
				}
			%>
				</TABLE>
				<br><br>
			<%
				it.remove();
			}
			
		%>
	</div>
			
	
</body>
</html>
	
<%
	}
%>