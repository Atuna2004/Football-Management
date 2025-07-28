// controller.FieldOwner.RevenueReportServlet.java

package controller.FieldOwner;

import dao.StadiumDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Stadium;
import model.User;

@WebServlet(name = "RevenueReportServlet", urlPatterns = {"/revenue-report"})
public class RevenueReportServlet extends HttpServlet {

    private StadiumDAO stadiumDAO = new StadiumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        if (session == null || currentUser == null || !"Owner".equals(currentUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }

        try {
            List<Stadium> stadiums = stadiumDAO.getStadiumsByOwner(currentUser.getUserID());
            // Truyền danh sách sân vào request để JSP lấy được
            request.setAttribute("stadiums", stadiums);
            request.getRequestDispatcher("/fieldOwner/revenueReport.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải danh sách sân: " + e.getMessage());
            request.getRequestDispatcher("/fieldOwner/revenueReport.jsp").forward(request, response);
        }
    }
}