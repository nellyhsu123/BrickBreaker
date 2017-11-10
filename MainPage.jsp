<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<%
	if(session.getAttribute("loginSuccess") == null)
	{
		response.sendRedirect("/BrickBreakerMovies/index.jsp?out=true");
		return;
	}
		
	if(session.getAttribute("loginSuccess") == null || !(boolean)session.getAttribute("loginSuccess"))
	{
		session.setAttribute("loginSuccess", false);
		response.sendRedirect("/BrickBreakerMovies/index.jsp?out=true");
		return;
	}
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
	String count_query = "SELECT count(*) from customers where email = '" + email + "' AND password = '" + password + "';";
	String query = "SELECT * from customers where email = '" + email + "' AND password = '" + password + "';";
	
	ResultSet rs = statement.executeQuery(count_query);
	rs.next();
	
	if(rs.getInt(1) != 0)
	{
		rs.close();
		rs = statement.executeQuery(query);
		rs.next();
		request.getSession().setAttribute("email", email);
		request.getSession().setAttribute("name", rs.getString("first_name"));
		request.getSession().setAttribute("id", rs.getInt("id"));
	}
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
			<b><a href="/BrickBreakerMovies/MainPage.jsp">BrickBreaker Movies</a></b></h0>
		</div>
		<div class="w3-container w3-transparent w3-right">
			<a href="/BrickBreakerMovies/ShoppingCart.jsp">My Cart</a>&nbsp
			<a href="/BrickBreakerMovies/Checkout.jsp">Checkout</a>&nbsp
			<a href="/BrickBreakerMovies/index.jsp?out=true">Sign Out</a>
		</div>
	</header>
	<div class="w3-container w3-light-gray">
		<br><br>
		<center>
		<form name = "TitleInput" action="/BrickBreakerMovies/MovieList.jsp" method="GET">
			Title: <input type="TEXT" id="userInput" autocomplete="off" oninput="inputUpdated()" name="title">
			<input type="IMAGE" src="https://cdn.pixabay.com/photo/2013/10/01/16/55/magnifying-glass-189254_960_720.png" alt="Search" style="width:20px;height:20px;"/>
		</form>
		<div id="SuggestionBox" style="position:relative; top:-15; left:-95; visibility:hidden; z-index:2; width:0; height:0"></div>
		<script>
		function inputUpdated()
		{
			var input = document.getElementById("userInput").value;
			if(input.length > 0)
			{
				var ajaxRequest;  // The variable that makes Ajax possible!
				try{
					// Opera 8.0+, Firefox, Safari
					ajaxRequest = new XMLHttpRequest();
				} catch (e){
					// Internet Explorer Browsers
					try{
						ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
					} catch (e) {
						try{
							ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e){
							// Something went wrong
							alert("Your browser broke!");
							return false;
						}
					}
				}
				// Create a function that will receive data sent from the server
				ajaxRequest.onreadystatechange = function(){
					if(ajaxRequest.readyState == 4){
						document.getElementById("SuggestionBox").innerHTML = ajaxRequest.responseText;
						document.getElementById("SuggestionBox").style.visibility = "visible";
					}
				}
				ajaxRequest.open("GET", ("/BrickBreakerMovies/servlet/SuggestionBox?input=" + input), true);
				ajaxRequest.send(null);
			}
			else
			{
				document.getElementById("SuggestionBox").style.visibility = "hidden";
				document.getElementById("SuggestionBox").innerHTML = "";
			}
		}
		</script>
		
		<div><a href="/BrickBreakerMovies/AdvancedSearch.jsp">Advanced Search</a></div>
		</center>
		<br><br><br><br>
		<footer class="w3-container w3-transparent">
			<center>
			<hr noshade>
			<h3>Browse by:</h3>
			<hr noshade>
			</center>
			<div class="w3-row">
				<div class="w3-col s6 w3-transparent w3-center">
					<h4><u>Title</u></h4>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=0">0</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=1">1</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=2">2</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=3">3</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=4">4</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=5">5</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=6">6</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=7">7</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=8">8</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=9">9</a><br>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=a">A</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=b">B</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=c">C</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=d">D</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=e">E</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=f">F</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=g">G</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=h">H</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=i">I</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=j">J</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=k">K</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=l">L</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=m">M</a><br>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=n">N</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=o">O</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=p">P</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=q">Q</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=r">R</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=s">S</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=t">T</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=u">U</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=v">V</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=w">W</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=x">X</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=y">Y</a>
					<a href="/BrickBreakerMovies/MovieList.jsp?begins_with=z">Z</a>
				</div>
				<div class="w3-col s6 w3-transparent w3-center">
					<h4>Genre</h4>
					<%
					rs = statement.executeQuery("SELECT name FROM genres ORDER BY name;");
					int i = 0;
					while(rs.next())
					{
							
						out.println("<a href=/BrickBreakerMovies/MovieList.jsp?genre=" + rs.getString(1).replace(' ', '+') + ">" + rs.getString(1) + "</a>&nbsp&nbsp&nbsp");
						if(i%4 == 3)
						{
							out.println("<BR>");
						}
						++i;
					}
					%>
				</div>
			</div>
		</footer>
	</div>

</body>
</html>