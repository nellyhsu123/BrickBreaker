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

public class MobileSearchResponse extends HttpServlet
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
			
			String search = request.getParameter("search");
			int pg = Integer.parseInt(request.getParameter("pg"));
			
			String count_query = "SELECT COUNT(*) from movies WHERE MATCH (title) AGAINST(\"";
			String query = "SELECT * from movies WHERE MATCH (title) AGAINST(\"";
			
			String[] temp_title = search.split(" ");
			String end_of_query = "";
			for(int i = 0; i < temp_title.length; ++i)
			{
				end_of_query += "+" + temp_title[i] + "* ";
			}
			end_of_query += "\" IN BOOLEAN MODE)";
			
			String finisher = " LIMIT 5 OFFSET " + ((pg-1)*5) + ";";
			
			ResultSet rs = statement.executeQuery(query+end_of_query+finisher);
			
			while(rs.next())
			{
				out.print(rs.getString("title") + "@@@" + rs.getInt("id"));
				if(!rs.isLast())
				{
					out.print("|||");
				}
			}
			out.print("\n");
			
			rs = statement.executeQuery(count_query+end_of_query+";");
			rs.next();
			int movie_count = rs.getInt(1);
			
			if((pg*5) < movie_count)
			{
				// has next page
				out.print("1");
			}
			else
			{
				// too big
				out.print("0");
			}
			
			out.print("\n" + (movie_count+4)/5);
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
