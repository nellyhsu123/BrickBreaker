import java.io.*;
import java.util.Calendar;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;

public class MoviePopUp extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
                               throws ServletException, IOException
	{ // '<div style="border:2px solid #000000; width:207px; height:100px; padding:0px 0px 0px 0px">Suggestion Box</div>'
		String loginUser = "mytestuser";
		String loginPasswd = "mypassword";
		String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

		response.setContentType("text/html");    // Response mime type

		// Output stream to STDOUT
		PrintWriter out = response.getWriter();


		//out.println("<div style=\"position: relative; word-wrap: break-word; border:2px solid #000000; width:207px; height:100px; padding:0px 0px 0px 0px\">" + req.getParameter("input") + "</div>");
		String output = "";
		
		try
		{
			//Class.forName("org.gjt.mm.mysql.Driver");
			Class.forName("com.mysql.jdbc.Driver").newInstance();

			Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
			// Declare our statement
			Statement statement = dbcon.createStatement();
			Statement g_statement = dbcon.createStatement();
			Statement s_statement = dbcon.createStatement();
			Statement link_state = dbcon.createStatement();

			ResultSet rs;
			ResultSet g_rs;
			ResultSet s_rs;
			ResultSet link_rs;

			int id = Integer.parseInt(request.getParameter("id"));

			String search_query = "SELECT * FROM movies WHERE id = " + id + ";";
			rs = statement.executeQuery(search_query);
			rs.next();
			
			
			output += "<div onmouseleave=\"hidePopup(" + request.getParameter("num") + ")\" class=\"w3-panel w3-orange w3-card-4 w3-round-xlarge w3-center\"" +
										" style=\"position: absolute; left:-20px; top:-30px; word-wrap: break-word;" +
										" border: 2px solid #000000; width:800px; max-width:800px; padding:0px 0px 0px 0px\">" + 
										"<br>";
			output += "<div class=\"w3-container w3-left\"><a href=\"/BrickBreakerMovies/MoviePage.jsp?id=" + rs.getInt("id") +
						"\"><img src='" + rs.getString("banner_url") + "' width=150 height=210 title=\"" + rs.getString("title") +
						"\" alt=" + rs.getString("title") + "></a></div>";
			output += "<div style=\"text-align:left\" class=\"w3-container w3-left\">";
			output += "Year: " + rs.getInt("year") + "<br><br>";
			output += "ID: " + rs.getInt("id") + "<br><br>";
			output += "Director: " + rs.getString("director") + "<br><br>";
			
			g_rs = g_statement.executeQuery("SELECT * FROM genres where id in (SELECT genre_id FROM genres_in_movies where movie_id=" + rs.getInt("id") + ");");
			s_rs = s_statement.executeQuery("SELECT * FROM stars where id IN (SELECT star_id FROM stars_in_movies WHERE movie_id=" + rs.getInt("id") + ");");
				
			output += "Genres: ";
			
			while(g_rs.next())
			{
				output += "<a href=/BrickBreakerMovies/MovieList.jsp?genre=" + g_rs.getString("name") + ">" + g_rs.getString("name") + "</a>";
							
				if(!g_rs.isLast())
					output += ", ";
			}
			output += "<br><br>Stars: ";
			while(s_rs.next())
			{
				output += "<a href=/BrickBreakerMovies/StarPage.jsp?id=" + s_rs.getInt("id") + ">" + s_rs.getString("first_name") + " " + s_rs.getString("last_name") + "</a>";
				
				if(!s_rs.isLast())
					output += ", ";
			}
			
			output += "<br><br>";
			output += "Trailer: <a href=\"" + rs.getString("trailer_url") +"\"> Click Here for Trailer</a>";
			output += "<br>";
			
			output += "<form action=\"/BrickBreakerMovies/ShoppingCart.jsp?id=" + rs.getInt("id") + "&add=true\" method=\"post\">";
			output += "<button type=\"submit\" class=\"btn-link\">Add to Cart</button></form>";


			output += "</div></div>";
			out.println(output);
		}
		catch (SQLException ex) {
			  while (ex != null) {
					System.out.println ("SQL Exception:  " + ex.getMessage ());
					ex = ex.getNextException ();
				}  // end while
			}  // end catch SQLException

		catch(java.lang.Exception ex)
		{
			out.println("<HTML>" +
						"<HEAD><TITLE>" +
						"MovieDB: Error" +
						"</TITLE></HEAD>\n<BODY>" +
						"<P>SQL error in doGet: " +
						ex.getMessage() + "</P></BODY></HTML>");
			return;
		}
		out.close();
	}
}
