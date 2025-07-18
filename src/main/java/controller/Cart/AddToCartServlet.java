package controller.Cart;

import dao.FoodItemDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.FoodItem;
import model.CartItem;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/add-to-cart")
public class AddToCartServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get parameters from the form
            String foodItemIdRaw = request.getParameter("foodItemId");
            String stadiumIdRaw = request.getParameter("stadiumId");
            String bookingIdRaw = request.getParameter("bookingId");
            String quantityRaw = request.getParameter("quantity");

            // Null check
            if (foodItemIdRaw == null || stadiumIdRaw == null || bookingIdRaw == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters.");
                return;
            }

            int foodItemId = Integer.parseInt(foodItemIdRaw);
            int stadiumId = Integer.parseInt(stadiumIdRaw);
            int bookingId = Integer.parseInt(bookingIdRaw);

            int quantity = 1; // Default value
            if (quantityRaw != null) {
                try {
                    quantity = Integer.parseInt(quantityRaw);
                    if (quantity < 1) {
                        quantity = 1;
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            // Get cart from session
            HttpSession session = request.getSession();
            List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

            if (cart == null) {
                cart = new ArrayList<>();
            }

            boolean exists = false;
            for (CartItem item : cart) {
                if (item.getFoodItem().getFoodItemID() == foodItemId) {
                    item.setQuantity(item.getQuantity() + quantity);
                    exists = true;
                    break;
                }
            }

            if (!exists) {
                FoodItemDAO dao = new FoodItemDAO();
                FoodItem food = dao.getFoodItemById(foodItemId);
                if (food != null) {
                    cart.add(new CartItem(food, quantity));
                }
            }

            session.setAttribute("cart", cart);

            // Redirect back to food page with correct parameters
            response.sendRedirect("food?stadiumId=" + stadiumId + "&bookingId=" + bookingId);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid parameters.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
