<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<%
HttpSession this_session = request.getSession();
if(this_session.getAttribute("loginSuccess") == null || !(boolean)this_session.getAttribute("loginSuccess"))
{
	this_session.setAttribute("loginSuccess", false);
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
		ResultSet rs;
			
		String s_id = request.getParameter("id");
		String qty = request.getParameter("qty");
		String add = request.getParameter("add");
		int id = 0;
		
		HashMap<Integer, Integer> cart = (HashMap)this_session.getAttribute("cart");
		
		if(cart == null)
		{
			cart = new HashMap<Integer, Integer>();
			this_session.setAttribute("cart", cart);
		}
		
		if(s_id != null)
		{
			id = Integer.parseInt(s_id);
			if(qty != null)
				cart.put(id, Integer.parseInt(qty));
			else if(add != null && add.equals("true"))
			{
				if(cart.get(id) == null)
					cart.put(id, 0);
				cart.put(id, cart.get(id) + 1);
			}
			else if(add != null && add.equals("false"))
			{
				cart.remove(id);
			}
			

		}
		%>
		
		<div class="w3-container w3-light-gray">
			<br>
			<div class="w3-container w3-transparent w3-left w3-xxlarge">
				<h2>Shopping Cart</h2>
			</div>
			<br>
			<br>
			<br>
			
			<center>
			
			<%
			
			if(cart.size() == 0)
			{
				%>
				<h2>Cart Empty</h2>
				<br>
				<br>
				<form action="/BrickBreakerMovies/MainPage.jsp" method="get">
					<button type="submit" class="btn-link">Continue Shopping</button>
				</form>
				<%
			}
			else
			{
			%>
			
			<div>
				<TABLE border>
					<tr>
						<td>Movie Title</td>
						<td>Qty</td>
					</tr>
					
					<%
					
					Iterator it = cart.entrySet().iterator();
					while(it.hasNext())
					{
						Map.Entry pair = (Map.Entry)it.next();
						rs = statement.executeQuery("SELECT * FROM movies where id=" + pair.getKey() + ";");
						rs.next();
						out.println("<tr><td>" + rs.getString("title") + "</td>");
						%>
						<td>
						<form action="/BrickBreakerMovies/ShoppingCart.jsp?id=<%out.println(pair.getKey());%>" method="post">
							<input type="TEXT" name="qty" value=<%out.println(pair.getValue());%>><br><br>
							<button type="submit" value="id=<%out.println(pair.getKey());%>" class="btn-link">Update</button>
						</form>&nbsp
						<form action="/BrickBreakerMovies/ShoppingCart.jsp?id=<%out.println(pair.getKey());%>&add=false" method="post">
							<button type="submit" class="btn-link">Delete</button>
						</form>
						</td>
						<%
					}
					%>
				
				</TABLE>
			</div>
			<br>
			<br>
			<form action="/BrickBreakerMovies/Checkout.jsp" method="get">
				<button type="submit" class="btn-link">Checkout</button>
			</form>
			<%
			}
			%>
			</center>
			</div>
			

	</body>
</html>
	
<%
}
%>