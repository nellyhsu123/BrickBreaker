<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<%
if(session.getAttribute("loginSuccess") == null || !(boolean)session.getAttribute("loginSuccess"))
{
	session.setAttribute("loginSuccess", false);
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
			Statement movie_statement = dbcon.createStatement();
				
			String id = request.getParameter("id");
			
			
			if(id == null)
			{
				response.sendRedirect("/BrickBreakerMovies/StarError.html");
				return;
			}

			ResultSet rs;
			String count_query = "SELECT count(*) from stars where id=" + id;
			String query = "SELECT * from stars where id=" + id;
			
			rs = statement.executeQuery(count_query);
			rs.next();
			if(rs.getInt(1) == 0)
			{
				response.sendRedirect("/BrickBreakerMovies/StarError.html");
				return;
			}
			
			rs.close();
			rs = statement.executeQuery(query);
			rs.next();
			
			String name = rs.getString("first_name") + " " + rs.getString("last_name");
			String dob = rs.getString("dob");
			String photo_url = rs.getString("photo_url");
			
			String movie_query = "SELECT * from movies where id in (SELECT movie_id FROM stars_in_movies WHERE star_id=" + id + ");";
			
			rs.close();
			
			ResultSet m_rs = movie_statement.executeQuery(movie_query);
		%>
		
		<br><br>
		
		<div class="w3-container w3-left">
			<a href="/BrickBreakerMovies/StarPage.jsp?id=<%out.println(id);%>"><img src=<%out.println(photo_url);%> width=250 height=350 title="<%out.println(name);%>" alt="<%out.println(name);%>"></a>
		</div>
		<br>
		<br>
		
		<div class="w3-container w3-left">
			<h2><%out.print("<a href=/BrickBreakerMovies/StarPage.jsp?id=" + id + ">" + name + "</a></td>");%></h2><br>
			ID: <%out.print(id);%><br><br>
			Date of Birth: <%out.print(dob);%><br><br>
			Movies: <%
			while(m_rs.next())
			{
				out.print("<a href=/BrickBreakerMovies/MoviePage.jsp?id=" + m_rs.getInt("id") + ">" + m_rs.getString("title") + "</a>");
				
				if(!m_rs.isLast())
					out.println(", ");
			}
			%>
		</div>

	</body>
</html>