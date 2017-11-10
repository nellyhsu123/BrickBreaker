<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
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
		<br>
		<%if(request.getParameter("s_added") != null)
		{
			if(request.getParameter("s_added").equals("false"))
			{
				out.println("<center><h6 style=color:red>Star already exists with that name or insert failed</h6></center>");
			}
			else if(request.getParameter("s_added").equals("true"))
			{
				out.println("<center><h6 style=color:red>Star successfully added</h6></center>");
			}
			else
			{
				out.println("<br>");
			}
		}
		else if(request.getParameter("m_added") != null)
		{
			if(request.getParameter("m_added").equals("true"))
			{
				out.println("<center><h6 style=color:red>Movie Successfully Added</h6></center>");
			}
			else if(request.getParameter("m_added").equals("false"))
			{
				out.println("<center><h6 style=color:red>Failed to Add Movie</h6></center>");
			}
			else
			{
				out.println("<br>");
			}
		}
		else
		{
			out.println("<br>");
		}
		%>
		<br>
		<div class="w3-content">
		<div class="w3-row-padding" style="margin:0 - 18px">
		<div class="w3-half">
			<div class="w3-panel w3-orange w3-card-4 w3-round-xlarge" style="width:92%;max-width:500px;">
				<h3><u>Insert a New Star</u></h3>
				<form action="/BrickBreakerMovies/servlet/InsertStar" method="POST">
					<p>
						<label class="w3-text-black">First Name:</label>
						<input type="TEXT" name="first_name" placeholder="John"><br>
					</p>
					<p>
						<label class="w3-text-black">Last Name:</label>
						<input type="TEXT" name="last_name" placeholder="Smith" required><br>
					</p>
					<p>
						<label class="w3-text-black">Date of Birth:</label>
						<input type="TEXT" name="dob" placeholder="Year/Month/Day"><br>
					</p>
					<p>
						<label class="w3-text-black">Photo URL:</label>
						<input type="TEXT" name="photo_url" placeholder="URL for Image"><br>
					</p>
						<center><input type="SUBMIT" value="Create"></center>
				</form>
			</div>
			
			<br>
			<center><a href="/BrickBreakerMovies/Metadata.jsp">Display Metadata</a></center>
			
		</div>
		
		<div class="w3-half">
			<div class="w3-panel w3-orange w3-card-4 w3-round-xlarge" style="width:92%;max-width:500px;">
				<h3><u>Insert a New Movie</u></h3>
				<form action="/BrickBreakerMovies/servlet/InsertMovie" method="POST">
					<p>
						<label class="w3-text-black">Title:</label>
						<input type="TEXT" name="title" placeholder="The Terminator" required><br>
					</p>
					<p>
						<label class="w3-text-black">Year:</label>
						<input type="TEXT" name="year" placeholder="1984" required><br>
					</p>
					<p>
						<label class="w3-text-black">Director:</label>
						<input type="TEXT" name="dir" placeholder="James Cameron" required><br>
					</p>
					<p>
						<label class="w3-text-black">Banner URL:</label>
						<input type="TEXT" name="banner_url" placeholder="URL for Image" required><br>
					</p>
					<p>
						<label class="w3-text-black">Trailer URL:</label>
						<input type="TEXT" name="trailer_url" placeholder="URL for Trailer" required><br>
					</p>
					<p>
						<label class="w3-text-black">Primary Star:</label><br>
						<p>
							<label class="w3-text-black">First Name:</label>
							<input type="TEXT" name="star_first" placeholder="John"><br>
						</p>
						<p>
							<label class="w3-text-black">Last Name:</label>
							<input type="TEXT" name="star_last" placeholder="Smith" required><br>
						</p>
						<p>
							<label class="w3-text-black">Date of Birth:</label>
							<input type="TEXT" name="dob" placeholder="Year/Month/Day"><br>
						</p>
						<p>
							<label class="w3-text-black">Photo URL:</label>
							<input type="TEXT" name="photo_url" placeholder="URL for Image"><br>
						</p>
					</p>
					<p>
						<label class="w3-text-black">Primary Genre:</label>
						<input type="TEXT" name="genre" placeholder="Sci-Fi" required><br>
					</p>
					<center><input type="SUBMIT" value="Create"></center>
				</form>
			</div>
		</div>
		</div>
		</div>
			
	
</body>
</html>
	
<%
	}
%>