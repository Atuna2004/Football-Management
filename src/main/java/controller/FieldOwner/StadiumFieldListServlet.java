package controller.FieldOwner;

import connect.DBConnection;
import dao.FieldDAO;
import dao.StadiumDAO;
import model.Field;
import model.Stadium;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/fieldOwner/StadiumFieldList")
public class StadiumFieldListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String stadiumIdStr = request.getParameter("id");
        int stadiumId = Integer.parseInt(stadiumIdStr);

        DBConnection conn = new DBConnection();

        try {
            FieldDAO fieldDAO = new FieldDAO(conn);
            List<Field> fields = fieldDAO.getFieldsByStadiumId(stadiumId);

            // Lấy thông tin sân từ StadiumDAO
            StadiumDAO stadiumDAO = new StadiumDAO();
            Stadium stadium = stadiumDAO.getStadiumById(stadiumId);

            // Set dữ liệu vào request để gửi sang JSP
            request.setAttribute("fields", fields);
            request.setAttribute("stadiumId", stadiumId);
            request.setAttribute("stadiumName", stadium.getName()); // <-- đây là phần bạn cần

            RequestDispatcher dispatcher = request.getRequestDispatcher("/fieldOwner/StadiumFieldList.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}