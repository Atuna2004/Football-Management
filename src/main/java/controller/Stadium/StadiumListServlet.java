package controller.Stadium;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import dao.StadiumDAO;
import model.Stadium;

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

        StadiumDAO dao = new StadiumDAO();
        List<Stadium> allStadiums = dao.getAllStadiums();

        // Debug log kiểm tra dữ liệu lấy được
        System.out.println("Total stadiums from DB: " + allStadiums.size());
        for (Stadium s : allStadiums) {
            System.out.println("Stadium: " + s.getName() + ", Location: " + s.getLocation());
        }

        int totalStadiums = allStadiums.size();
        int totalPages = (int) Math.ceil((double) totalStadiums / RECORDS_PER_PAGE);

        // Giới hạn page không vượt quá tổng trang
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
        }

        int start = (page - 1) * RECORDS_PER_PAGE;
        int end = Math.min(start + RECORDS_PER_PAGE, totalStadiums);

        List<Stadium> pagedStadiums = allStadiums.subList(start, end);

        System.out.println("Page: " + page + ", Start: " + start + ", End: " + end);
        System.out.println("Stadiums to send to JSP: " + pagedStadiums.size());

        request.setAttribute("stadiums", pagedStadiums);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/stadium/footballField.jsp").forward(request, response);
    }
}
