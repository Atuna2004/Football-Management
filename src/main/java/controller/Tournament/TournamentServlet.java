package controller.Tournament;

import dao.StadiumDAO;
import dao.TournamentDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Stadium;
import model.Tournament;
import model.User;

@WebServlet("/tournament")
public class TournamentServlet extends HttpServlet {

    TournamentDAO dao = new TournamentDAO();
    StadiumDAO stadiumDAO = new StadiumDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) request.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/account/login.jsp");
            return;
        }
        int ownerId = currentUser.getUserID();
        List<Stadium> stadiums = stadiumDAO.getStadiumsByOwnerId(ownerId);
        request.setAttribute("stadiums", stadiums);

        String action = request.getParameter("action");
        if (action == null) action = "list";

        // Lấy danh sách giải đấu (có thể cần cập nhật để lọc theo ownerId nếu cần)
        List<Tournament> list = dao.getAll(); // <-- Kiểm tra lại logic nếu cần lọc theo owner
        request.setAttribute("list", list);

        // Forward tới JSP
        request.getRequestDispatcher("fieldOwner/tournamentSoccer/listTour.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Gọi lại doGet để hiển thị lại trang
    }

    @Override
    public String getServletInfo() {
        return "Servlet for managing tournaments";
    }
}