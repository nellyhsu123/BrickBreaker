<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<%
HttpSession this_session = request.getSession();
this_session.setAttribute("loginSuccess", false);
%>
<html>
<title>BrickBreaker Movies: Login</title>
<script src='https://www.google.com/recaptcha/api.js'></script>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<style>
h0 {font-size: 55px;}
</style>
<body>
	<header class="w3-container w3-cyan">
		<div class="w3-transparent w3-center w3-xxlarge">
			<h0 class="w3-opacity"><b>BrickBreaker Movies</b></h0>
		</div>
		<div class="w3-container w3-transparent w3-right">
			<a href="/BrickBreakerMovies/_dashboard.jsp">Employee Login</a>
		</div>
	</header>
		
	<div class="w3-container w3-light-gray">
		<br>
		<%if(request.getParameter("er") != null && request.getParameter("er").equals("true"))
		{
			out.println("<center><h6 style=color:red>Failed to login. Please try again</h6></center>");
		}
		else if(request.getParameter("out") != null && request.getParameter("out").equals("true"))
		{
			out.println("<center><h6 style=color:red>Logout Successful</h6></center>");
			this_session.invalidate();
		}
		else
			out.println("<br>");
		%>
		<br>
		<br>
		<form action="/BrickBreakerMovies/servlet/RecaptchaProcessor"
			  method="POST">
			<center>
			<div class="w3-panel w3-orange w3-card-4 w3-round-xlarge w3-center" style="width:92%;max-width:800px;">
			<br>
				Email: <input type="TEXT" name="email"><br><br>

				Password: <input type="PASSWORD" name="password">
				<br>
				<br>
				<input type="SUBMIT" value="Login">
			</div>
			</center>
			<div class="g-recaptcha" data-sitekey="6Le8qSAUAAAAAJjRj54FXBpRWGHpRVkEp3d4671M"></div>
		</form>
	</div>

</body>
</html>
