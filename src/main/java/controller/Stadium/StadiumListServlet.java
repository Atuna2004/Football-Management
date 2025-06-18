package controller.Stadium;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import dao.StadiumDAO;
import model.Stadium;

import java.io.IOException;
import java.util.List;

@WebServlet("/stadiums")
public class StadiumListServlet extends HttpServlet {
    private static final int RECORDS_PER_PAGE = 15;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String location = request.getParameter("location");
        if (location != null) {
            location = location.trim();
            if (location.isEmpty()) {
                location = null;
            }
        }

        StadiumDAO dao = new StadiumDAO();
        List<Stadium> allStadiums = (location != null)
                ? dao.getStadiumsByLocation(location)
                : dao.getAllStadiums();

        List<String> allLocations = dao.getDistinctLocations();

        int totalStadiums = allStadiums.size();
        int totalPages = (int) Math.ceil((double) totalStadiums / RECORDS_PER_PAGE);
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        int start = (page - 1) * RECORDS_PER_PAGE;
        int end = Math.min(start + RECORDS_PER_PAGE, totalStadiums);
        List<Stadium> pagedStadiums = allStadiums.subList(start, end);

        request.setAttribute("stadiums", pagedStadiums);
        request.setAttribute("locations", allLocations);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("selectedLocation", location);

        request.getRequestDispatcher("/stadium/footballField.jsp").forward(request, response);
    }
}
