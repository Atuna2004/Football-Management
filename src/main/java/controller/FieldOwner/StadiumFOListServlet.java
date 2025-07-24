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

        if (currentUser == null) {
            session.setAttribute("errorMessage", "Vui lòng đăng nhập để tiếp tục.");
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        Integer ownerId = currentUser.getUserID();
        StadiumDAO stadiumDAO = new StadiumDAO();

        // 🔹 LẤY TỪ KHÓA TÌM KIẾM
        String search = request.getParameter("search");
        if (search == null) search = "";

        // 🔹 PHÂN TRANG
        int page = 1;
        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) page = Integer.parseInt(pageParam);
            if (page < 1) page = 1;
        } catch (NumberFormatException e) {
            page = 1;
        }

        List<Stadium> pagedStadiums;
        int totalStadiums;
        int totalPages;

        // 🔹 XỬ LÝ TÌM KIẾM
        if (search.trim().isEmpty()) {
            // Không tìm kiếm: lấy tất cả sân
            totalStadiums = stadiumDAO.getTotalStadiumCountByOwnerId(ownerId);
            totalPages = (int) Math.ceil((double) totalStadiums / RECORDS_PER_PAGE);
            pagedStadiums = stadiumDAO.getStadiumsByOwnerIdAndPage(ownerId, page, RECORDS_PER_PAGE);
        } else {
            // Có tìm kiếm
            totalStadiums = stadiumDAO.getTotalSearchCountByOwner(ownerId, search);
            totalPages = (int) Math.ceil((double) totalStadiums / RECORDS_PER_PAGE);
            pagedStadiums = stadiumDAO.searchStadiumsByOwner(ownerId, search, page, RECORDS_PER_PAGE);
        }

        // 🔹 Kiểm tra trang vượt quá
        if (page > totalPages && totalPages > 0) {
            page = totalPages;
            if (search.trim().isEmpty()) {
                pagedStadiums = stadiumDAO.getStadiumsByOwnerIdAndPage(ownerId, page, RECORDS_PER_PAGE);
            } else {
                pagedStadiums = stadiumDAO.searchStadiumsByOwner(ownerId, search, page, RECORDS_PER_PAGE);
            }
        }

        // 🔹 GỬI DỮ LIỆU VỀ JSP
        request.setAttribute("stadiums", pagedStadiums);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("search", search); // để giữ lại ô tìm kiếm

        // 🔹 Chuyển đến JSP
        request.getRequestDispatcher("/fieldOwner/StadiumList.jsp").forward(request, response);
    }
}