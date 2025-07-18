package controller.FieldOwner;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import dao.StadiumDAO;
import model.Stadium;
import model.User;

@WebServlet("/fieldOwner/FOSTD")
public class StadiumFOListServlet extends HttpServlet {
    private static final int RECORDS_PER_PAGE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Check if not logged in or not a field owner
        if (currentUser == null) {
            session.setAttribute("errorMessage", "Please log in to continue.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        Integer ownerId = currentUser.getUserID();

        // Handle pagination
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

        StadiumDAO stadiumDAO = new StadiumDAO();

        // Get total number of stadiums owned by this user
        int totalStadiums = stadiumDAO.getTotalStadiumCountByOwnerId(ownerId);
        int totalPages = (int) Math.ceil((double) totalStadiums / RECORDS_PER_PAGE);

        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        // Get paginated list of stadiums for the owner
        List<Stadium> pagedStadiums = stadiumDAO.getStadiumsByOwnerIdAndPage(ownerId, page, RECORDS_PER_PAGE);

        // Pass data to JSP
        request.setAttribute("stadiums", pagedStadiums);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Forward to JSP
        request.getRequestDispatcher("/fieldOwner/StadiumList.jsp").forward(request, response);
    }
}
