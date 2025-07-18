package controller.Stadium;

import dao.StadiumDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.Stadium;

@WebServlet("/stadium-detail")
public class StadiumDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("stadiumId");
        if (idStr == null) {
            response.sendRedirect("stadiums");
            return;
        }

        int stadiumId = Integer.parseInt(idStr);
        StadiumDAO dao = new StadiumDAO();
        Stadium stadium = dao.getStadiumById(stadiumId); // you need to have this method

        if (stadium == null) {
            request.setAttribute("errorMessage", "Stadium not found.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        request.setAttribute("stadium", stadium);
        request.getRequestDispatcher("/stadium/stadium-detail.jsp").forward(request, response);
    }
}