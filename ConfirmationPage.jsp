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

String loginUser = "mytestuser";
String loginPassword = "mypassword";
String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

response.setContentType("text/html");

Class.forName("com.mysql.jdbc.Driver").newInstance();

Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPassword);

Statement statement = dbcon.createStatement();

ResultSet rs = statement.executeQuery("SELECT count(*) FROM creditcards where id='" + request.getParameter("id") +
														 "' AND first_name='" + request.getParameter("first_name") +
														 "' AND last_name='" + request.getParameter("last_name") +
														 "' AND expiration='" + request.getParameter("exp_date") + "';");
rs.next();
if(rs.getInt(1) == 0)
{
	response.sendRedirect("/BrickBreakerMovies/Checkout.jsp?er=true");
	return;
}

HashMap<Integer, Integer> cart = (HashMap)this_session.getAttribute("cart");
Iterator it = cart.entrySet().iterator();

while(it.hasNext())
{
	Map.Entry pair = (Map.Entry)it.next();
	for(int i = 0; i < (Integer)pair.getValue(); ++i)
	{
		statement.executeUpdate("INSERT INTO sales (customer_id, movie_id, sale_date) VALUES (" + this_session.getAttribute("id") + ", " + pair.getKey() + ", NOW()" + ");");
	}
}

this_session.removeAttribute("cart");													 

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
			<a href="/BrickBreakerMovies/index.jsp?out=true">Sign Out</a>
		</div>
	</header>
		
	<div class="w3-container w3-light-gray">
		<h1>Order Successfully Submitted</h1>
		<br>
		<br>
		<form action="/BrickBreakerMovies/MainPage.jsp" method="get">
			<button type="submit" class="btn-link">Continue Shopping</button>
		</form>
	</div>

</body>
</html>
