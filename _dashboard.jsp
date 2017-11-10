<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<%
HttpSession this_session = request.getSession();
session.setAttribute("empLoginSuccess", false);
%>
<html>
<title>BrickBreaker Movies: Dashboard</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<style>
h0 {font-size: 55px;}
</style>
<body>
	<header class="w3-container w3-cyan">
		<div class="w3-transparent w3-center w3-xxlarge">
			<h0 class="w3-opacity"><b>BrickBreaker Movies</b></h0>
			<br>
			<h4 class="w3-opacity"><b>Employee Login</b></h4>
		</div>
		<div class="w3-container w3-transparent w3-right">
				<a href="/BrickBreakerMovies">Customer Login</a>
		</div>
	</header>
		
	<div class="w3-container w3-light-gray">
		<br>
		<%if(request.getParameter("er") != null && request.getParameter("er").equals("true"))
			out.println("<center><h6 style=color:red>Failed to login. Please try again</h6></center>");
		else if(request.getParameter("out") != null && request.getParameter("out").equals("true"))
		{
			out.println("<center><h6 style=color:red>Logout Successful</h6></center>");
			session.invalidate();
		}
		else
			out.println("<br>");
		%>
		<br>
		<center>
		<div class="w3-panel w3-orange w3-card-4 w3-round-xlarge w3-center" style="width:92%;max-width:800px;">
		<br>
			<form action="/BrickBreakerMovies/EmployeeDashboard.jsp"
				  method="POST">
				<center>
					Email: <input type="TEXT" name="email"><br><br>

					Password: <input type="PASSWORD" name="password">
					<br>
					<br>
					<input type="SUBMIT" value="Login">
				</center>
			</form>
		</div>
		</center>
	</div>

</body>
</html>
