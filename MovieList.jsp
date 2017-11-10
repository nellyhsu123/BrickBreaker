<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<%
if(session.getAttribute("loginSuccess") == null || !(boolean)session.getAttribute("loginSuccess"))
{
	session.setAttribute("loginSuccess", false);
	response.sendRedirect("/BrickBreakerMovies/index.jsp");
}
else
{
%>
<html>
<title>BrickBreaker Movies</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<style>
h0 {font-size: 55px;}
hr {
	color: #000000;
	height: 3px;
}
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
		int page_num;
		int page_size;
		// page_num * page_size = offset
		
		StringBuffer url_no_pg = request.getRequestURL().append("?");
		
		//System.out.println(page_num);
		
		if(request.getParameter("pg") == null)  // sets the page number
		{
			page_num = 1;
		}
		else
		{
			page_num = Integer.parseInt(request.getParameter("pg"));
		}
		
		if(request.getParameter("sz") == null) // sets the offset for the page size
		{
			page_size = 10;
		}
		else
		{
			page_size = Integer.parseInt(request.getParameter("sz"));
		}
		
		response.setContentType("text/html");
		
		Class.forName("com.mysql.jdbc.Driver").newInstance();

		Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPassword);

		Statement statement = dbcon.createStatement();
		Statement g_statement = dbcon.createStatement();
		Statement s_statement = dbcon.createStatement();
			
		String title = request.getParameter("title");
		String genre = request.getParameter("genre");
		String begins_with = request.getParameter("begins_with");
		String year = request.getParameter("year");
		String director = request.getParameter("director");
		String actor_name = request.getParameter("name");
		String sort = request.getParameter("sort");
		String sort_order = request.getParameter("order");
		
		if(sort == null)
		{
			sort = "title";
		}
		
		if(sort_order == null)
		{
			sort_order = "ASC";
		}
		
		int movie_count = 0;
		ArrayList<String> queries = new ArrayList<String>();
		String count_query = "SELECT count(*) from movies WHERE ";
		String query = "SELECT * from movies WHERE ";
		ResultSet rs;
		
		if(title != null && year != null && director != null && actor_name != null)
		{
			if(title.equals("") && year.equals("") && director.equals("") && actor_name.equals(""))
			{
				response.sendRedirect("/BrickBreakerMovies/MovieError.html");
				return;
			}
		}
		if(title != null || year != null || director != null || actor_name != null)
		{
			if(title != null)
			{
				url_no_pg.append("title=" + title);
				if(!title.equals(""))
				{
					String[] temp_title = title.split(" ");
					String query_string = "";
					for(int i = 0; i < temp_title.length; ++i)
					{
						query_string += "+" + temp_title[i] + "* ";
					}
					queries.add("SELECT id FROM movies WHERE MATCH (title) AGAINST (\"" + query_string + "\" IN BOOLEAN MODE)");
				}
				else if(genre == null && begins_with == null && year == null && director == null && actor_name == null)
				{
					queries.add("SELECT id FROM movies");
				}
			}
			if(year != null && !year.equals(""))
			{
				url_no_pg.append("&year=" + year);
				queries.add("SELECT id FROM movies WHERE year like \"" + year + "%\"");
			}
			if(director != null && !director.equals(""))
			{
				url_no_pg.append("&director=" + director);
				String[] temp_dir = director.split(" ");
				String query_string = "";
				for(int i = 0; i < temp_dir.length; ++i)
				{
					query_string += "+" + temp_dir[i] + "* ";
				}
				queries.add("SELECT id FROM movies WHERE MATCH (director) AGAINST (\"" + query_string + "\" IN BOOLEAN MODE)");
			}
			if(actor_name != null && !actor_name.equals(""))
			{
				url_no_pg.append("&name=" + actor_name);
				String[] temp_actor = actor_name.split(" ");
				String query_string = "";
				for(int i = 0; i < temp_actor.length; ++i)
				{
					query_string += "+" + temp_actor[i] + "* ";
				}
				queries.add("SELECT id FROM movies WHERE id IN (SELECT movie_id FROM stars_in_movies WHERE MATCH(name) AGAINST (\"" + query_string + "\" IN BOOLEAN MODE)");
			}
		}
		else if (genre != null)
		{
			url_no_pg.append("&genre=" + genre);
			System.out.println("CHECK THIS:" + genre);
			
			queries.add("SELECT movie_id FROM genres_in_movies WHERE genre_id IN (SELECT id FROM genres WHERE name=\"" + genre + "\")");
		}
		else if(begins_with != null)
		{
			url_no_pg.append("&begins_with=" + begins_with);
			
			queries.add("SELECT id FROM movies where title like \"" + begins_with + "%\"");
		}
		else
		{
			response.sendRedirect("/BrickBreakerMovies/SearchError.html");
			return;
		}
		////////////////////////////////////////////////////////////////////////////////////
		
		queries.trimToSize();
		String query_input = "";
		for(int i = 0; i < queries.size(); ++i)
		{
			if(i != 0)
				query_input += " and ";
			query_input += "movies.id IN (" + queries.get(i) + ")";
		}
		System.out.println(count_query + query_input + ";");
		
		rs = statement.executeQuery(count_query + query_input + ";");
		rs.next();
		movie_count = rs.getInt(1);
		rs.close();
		
		if(movie_count == 0)
		{
			response.sendRedirect("/BrickBreakerMovies/MovieError.html");
			return;
		}
		
		query_input += " ORDER BY " + sort + " " + sort_order;
		
		query_input += " LIMIT " + page_size + " OFFSET " + ((page_num-1)*page_size) + ";";
		
		rs = statement.executeQuery(query + query_input);
		%>
		
		<div class="w3-container w3-light-gray">
			<br>
			<div class="w3-container w3-transparent w3-left w3-xxlarge">
				<h2>Results</h2>
			</div>
			<br>
			<div class="w3-container w3-transparent w3-right">
			
				<div class="w3-dropdown-hover">
					<button class="w3-button w3-black">Results per page</button>
					<div class="w3-dropdown-content w3-bar-block w3-border">
						<a href=<%out.println(url_no_pg.toString() + "&pg=1" + "&sz=" + 10 + "&sort=" + sort + "&order=" + sort_order);%> class="w3-bar-item w3-button">10</a><br>
						<a href=<%out.println(url_no_pg.toString() + "&pg=1" + "&sz=" + 20 + "&sort=" + sort + "&order=" + sort_order);%> class="w3-bar-item w3-button">20</a><br>
						<a href=<%out.println(url_no_pg.toString() + "&pg=1" + "&sz=" + 30 + "&sort=" + sort + "&order=" + sort_order);%> class="w3-bar-item w3-button">30</a><br>
					</div>
				</div>
			</div>
			
			<div class="w3-container w3-transparent w3-right">
			
				<div class="w3-dropdown-hover">
					<button class="w3-button w3-black">Sort</button>
					<div class="w3-dropdown-content w3-bar-block w3-border">
						<a href=<%out.println(url_no_pg.toString() + "&pg=1" + "&sz=" + page_size + "&sort=title" + "&order=ASC");%> class="w3-bar-item w3-button">Title &#x25B2</a><br>
						<a href=<%out.println(url_no_pg.toString() + "&pg=1" + "&sz=" + page_size + "&sort=title" + "&order=DESC");%> class="w3-bar-item w3-button">Title &#x25BC</a><br>
						<a href=<%out.println(url_no_pg.toString() + "&pg=1" + "&sz=" + page_size + "&sort=year" + "&order=ASC");%> class="w3-bar-item w3-button">Year &#x25B2</a><br>
						<a href=<%out.println(url_no_pg.toString() + "&pg=1" + "&sz=" + page_size + "&sort=year" + "&order=DESC");%> class="w3-bar-item w3-button">Year &#x25BC</a><br>
					</div>
				</div>
			</div>
			<br>
			<br>
			<br>
			<center>
			<hr noshade>
			<script>
				function hidePopup(num)
				{
					var temp = "popUp";
					temp = temp.concat(num);
					document.getElementById(temp).style.visibility = "hidden";
					//document.getElementById(temp).innerHTML = "";
				}
				function showPopup(id, num)
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
							var temp = "popUp".concat(num);
							document.getElementById(temp).innerHTML = ajaxRequest.responseText;
							document.getElementById(temp).style.visibility = "visible";
						}
					}
					ajaxRequest.open("GET", ("/BrickBreakerMovies/servlet/MoviePopUp?id=" + id + "&num=" + num), true);
					ajaxRequest.send(null);
				}
			</script>
			<%
			int title_no = 0;
			while(rs.next())
			{
				++title_no;
				ResultSet g_rs = g_statement.executeQuery("SELECT * FROM genres where id in (SELECT genre_id FROM genres_in_movies where movie_id=" + rs.getInt("id") + ");");
				ResultSet s_rs = s_statement.executeQuery("SELECT * FROM stars where id IN (SELECT star_id FROM stars_in_movies WHERE movie_id=" + rs.getInt("id") + ");");
				%>
				<div class="w3-container">
					<div class="w3-container w3-left">
				
					<a href="/BrickBreakerMovies/MoviePage.jsp?id=<%out.println(rs.getInt("id"));%>"><img src=<%out.println(rs.getString("banner_url"));%> width=250 height=350 title="<%out.println(rs.getString("title"));%>" alt="<%out.println(rs.getString("title"));%>"></a>
					</div>
					
					<div class="w3-container w3-left" style="text-align:left">
						<div style="padding:0px 0px 0px 0px;">
							<h2><a onmouseenter="showPopup(<%out.print(rs.getInt("id") + ", " + title_no);%>)" href=/BrickBreakerMovies/MoviePage.jsp?id=<%out.print(rs.getInt("id") + ">" + rs.getString("title"));%></a></td></h2><br>
						</div>
						<div id="popUp<%out.print(title_no);%>" class="w3-container w3-orange" style="position:relative; top:-15; left:5; visibility:hidden; z-index:2; width:0; height:0"><h0><b>TEST</b></h0></div>
						Year: <%out.println(rs.getInt("year"));%><br><br>
						ID: <%out.print(rs.getInt("id"));%><br><br>
						Director: <%out.print(rs.getString("director"));%><br><br>
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
						<br><br>
						<form action="/BrickBreakerMovies/ShoppingCart.jsp?id=<%out.println(rs.getInt("id"));%>&add=true" method="post">
							<button type="submit" class="btn-link">Add to Cart</button>
						</form>
					</div>
				
				</div>
				
				<br>
				<hr noshade>
			
				<%
			}
			%>
			
			</center>
			
			<div><BR>
				<CENTER>
					<H4>Page:</H4>
					<%
					if(page_num > 1)
					{
						out.println("<a href='" + url_no_pg.toString() + "&pg=" + (page_num-1) + "&sz=" + page_size + "&sort=" + sort + "&order=" + sort_order +"'>Prev</a>&nbsp&nbsp");
					}
				
					for(int i = 1; ((i-1)*page_size) < movie_count; ++i)
					{
						out.println("<a href='" + url_no_pg.toString() + "&pg=" + i + "&sz=" + page_size + "&sort=" + sort + "&order=" + sort_order +"'>" + i +"</a>&nbsp&nbsp");
					}
					
					if(page_num*page_size < movie_count)
					{
						out.println("<a href='" + url_no_pg.toString() + "&pg=" + (page_num+1) + "&sz=" + page_size + "&sort=" + sort + "&order=" + sort_order +"'>Next</a>");
					}
					%>
					
					</CENTER>
				
				</div>
				<br>
				<br>
				<br>
				<br>
			</div>

	</body>
</html>
	
<%
}
%>