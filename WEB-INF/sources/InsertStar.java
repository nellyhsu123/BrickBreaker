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

public class InsertStar extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet connects to MySQL database and inserts a star to the database";
    }

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
			
			String count_query = "SELECT count(*) from stars where first_name = '" + request.getParameter("first_name") + "' AND last_name = '" + request.getParameter("last_name") + "';";
			ResultSet rs = statement.executeQuery(count_query);
			rs.next();
			
			
			if(rs.getInt(1) > 0)
			{
				// go back to emp dash w/ error message saying that star already exists
				response.sendRedirect("/BrickBreakerMovies/EmployeeDashboard.jsp?s_added=false");
				return;
			}
			rs.close();
			
			try
			{
				int added = statement.executeUpdate("INSERT INTO stars (first_name, last_name, dob, photo_url) VALUES ('" +
										request.getParameter("first_name") + "', '" + request.getParameter("last_name") +
										"', '" + request.getParameter("dob") + "', '" + request.getParameter("photo_url") + "');");
				
				if(added > 0)
				{
					response.sendRedirect("/BrickBreakerMovies/EmployeeDashboard.jsp?s_added=true");
				}
				else
				{
					response.sendRedirect("/BrickBreakerMovies/EmployeeDashboard.jsp?s_added=false");
				}
			}
			catch(SQLException ex)
			{
				response.sendRedirect("/BrickBreakerMovies/EmployeeDashboard.jsp?s_added=false");
				return;
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
