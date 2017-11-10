<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<%
HttpSession this_session = request.getSession();
if(this_session.getAttribute("loginSuccess") == null || !(boolean)this_session.getAttribute("loginSuccess"))
{
	this_session.setAttribute("loginSuccess", false);
	response.sendRedirect("/BrickBreakerMovies/index.jsp");
	return;
}
%>
<html>
<title>BrickBreaker Movies</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<style>
h0 {font-size: 55px;}
</style>
<body>
	<header class="w3-container w3-cyan">
		<div class="w3-transparent w3-left w3-xxlarge">
			<h0 class="w3-opacity">
			<b><a href="/BrickBreakerMovies/MainPage.jsp">BrickBreaker Movies</a></b></h0>
		</div>
		<div class="w3-container w3-transparent w3-right">
			<form action="/BrickBreakerMovies/MovieList.jsp" method="GET">
				<h5>Title: </h5>&nbsp<input type="TEXT" id="userInput" autocomplete="off" oninput="inputUpdated()" name="title">
				<INPUT TYPE="SUBMIT" VALUE="Search">
			</form>
			<div id="SuggestionBox" style="position:relative; top:-15; left:5; visibility:hidden; z-index:2; width:0; height:0"></div>
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
			<a href="/BrickBreakerMovies/AdvancedSearch.jsp">Advanced Search</a>&nbsp
			<a href="/BrickBreakerMovies/ShoppingCart.jsp">My Cart</a>&nbsp
			<a href="/BrickBreakerMovies/Checkout.jsp">Checkout</a>&nbsp
			<a href="/BrickBreakerMovies/index.jsp?out=true">Sign Out</a>
		</div>
	</header>
	
		<%
			String loginUser = "mytestuser";
			String loginPassword = "mypassword";
			String loginUrl = "jdbc:mysql://localhost:3306/moviedb";
			
			response.setContentType("text/html");
			
			Class.forName("com.mysql.jdbc.Driver").newInstance();

			Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPassword);

			Statement statement = dbcon.createStatement();
			Statement g_statement = dbcon.createStatement();
			Statement s_statement = dbcon.createStatement();
				
			String id = request.getParameter("id");
			
			
			if(id == null)
			{
				response.sendRedirect("/BrickBreakerMovies/MovieError.html");
				return;
			}

			ResultSet rs;
			String count_query = "SELECT count(*) from movies where id=" + id;
			String query = "SELECT * from movies where id=" + id;
			
			rs = statement.executeQuery(count_query);
			rs.next();
			if(rs.getInt(1) == 0)
			{
				response.sendRedirect("/BrickBreakerMovies/MovieError.html");
				return;
			}
			
			rs.close();
			rs = statement.executeQuery(query);
			rs.next();
			
			String title = rs.getString("title");
			int year = rs.getInt("year");
			String director = rs.getString("director");
			String banner_url = rs.getString("banner_url");
			String trailer_url = rs.getString("trailer_url");
			
			String genre_query = "SELECT * FROM genres where id in (SELECT genre_id FROM genres_in_movies where movie_id=" + id + ");";
			String star_query = "SELECT * FROM stars where id IN (SELECT star_id FROM stars_in_movies WHERE movie_id=" + id + ");";
			
			rs.close();
			
			
			ResultSet g_rs = g_statement.executeQuery("SELECT * FROM genres where id in (SELECT genre_id FROM genres_in_movies where movie_id=" + id + ");");
			ResultSet s_rs = s_statement.executeQuery("SELECT * FROM stars where id IN (SELECT star_id FROM stars_in_movies WHERE movie_id=" + id + ");");
				
		%>
		
		<br><br>
		
		<div class="w3-container w3-left">
		
			<a href="/BrickBreakerMovies/MoviePage.jsp?id=<%out.println(id);%>"><img src=<%out.println(banner_url);%> width=250 height=350 title=<%out.println(title);%> alt=<%out.println(title);%>></a>
		</div>&nbsp
		<br>
		<br>
		
		<div class="w3-container w3-left">
			<h2><%out.print("<a href=/BrickBreakerMovies/MoviePage.jsp?id=" + id + ">" + title + "</a></td>");%></h2><br>
			Year: <%out.println(year);%><br><br>
			ID: <%out.print(id);%><br><br>
			Director: <%out.print(director);%><br><br>
			Genres: <%
			while(g_rs.next())
			{
				out.print("<a href=/BrickBreakerMovies/MovieList.jsp?genre=" + g_rs.getString("name") + ">" + g_rs.getString("name") + "</a>");
				
				if(!g_rs.isLast())
					out.println(", ");
			}
			%><br><br>
			Stars: <%
			while(s_rs.next())
			{
				out.print("<a href=/BrickBreakerMovies/StarPage.jsp?id=" + s_rs.getInt("id") + ">" + s_rs.getString("first_name") + " " + s_rs.getString("last_name") + "</a>");
				
				if(!s_rs.isLast())
					out.println(", ");
			}
			%>
		</div>
		
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<br>
		<div class="w3-row">
				<div class="w3-col s6 w3-transparent w3-center">
				<form action="/BrickBreakerMovies/ShoppingCart.jsp?id=<%out.println(id);%>&add=true" method="post">
					&nbsp&nbsp&nbsp<button type="submit" class="btn-link">Add to Cart</button>
				</form>&nbsp
					<a href="<%out.print(trailer_url);%>">Click Here for Trailer</a>
			</div>
		</div>
			

	</body>
</html>