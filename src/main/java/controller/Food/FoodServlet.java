package controller.Food;

import dao.FoodItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.FoodItem;

import java.io.IOException;
import java.util.List;

@WebServlet("/food")
public class FoodServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String stadiumIdRaw = request.getParameter("stadiumId");
        String bookingIdRaw = request.getParameter("bookingId"); // bookingId được tạo từ servlet trước đó

        if (stadiumIdRaw == null || bookingIdRaw == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu thông tin timeslot hoặc sân.");
            return;
        }

        int stadiumId;
        int bookingId;
        try {
            stadiumId = Integer.parseInt(stadiumIdRaw);
            bookingId = Integer.parseInt(bookingIdRaw);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ.");
            return;
        }

        // Lấy danh sách món ăn theo sân
        FoodItemDAO foodDao = new FoodItemDAO();
        List<FoodItem> foodList = foodDao.getFoodItemsByStadium(stadiumId);

        // Gửi dữ liệu sang JSP
        request.setAttribute("foodList", foodList);
        request.setAttribute("stadiumId", stadiumId);
        request.setAttribute("bookingId", bookingId);

        // Logging
        System.out.println("stadiumId = " + stadiumId);
        System.out.println("bookingId = " + bookingId);
        System.out.println("Số món ăn lấy được: " + foodList.size());

        // Forward sang food.jsp
        request.getRequestDispatcher("food.jsp").forward(request, response);
    }
}
