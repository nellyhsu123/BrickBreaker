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

public class InsertMovie extends HttpServlet
{

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
		HttpSession session = request.getSession();
		
		if(session.getAttribute("empLoginSuccess") == null || !(boolean)session.getAttribute("empLoginSuccess"))
		{
			session.setAttribute("empLoginSuccess", false);
			response.sendRedirect("/BrickBreakerMovies/_dashboard.jsp?er=true");
			return;
		}
		
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
			
			String title = request.getParameter("title");
			String year = request.getParameter("year");
			String director = request.getParameter("dir");
			String banner_url = request.getParameter("banner_url");
			String trailer_url = request.getParameter("trailer_url");
			String star_first = request.getParameter("star_first");
			String star_last = request.getParameter("star_last");
			String dob = request.getParameter("dob");
			String star_photo_url = request.getParameter("photo_url");
			String genre_name = request.getParameter("genre");
			
			String insert_command = "CALL add_movie('" + title + "', " + year + ", '" + director + "', '" + banner_url + "', '" +
										trailer_url + "', '" + star_first + "', '" + star_last + "', '" + dob + "', '" + star_photo_url + "', '" +
										genre_name + "');";
			try
			{
				ResultSet rs = statement.executeQuery(insert_command);
				rs.next();
				
				response.sendRedirect("/BrickBreakerMovies/EmployeeDashboard.jsp?m_added=" + rs.getString(1));
			}
			catch(SQLException ex)
			{
				System.out.println(ex.getMessage());
				response.sendRedirect("/BrickBreakerMovies/EmployeeDashboard.jsp?m_added=false");
				return;
			}
			catch(Exception ex)
			{
				throw ex;
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
