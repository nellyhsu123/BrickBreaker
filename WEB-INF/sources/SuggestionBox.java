import java.io.*;
import java.util.Calendar;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;

public class SuggestionBox extends HttpServlet {

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
		String output = "<div class=\"w3-container w3-white\" style=\"position: absolute; left:0px; top:0px; word-wrap: break-word; border: 2px solid #000000; width:207px; padding:0px 0px 0px 0px\">";

		try
		{
		  //Class.forName("org.gjt.mm.mysql.Driver");
		  Class.forName("com.mysql.jdbc.Driver").newInstance();

		  Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
		  // Declare our statement
		  Statement statement = dbcon.createStatement();
		  Statement link_state = dbcon.createStatement();
		  
		  ResultSet rs;
		  ResultSet link_rs;

		  String[] input = request.getParameter("input").split(" ");
		  
		  String search_query = "SELECT title FROM movies WHERE MATCH (title) AGAINST (\"";
		  for(int i = 0; i < input.length; ++i)
		  {
			  search_query += "+" + input[i] + "*";
			  if(i != input.length-1)
				  search_query += " ";
		  }
		  
		  search_query += "\" IN BOOLEAN MODE) LIMIT 10;";
		  
		  rs = statement.executeQuery(search_query);
		  
		  int len = 0;
		  while(rs.next())
		  {
			  ++len;
			  String temp_title = rs.getString("title");
			  link_rs = link_state.executeQuery("SELECT id FROM movies WHERE title = \"" + temp_title + "\";");
			  link_rs.next();
			  int id = link_rs.getInt("id");
			  output += "<a href=/BrickBreakerMovies/MoviePage.jsp?id=" + id + ">" + temp_title + "</a>";
			  if(!rs.isLast())
				  output += "<br>";
		  }
		  
		  output += "</div>";
		  if(len == 0)
			  output = "";
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
