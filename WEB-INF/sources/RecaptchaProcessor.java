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

import javax.naming.InitialContext;
import javax.naming.Context;

public class RecaptchaProcessor extends HttpServlet
{
    public String getServletInfo()
    {
       return "Servlet connects to MySQL database and displays result of a SELECT";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
		HttpSession session = request.getSession();
        PrintWriter out = response.getWriter();

		String gRecaptchaResponse = request.getParameter("g-recaptcha-response");
		
		// Verify CAPTCHA.
		boolean valid = VerifyUtils.verify(gRecaptchaResponse);
		if (valid)
		{
			String loginUser = "mytestuser";
			String loginPassword = "mypassword";
			String loginUrl = "jdbc:mysql://localhost:3306/moviedb";

			try
			{
				Context initCtx = new InitialContext();
				if (initCtx == null)
					out.println("initCtx is NULL");

				Context envCtx = (Context) initCtx.lookup("java:comp/env");
				if (envCtx == null)
					out.println("envCtx is NULL");
				
				DataSource ds = (DataSource) envCtx.lookup("jdbc/moviedb");

				Connection dbcon = ds.getConnection();

				Statement statement = dbcon.createStatement();
				
				String count_query = "SELECT count(*) from customers where email = '" + request.getParameter("email") + "' AND password = '" + request.getParameter("password") + "';";
				String query = "SELECT * from customers where email = '" + request.getParameter("email") + "' AND password = '" + request.getParameter("password") + "';";
				ResultSet rs = statement.executeQuery(count_query);
				rs.next();
				
				
				if(session.getAttribute("loginSuccess") == null)
					session.setAttribute("loginSuccess", false);
				
				if(rs.getInt(1) == 0 && !(boolean)session.getAttribute("loginSuccess"))
				{
					rs.close();
					session.setAttribute("loginSuccess", false);
							
					response.sendRedirect("/BrickBreakerMovies/index.jsp?er=true");
					return;
				}
				else
				{
					if(rs.getInt(1) != 0)
					{
						rs.close();
						rs = statement.executeQuery(query);
						rs.next();
						session.setAttribute("id", rs.getInt("id"));
					}
					session.setAttribute("loginSuccess", true);
				}
			
			
				response.sendRedirect("/BrickBreakerMovies/MainPage.jsp");
				return;
			}
			catch (Exception ex)
			{
				System.out.println(ex.getMessage());
			}
		}
		else
		{
			session.setAttribute("loginSuccess", false);
					
			response.sendRedirect("/BrickBreakerMovies/index.jsp?er=true");
			return;
		}
		
		out.close();
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException
    {
		doGet(request, response);
    }
}
