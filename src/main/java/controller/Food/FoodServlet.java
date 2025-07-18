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
        String bookingIdRaw = request.getParameter("bookingId"); // bookingId created from previous servlet

        if (stadiumIdRaw == null || bookingIdRaw == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing timeslot or stadium information.");
            return;
        }

        int stadiumId;
        int bookingId;
        try {
            stadiumId = Integer.parseInt(stadiumIdRaw);
            bookingId = Integer.parseInt(bookingIdRaw);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters.");
            return;
        }

        // Retrieve food items by stadium ID
        FoodItemDAO foodDao = new FoodItemDAO();
        List<FoodItem> foodList = foodDao.getFoodItemsByStadium(stadiumId);

        // Pass data to JSP
        request.setAttribute("foodList", foodList);
        request.setAttribute("stadiumId", stadiumId);
        request.setAttribute("bookingId", bookingId);

        // Logging
        System.out.println("stadiumId = " + stadiumId);
        System.out.println("bookingId = " + bookingId);
        System.out.println("Number of food items retrieved: " + foodList.size());

        // Forward to food.jsp
        request.getRequestDispatcher("food.jsp").forward(request, response);
    }
}
