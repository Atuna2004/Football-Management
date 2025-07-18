package controller.FieldOwner;

import dao.StadiumDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Stadium;
import model.User;

@WebServlet("/LoadStadiumListServlet")
public class LoadStadiumListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        // Lấy OwnerID từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentUser") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Bạn chưa đăng nhập");
            return;
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        int ownerId = currentUser.getUserID();
        
        // Ghi log vào catalina.log
        getServletContext().log("OwnerId từ session: " + ownerId);
        
        StadiumDAO stadiumDAO = new StadiumDAO();
        List<Stadium> stadiums = stadiumDAO.getStadiumsByOwner(ownerId);
        
        // Ghi log số lượng sân tìm được
        getServletContext().log("Số sân tìm được: " + stadiums.size());
        
        StringBuilder sb = new StringBuilder();
        for (Stadium s : stadiums) {
            // Đảm bảo format chính xác: ID:Name;
            sb.append(s.getStadiumID()).append(":").append(s.getName()).append(";");
            getServletContext().log("Stadium added: ID=" + s.getStadiumID() + ", Name=" + s.getName());
        }
        
        String result = sb.toString();
        getServletContext().log("Dữ liệu trả về: '" + result + "'");
        
        // Đặt response headers
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(result);
    }
}