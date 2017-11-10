/*


Servlet to output to BrickBreakerMobile

This uses three vertical lines ||| to indicate separation between movie attributes
and \n characters to separate differing lists of info. The genres and stars lists output
in the format that they will be used in the app.

Outputs in the format:


movie.id|||movie.id|||movie.year|||movie.director
genre.name, genre.name, ..., genre.name
star.first_name star.lastname, ...,  star.first_name star.lastname


*/



import java.io.*;
import java.net.*;
import java.sql.*;
import java.text.*;
import java.util.*;
import javax.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MobileMoviePage extends HttpServlet
{
    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
        PrintWriter out = response.getWriter();
		
		String loginUser = "mytestuser";
		String loginPassword = "mypassword";
		String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

		try
		{
			response.setContentType("text/html");

			Class.forName("com.mysql.jdbc.Driver").newInstance();

			Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPassword);

			Statement statement = dbcon.createStatement();
			Statement g_statement = dbcon.createStatement();
			Statement s_statement = dbcon.createStatement();
			
			String id = request.getParameter("id");
			
			String query = "SELECT * from movies WHERE id=" + id + ";";
			
			ResultSet rs = statement.executeQuery(query);
			rs.next();
			
			out.println(rs.getInt("id") + "|||" + rs.getString("title") + "|||" + rs.getInt("year") + 
						"|||" + rs.getString("director"));
			String genre_query = "SELECT * FROM genres where id in (SELECT genre_id FROM genres_in_movies where movie_id=" + id + ");";
			String star_query = "SELECT * FROM stars where id IN (SELECT star_id FROM stars_in_movies WHERE movie_id=" + id + ");";
			
			ResultSet g_rs = g_statement.executeQuery("SELECT * FROM genres where id in (SELECT genre_id FROM genres_in_movies where movie_id=" + id + ");");
			ResultSet s_rs = s_statement.executeQuery("SELECT * FROM stars where id IN (SELECT star_id FROM stars_in_movies WHERE movie_id=" + id + ");");
			
			// Genres
			while(g_rs.next())
			{
				out.print(g_rs.getString("name"));
				
				if(!g_rs.isLast())
					out.print(", ");
				else
					out.print("\n");
			}
			
			// Stars
			while(s_rs.next())
			{
				out.print(s_rs.getString("first_name") + " " + s_rs.getString("last_name"));
				
				if(!s_rs.isLast())
					out.print(", ");
			}
		}
		catch (Exception ex)
		{
			System.out.println(ex.getMessage());
		}
		
		out.close();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
		doGet(request, response);
    }
}
